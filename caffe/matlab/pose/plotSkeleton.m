% Plot skeleton
function handle = plotSkeleton(j,opts,handle, dominantOnly)
if ~exist('dominantOnly', 'var'); dominantOnly = false; end
    
if isempty(opts)
    opts = plotSkeletonDefaultopts();
end

opts.linewidth = 2;
opts.jointsize = 6;
opts.clr = jet(opts.numJoints); % Sets colour of joints

if ~isfield(opts,'jointlinewidth')
    opts.jointlinewidth = 1;
end
if ~isfield(opts,'jointlinecolor')
    opts.jointlinecolor = zeros(opts.numJoints,3);
end
if isscalar(opts.jointsize)
    opts.jointsize = opts.jointsize*ones(opts.numJoints,1);
end
if isscalar(opts.jointlinewidth)
    opts.jointlinewidth = opts.jointlinewidth*ones(opts.numJoints,1);
end

% joints = 1:opts.numJoints;
joints = 1:size(j,2);


% wrist only plot
if nargin < 3 || isempty(handle)
%     if size(j, 2) == 2; joints = 1:2; dontPlotSkeleton = true; else dontPlotSkeleton = false; end
%     if size(j, 2) == 3; joints = 1:3; dontPlotSkeleton = true; end
    handle.axis = gca;
%     if ~dontPlotSkeleton
%         % draw skelton
%         if ~dominantOnly; handle.ula = plot(handle.axis,j(1,[5,7]),j(2,[5,7]),'y-','linewidth',opts.linewidth ,'color',opts.clr(8,:), 'LineSmoothing','on'); end
%         hold on
%         handle.ura = plot(handle.axis,j(1,[4,6]),j(2,[4,6]),'y-','linewidth',opts.linewidth ,'color',opts.clr(8,:), 'LineSmoothing','on');
%         if ~dominantOnly; handle.lla = plot(handle.axis,j(1,[3,5]),j(2,[3,5]),'r-','linewidth',opts.linewidth ,'color',opts.clr(9,:), 'LineSmoothing','on'); end
%         handle.lra = plot(handle.axis,j(1,[2,4]),j(2,[2,4]),'r-','linewidth',opts.linewidth ,'color',opts.clr(9,:), 'LineSmoothing','on');
%     end
    % draw joints
    if dominantOnly; joints = [1 2 3 4 5]; end
    for c = joints
    	handle.joints(c) =  plot(handle.axis,j(1,c),j(2,c),'bo', ...
            'markerfacecolor',opts.clr(c,:), 'markersize',opts.jointsize(c),'linewidth',opts.jointlinewidth(c),'color',opts.jointlinecolor(c,:), 'LineSmoothing','on');
    end
else
    % draw skelton
    set(handle.lla,'xdata',j(1,[3,5]),'ydata',j(2,[3,5]));
    set(handle.ula,'xdata',j(1,[5,7]),'ydata',j(2,[5,7]));
    set(handle.lra,'xdata',j(1,[2,4]),'ydata',j(2,[2,4]));
    set(handle.ura,'xdata',j(1,[4,6]),'ydata',j(2,[4,6]));
    % draw joints
    for c = joints
           set(handle.joints(c),'xdata',j(1,c),'ydata',j(2,c));
    end
end

end


function opts = plotSkeletonDefaultopts()
opts.clr = jet(68); % Sets colour of joints
opts.clr(8,:) = [1 0 0];
opts.clr(9,:) = [0 1 0];
opts.linewidth = 2;
opts.jointsize = 6;
end