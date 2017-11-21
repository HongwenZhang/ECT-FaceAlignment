% This file uses a FLIC trained model and applies it to a video sequence from Poses in the Wild
%
% Download the model:
%    wget http://tomas.pfister.fi/models/caffe-heatmap-flic.caffemodel -P ../../models/heatmap-flic-fusion/

% Options

opt.visualise = true;		% Visualise predictions?
opt.useGPU = false; 			% Run on GPU
opt.dims = [256 256]; 		% Input dimensions (needs to match matlab.txt)
opt.numJoints = 34; 			% Number of joints  68 for 300w
%opt.modelName = 'face68dilated2bilinearLP';  %face68test  VGGdilaDecovReg128 face68dilated2bilinear  VGGdilaFusion
opt.modelName = 'cross_loss';  %face29COFW  cross_loss primaryNet  VGGdilaFusion
opt.layerName = 'upsample'; % Output layer name   conv8 conv8_split   conv5_fusion upsample upsample3_crop Heatmap_fusion
%opt.modelDefFile = '../../models/face68concat/matlab.prototxt'; % Model definition
opt.modelDefFile = '../../models/face68dilaDecov2/matlab.prototxt'; % Model definition  face68dilaDecov2 face68LPfusion
%opt.modelFile = '../../data/face68map1_10-6fixed/snapshots/face68map_train_iter_50000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel
%opt.modelFile = '../../data/face68map_10-7fixed/snapshots/face68map_train_iter_100000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel
opt.modelFile = '../../data/face68dilaDecov2/snapshots/face68dilaDecov_train_iter_100000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel
%opt.modelFile = '../../data/face68LPfusion/snapshots/face68LPfusion_train_iter_200000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel
%opt.modelFile = '../../data/face68LPDecov/snapshots/face68dilaDecov_train_iter_150000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel
%opt.modelFile = '../../data/face68LPDecov1/snapshots/face68dilaDecov_train_iter_1000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel

opt.modelDefFile = strcat('../../models/',opt.modelName,'/matlab_eucl.prototxt'); % Model definition  face68dilaDecov2 face68LPfusion
opt.modelFile = strcat('/home/hongwen.zhang/model_data/',opt.modelName,'/snapshots_pifa_6/',opt.modelName,'_train_iter_100000.caffemodel'); %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel
%opt.modelFile = '~/model_data/face68dilated2bilinear/snapshots/face29COFW_train_iter_25000.caffemodel'; %   ../../models/heatmap-flic-fusion/caffe-heatmap-flic.caffemodel


% Add caffe matlab into path
addpath('../')

% Image input directory
opt.inputDir = 'sample_images/';
%opt.inputDir = 'profileSam/';

% Create image file list


file_imglist = fopen(strcat('../../matlab/pose/',opt.inputDir,'/Path_Images.txt'));  %sample_images  profileSam
files = textscan(file_imglist, '%s', 'delimiter', '\n');
files = files{1};

% imInds = 1:10;
% for ind = 1:numel(imInds); 
%     files{ind} = [num2str(imInds(ind)) '.jpg']; 
% end

% Apply network
joints = applyNet(files, opt)