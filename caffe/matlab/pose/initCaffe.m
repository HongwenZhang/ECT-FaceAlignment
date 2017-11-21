% Initialise Caffe
function net = initCaffe(opt)
if opt.useGPU
    caffe.set_mode_gpu();
    gpu_id = 4;  
    caffe.set_device(gpu_id);
else
    caffe.set_mode_cpu();
end
net = caffe.Net(opt.modelDefFile, opt.modelFile, 'test');
end