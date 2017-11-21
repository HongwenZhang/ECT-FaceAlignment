import argparse
import sys
import os, os.path
import pickle
import scipy
import matplotlib.pyplot as plt
import numpy as np
from menpo.visualize import print_progress
from pylab import *

import menpo.io as mio
from menpofit.clm import CLM, FcnFilterExpertEnsemble
from menpofit.clm import GradientDescentCLMFitter
from menpo.visualize import print_dynamic
from menpo.shape.pointcloud import PointCloud
from menpofit.fitter import noisy_shape_from_bounding_box
from menpofit.error import euclidean_distance_indexed_normalised_error
from menpofit.error import euclidean_distance_normalised_error
from menpofit.error import inner_pupil

import rspimage

# initial the caffe net
os.environ['GLOG_minloglevel'] = '1'
caffe_root = '../caffe/'
sys.path.insert(0, caffe_root + 'python')
import caffe

def main(args):

    if args.gpus != None:
        caffe.set_device(args.gpus)
        caffe.set_mode_gpu()
    else:
        caffe.set_mode_cpu()

    # load FCN model
    net = caffe.Net(args.prototxt, args.model, caffe.TEST)

    transformer = caffe.io.Transformer({'data': net.blobs['data'].data.shape})
    transformer.set_transpose('data', (2,0,1))  # move image channels to outermost dimension
    transformer.set_raw_scale('data', 255)      # rescale from [0, 1] to [0, 255]
    #transformer.set_channel_swap('data', (2,1,0))  # swap channels from RGB to BGR

    # load PDM model
    fit_model_file = open('PDM_300w.pic', 'r')
    fit_model = pickle.load(fit_model_file)
    fit_model_file.close()

    # parameters for weighted regularized mean-shift
    fit_model.opt = dict()
    fit_model.opt['numIter'] = args.nIter
    fit_model.opt['kernel_covariance'] = 10
    fit_model.opt['sigOffset'] = 25
    fit_model.opt['sigRate'] = 0.25
    fit_model.opt['pdm_rho'] = 20
    fit_model.opt['verbose'] = args.verbose
    fit_model.opt['rho2'] = 20
    fit_model.opt['dataset'] = 'demo'
    fit_model.opt['ablation'] = (True, True)
    fit_model.opt['ratio1'] = 0.12
    fit_model.opt['ratio2'] = 0.08
    fit_model.opt['imgDir'] = args.imgDir
    fit_model.opt['smooth'] = True

    fitter = GradientDescentCLMFitter(fit_model, n_shape=[args.nComponent])

    p2pErrs = []
    fitting_results = []
    indexCount = 0
    imageList = mio.import_images(args.imgDir, verbose=True)
    indexAll = len(imageList)
    for i in imageList:
        # input images with size of 256x256
        if i.shape[0] != i.shape[1] or i.shape[0] != 256:
            zoomImg = scipy.ndimage.zoom(i.pixels, zoom=[1, 256 / float(i.shape[1]), 256 / float(i.shape[1])])
            i.pixels = zoomImg
        # check whether the ground-truth is provided or not
        try:
            i.landmarks['PTS']
        except:
            i.landmarks['PTS'] = fit_model.reference_shape
        # Estimation step, get response maps from FCN
        net.blobs['data'].data[...] = transformer.preprocess('data', np.rollaxis(i.pixels, 0, 3))
        i.rspmap_data = np.array(net.forward()['upsample'])
        # zoom response maps
        # i.rspmap_data = scipy.ndimage.zoom(i.rspmap_data, zoom=[1, 1, float(i.height) / i.rspmap_data.shape[-2],
        #                                                               float(i.width) / i.rspmap_data.shape[-1]], order=1)  # mode = 'nearest'

        gt_s = i.landmarks['PTS'].lms
        s = rspimage.initial_shape_fromMap(i)
        # fit image
        fr = fitter.fit_from_shape(i, s, gt_shape=gt_s)
        fitting_results.append(fr)

        # calculate point-to-point Normalized Mean Error
        Err = euclidean_distance_normalised_error(fr.shapes[-1], fr.gt_shape, distance_norm_f=inner_pupil)
        p2pErrs.append(Err)

        text_file = open(args.outDir + i.path.stem + '.68pt', "w")
        np.savetxt(text_file, fr.shapes[-1].points, fmt='%d', newline='\n')
        text_file.close()

        indexCount = indexCount + 1
        # sys.stdout.write('{} done;'.format(i.path.name))
        sys.stdout.write('\r')
        sys.stdout.write('{}/{} Done; '.format(indexCount,indexAll))
        sys.stdout.flush()

    p2pErrs = np.array(p2pErrs)
    print('NormalizedMeanError: {:.4f}'.format(average(p2pErrs)))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='ECT for face alignment')

    parser.add_argument('--gpus', default=None, type=int, help='specify the gpu ID')
    parser.add_argument('--imgDir', default='../imgs/', type=str, help='path to test images')
    parser.add_argument('--outDir', default='../output/', type=str, help='path for saving prediction results')
    parser.add_argument('--prototxt', default='../caffe/models/300w/matlab.prototxt', type=str,
                        help='path to caffe model prototxt')
    parser.add_argument('--model', default='../model_data/300w_68pt.caffemodel', type=str,
                        help='path to the pre-trained caffe model')
    parser.add_argument('--verbose', default=True, help='show the landmark prediction results')
    parser.add_argument('--nIter', default=5, type=int, help='number of iterations for the turning step')
    parser.add_argument('--nComponent', default=30, type=int, help='number of PDM components to be used')

    main(parser.parse_args())
