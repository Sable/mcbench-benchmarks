%---------------------------------------------------------------------
% this demo shows the process that by using multiple trackpaths to 
% track the leukocyte in the demo2.avi file. In this demo, the 
% diameter of the leulocyte among this video belongs to (10-12) pixels, 
% so we set the distance between each trackpath as 6 (in row 21).
% Written by Yuan Chen,Nanjing university of aeronautic and astronautic(2010)
%---------------------------------------------------------------------
clear all;
display('Reading and processing demo2.avi file...')
video=aviread('demo2.avi');
video = {video.cdata};                  % read and exract avi data(matrix);
z = 0;
for i=1:length(video);                  % change 'color' video to gray;
    M{i} = video{i}(:,:,1);
    z = z + double(M{i});
end
z = z/length(video);                    % the average image;
nn = size(video,2);                     % the number of frames;
[mz,nz] = size(z);

N = 6;                                  % SET the distance between each trackpath(N can be set from 1-12);
T = 112:N:137;                          % set the range of trackpaths;
for i = 1:length(T)
    tmp = zeros(size(z));
    for j = 242:291                     % set the length of trackpaths;
        tmp(T(i),j) = 255;           
    end
    trackpath{i} = tmp;    
end
h = fspecial('gaussian',5,1);
Z = z; 
display([num2str(length(T)),' trackpaths are selected to generate ',num2str(length(T)),' ST images']);

% -------process the generated spatiotemporal(ST) images and extract the traces;
for i=1:size(trackpath,2)
    map = [];
    [xx,yy] = startpoint(trackpath{i});                     % find the start point of trackpath
    ind_trackpath = ord_line_indx(trackpath{i},xx,yy);      % order the trackpath points;
    for j = 1:length(M)                                     % generate the ST image
        line = M{j}(ind_trackpath);
        map = [map;line];
    end
    map = map';
    Map{i} = map;
    display(['processing ST image',int2str(i)]);
    % removing horizontal streaks if necessary;
    TT = sum(map,2)/size(map,2);      
    for k = 1:size(map,1)           
        map(k,:) = map(k,:) - TT(k);
    end
    
    [F,Theta,angle] = J4(map,2.5);                          % applying Jacob filter enhancement;
    Rdenoised = nsf(F);                                     % applying noise supression function;
    sTheta = round(imfilter(Theta,h,'symmetric'));          % smooth Theta;
    K = angfilter(Rdenoised,sTheta,angle,20);               % applying orientation filter function;
    sK = imfilter(K,h,'symmetric');
    bw = im2bw(sK,0.01);
    thin = bwmorph(bw,'thin',inf);
    trace{i} = bwareaopen(thin,2);                          % remove small traces;
end

H = fspecial('gaussian');
for i = 1:length(trackpath)
    Map_denoise{i} = imfilter(Map{i},H,'symmetric');        % denoise;
end

% -------find out the coordinate(X_trackpath,Y_trackpath) and grayscale of trackpaths;
for i = 1:length(trackpath)
    [xx,yy] = startpoint(trackpath{i});                     % find the start coordinate of a trackpath;
    ind_trackpath = ord_line_indx(trackpath{i},xx,yy);      % search the trackpath's point from the start point orderly;
    for j = 1:length(ind_trackpath)             
        [X_trackpath(j),Y_trackpath(j)] = ind2sub([mz,nz],ind_trackpath(j)); % change the index to (X,Y) coordinate;
    end    
    Trackpath_value{i}(:,1) = X_trackpath';     
    Trackpath_value{i}(:,2) = Y_trackpath';    
    Trackpath_value{i}(:,3) = 0;
    [Y_trace,X_trace] = find(trace{i}==1);                  % find extracted trace coordinate;
    for k = 1:length(Y_trace)                               % store the grayscale of trace;
        Trackpath_value{i}(Y_trace(k),3) = Map_denoise{i}(Y_trace(k),X_trace(k));                        
    end
    clear X_trackpath;clear Y_trackpath;
end
% -------backward mapping the extracted traces to the trackpaths;
for i = 1:length(Trackpath_value)
    for j = 1:size(Trackpath_value{i},1)
        Z(Trackpath_value{i}(j,1),Trackpath_value{i}(j,2)) = Trackpath_value{i}(j,3);
    end
end

%%  fusion the aligned points in trackpaths to calculate the trajectory;
l = 1;
for j = 1:size(Trackpath_value{1},1)             % the number of the aligned points in the trackpath;
    Fusion_points = [];
    for i = 1:size(Trackpath_value,2)            % the number of the trackpaths;
        if Trackpath_value{i}(j,3) > 0           % >0 means the cell is tracked;
            X = Trackpath_value{i}(j,1);         % X coordinate;
            Y = Trackpath_value{i}(j,2);         % Y coordinate;
            V = Trackpath_value{i}(j,3);         % grayvalue of (X,Y);
            Fusion_points = [Fusion_points,[X;Y;V]];
        end
    end
    if size(Fusion_points,2) > 2                 % the cell is tracked by three or more than three trackpth;
        X_fused(l,1) = mean(Fusion_points(1,:)); % the fused position is the center among the aligned points;
        Y_fused(l,1) = mean(Fusion_points(2,:)); 
        l = l+1;
    elseif size(Fusion_points,2) == 2            % the cell is tracked by two trackpath(Eq.(15)in the paper);
        x1 = Fusion_points(1,1); x2 = Fusion_points(1,2);
        y1 = Fusion_points(2,1); y2 = Fusion_points(2,2);
        v1 = Fusion_points(3,1); v2 = Fusion_points(3,2);
        [X_fused(l,1),Y_fused(l,1)] = fusion2p(x1,y1,x2,y2,v1,v2,1.1);
        l = l+1;
    elseif size(Fusion_points,2) ==1             % the cell is tracked by only one trackpath;
        X_fused(l,1) = Fusion_points(1,1);       % no fusion is needed;
        Y_fused(l,1) = Fusion_points(2,1);
        l = l+1;
    end
end

X_trajectory = round(X_fused);                   % calculated trajectory;
Y_trajectory = round(Y_fused);
X_smooth = round(smooth(X_fused,10));            % smooth process to prevent jagged trajectory;
Y_smooth = round(smooth(Y_fused,10));
for i = 1:length(X_fused)
    Z(X_trajectory(i),Y_trajectory(i)) = 255;
end
%% Errors calculation;
load 'demo2RealTrajectoryX.mat'                  % load the cell's real trajectory;
load 'demo2RealTrajectoryY.mat'
hold on,plot(y,x,'r')
for i = 6:length(X_fused)-3                      % do not consider boundary data;
    for j = 1:length(x)
        dis(j) = sqrt((X_fused(i) - x(j))^2 + (Y_fused(i) - y(j))^2); 
        Error(i) = min(dis);                     % by finding the closest points in the real trajectory to calculate the error;
    end
end
ES = [mean(Error),std2(Error)];                  % mean error and variance;
figure,imshow(Z,[]),title([int2str(length(T)),...
' trackpaths are selected-white points are the tracked trajectory.']);
hold on,plot(y,x,'r');h = legend('real trajectory');
display('the Error and Variance of the tracked tracjectory to the real trajectory is');
display([num2str(ES(1)) ' pixels and ' num2str(ES(2)),' pixels']);
