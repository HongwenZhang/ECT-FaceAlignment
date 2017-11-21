%train_log_file = '/home/hongwen.zhang/caffe-faceheatmap-68points/data/face68DecovConcat/snapshots/face68DecovConcat_train.log';
%train_log_file = '/home/hongwen.zhang/caffe-faceheatmap-68points/data/face68DeconvRelu/snapshots/face68DeconvRelu_train.log';
%train_log_file = '/home/hongwen.zhang/caffe-faceheatmap-68points/data/face68LPDecov/snapshots/face68LPDecov_train.log';

modelName = 'VGGdilaFusion';  %face68dilated2bilinearLP  face29COFW   primaryNet
rootDirectory = strcat('~/model_data/',modelName,'/snapshots/');
train_log_file = strcat(rootDirectory , modelName , '_train.log');
train_log_file = '/home/hongwen.zhang/caffe-faceheatmap-68points/filelog.log';

train_interval = 100;
test_interval = 1000;

[~, string_output] = dos(['cat ',train_log_file,' | grep ''Train net output #0'' | awk ''{print $11}'' ']);
train_loss = str2num(string_output);

n = 1:length(train_loss);

idx_train = (n - 1)*train_interval;

[~, string_output] = dos(['cat ',train_log_file,' | grep ''Test net output #0'' | awk ''{print $11}'' ']);

test_loss = str2num(string_output);

m = 1:length(test_loss);

idx_test = (m - 1)*test_interval;

figure;plot(idx_train(1:end), train_loss(1:end));
hold on;
plot(idx_test(1:end), test_loss(1:end));

grid on;
legend('Train Loss', 'Test Loss');

xlabel('iterations');
ylabel('loss');
title('Train & Test Loss Curve');
