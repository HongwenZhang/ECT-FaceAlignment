% Apply network to a single image
function joints = applyNetImage(imgFile, net, opt)

% Read & reformat input image
img = imread(imgFile);
img = imresize(img,[256 256]);
if size(img,3)==1
    img = repmat(img,[1 1 3]);
end
input_data = prepareImagePose(img, opt);

% Forward pass
tic
net.forward({input_data});
features = net.blobs(opt.layerName).get_data();
[joints, heatmaps] = processHeatmap(features, opt);
disp(toc); 

% Visualisation
if opt.visualise
    % Heatmap
    
    immin = min(min(min(heatmaps)));
    immax = max(max(max(heatmaps)));
    distmap = (heatmaps - immin)./(immax-immin);
    %implay(distmap);
    distmapfull = max(distmap,[],3);
    %immin = min(min(distmapfull));immax = max(max(distmapfull));
    %distmapfull = (distmapfull-immin)./(immax - immin);
    %figure(3),imagesc(distmapfull);
    
    heatmapVis = getConfidenceImage(heatmaps, img);
    %figure(1),
    fig = subplot(2,2,3);imshow(heatmapVis);

    % Original image overlaid with joints
    
    
    subplot(2,2,2);imshow(uint8(img));
    hold on
    plotSkeleton(joints, opt, []);
    hold off
    subplot(2,2,1);imagesc(distmapfull);
    axis equal
    axis off
    %saveas(fig,imgFile(end-7:end));
end

