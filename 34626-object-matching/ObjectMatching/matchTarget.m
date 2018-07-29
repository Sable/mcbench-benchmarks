function matchTarget(targetModel, testImage)
% find the target in the testImage and mark it in new figure
% targetModel -- the model of the target, created by createTargetModel.m
% testImage -- the test image that contains the target

% for plot
colormap = {'r*','b*','c*','g*','m*','ro','bo','co','go','mo','r+','b+','c+','g+','m+'};
colormap = [colormap {'rx','bx','cx','gx','mx','rs','bs','cs','gs','ms','rd','bd','cd','gd','md'}];

% resize test image if too big
im_mat_c = imresize(testImage,[500 NaN]);
% transform to gray scale
im_mat_g = rgb2gray(im_mat_c);

% find test image SURF points (SURFMEX library)
options.hessianThreshold = 500;
[cr, descr, sign, info] = surfpoints(im_mat_g,options);

surf_ori = -info(3,:)*pi/180;  % need to be modified if use new SURFmex library, see http://computervisionblog.wordpress.com/
surf_scale = info(1,:);

figure; 
imshow(im_mat_c); hold on
plot(cr(1,:),cr(2,:),colormap{1});

% target Model
model = targetModel;

% match the surf points between target and test image
match = surfmatch(descr,model.descr);

% set the location bin size to 1/4 the model max size
loc_bin_size = 0.25*model.maxsize;

% set 12 orientation bins
num_ori_bin = 12;
% set 10 scale bins
num_scale_bin = 10;
% calculate the number of location bins in the column axis
num_loc_bin_c = round(size(im_mat_g,2)*2/loc_bin_size);
% calculate the number of location bins in the row axis
num_loc_bin_r = round(size(im_mat_g,1)*2/loc_bin_size);
% the angle of one orientaion bin in radian
ori_bin_size = 2*pi/num_ori_bin;

% initialize the vote grid
vote = zeros(num_ori_bin,num_scale_bin,num_loc_bin_c,num_loc_bin_r);
% initialize the match map that stores vote to SURF match index
vote2match{num_ori_bin,num_scale_bin,num_loc_bin_c,num_loc_bin_r} = [];

% for each matched pairs of SURF
for i=1:size(match,2)
    % calculate the proposed target location orientation and scale
    ori = surf_ori(match(1,i)) - model.ori(match(2,i)) + 2*pi;
    scale = surf_scale(match(1,i))/model.scale(match(2,i));
    loc_c = cr(1,match(1,i)) + cos(surf_ori(match(1,i)) + model.ori2mid(match(2,i)))*surf_scale(match(1,i))*model.scale2mid(match(2,i));
    loc_r = cr(2,match(1,i)) + sin(surf_ori(match(1,i)) + model.ori2mid(match(2,i)))*surf_scale(match(1,i))*model.scale2mid(match(2,i));
    
    % find the bin
    ori_bin = mod(round(ori/ori_bin_size),num_ori_bin)+1;
    scale_bin = round(log2(scale)+num_scale_bin/2);
    loc_bin_c = ceil(loc_c/loc_bin_size);
    loc_bin_r = ceil(loc_r/loc_bin_size);
    
    % cast vote to all neigbhors
    for o=-1:1
        for s=-1:1
            for c=-1:1
                for r=-1:1
                    % vote + 1
                    vote(mod(ori_bin+o,num_ori_bin)+1, mod(scale_bin+s,num_scale_bin)+1 , ...
                         mod(loc_bin_c+c,num_loc_bin_c)+1, mod(loc_bin_r+r,num_loc_bin_r)+1) = ...
                    vote(mod(ori_bin+o,num_ori_bin)+1, mod(scale_bin+s,num_scale_bin)+1 , ...
                         mod(loc_bin_c+c,num_loc_bin_c)+1, mod(loc_bin_r+r,num_loc_bin_r)+1) + 1;
                    
                    % store who voted 
                    vote2match{mod(ori_bin+o,num_ori_bin)+1, mod(scale_bin+s,num_scale_bin)+1 , ...
                         mod(loc_bin_c+c,num_loc_bin_c)+1, mod(loc_bin_r+r,num_loc_bin_r)+1} = [...
                    vote2match{mod(ori_bin+o,num_ori_bin)+1, mod(scale_bin+s,num_scale_bin)+1 , ...
                         mod(loc_bin_c+c,num_loc_bin_c)+1, mod(loc_bin_r+r,num_loc_bin_r)+1} i];
                end
            end
        end
    end

end

% sort to find the top votes
[num_vote idx]= sort(reshape(vote,1,[]),'descend');

% show the surf point that matched.
for i = 1%:length(idx)
    hough_match = vote2match{idx(i)};

    % test image
    figure();
    imshow(im_mat_c); hold on;
    plot(cr(1,match(1,hough_match)),cr(2,match(1,hough_match)),colormap{1});

    % target image
    figure();
    im_model = model.targetImage;
    imshow(im_model); hold on;
    plot(model.cr(1,match(2,hough_match)),model.cr(2,match(2,hough_match)),colormap{1});

end

% refine the results
% only consider cluster that has more than 2 vote
num_cluster = length(find(num_vote>2));
count = 0;
for c=1:num_cluster
    hough_match = vote2match{idx(c)};
    A =[];
    b =[];
    
    % for each point that cast a vote in this cluster
    for v=1:num_vote(c)
        test_cr = cr(:,match(1,hough_match(v)));
        model_cr = model.cr(:,match(2,hough_match(v)));
        A = [ A ; model_cr' 0 0         1 0;...
                  0 0       model_cr'   0 1];
        b = [ b ; test_cr ];
    end
    % calculate x: the rotation matrix + transition ( see paper ) 
    x = A\b;
    R = reshape(x(1:4),2,2)';
    T = x(5:6);
    
    % refine the result, eliminate outlier SURF points
    filter_match = [];
    for v=1:num_vote(c)
        test_cr = cr(:,match(1,hough_match(v)));
        model_cr = model.cr(:,match(2,hough_match(v)));
        
        test_ori = surf_ori(:,match(1,hough_match(v)));
        model_ori = model.ori(:,match(2,hough_match(v)));
        
        test_scale = surf_scale(:,match(1,hough_match(v)));
        model_scale = model.scale(:,match(2,hough_match(v)));
        
        
        % check location
        if norm(test_cr - (R*model_cr + T))> 0.2*model.maxsize
            continue;
        end
        % check orientation
        model_ori_vec = R*([cos(model_ori); sin(model_ori)]);
        if mod(abs(test_ori - atan2(model_ori_vec(2),model_ori_vec(1))),2*pi) > pi/12;
            continue;
        end
        % check scale
        model_scale_ratio = (norm(R*[1; 0])*norm(R*[0; 1]))^0.5;
        if (test_scale/model_scale)/model_scale_ratio > 2^0.5 || (test_scale/model_scale)/model_scale_ratio < 2^-0.5
            continue;
        end
        
        filter_match = [filter_match v];
    end
    % if less than 3 point after refined, discard
    if length(filter_match)<3
        display('less than 3');
        continue;
    end
    % check if 2 points are the same
    if length(unique(match(1,hough_match(filter_match))))<3 ||...
       length(unique(match(2,hough_match(filter_match))))<3
        continue;
    end
    % recompute R T
    A =[];
    b =[];
    for v=filter_match
        test_cr = cr(:,match(1,hough_match(v)));
        model_cr = model.cr(:,match(2,hough_match(v)));
        A = [ A ; model_cr' 0 0         1 0;...
                  0 0       model_cr'   0 1];
        b = [ b ; test_cr ];
    end
    x = A\b;
    R = reshape(x(1:4),2,2)';
    T = x(5:6);
    count = count+1;
    candidate(count).R = R;
    candidate(count).T = T;
    candidate(count).match = hough_match(filter_match);
    
    
end

if count == 0
    display('object not found');
    return; 
end

model_mat = model.targetModelImage;

% for each candidate overlap model on test image
for i = 1%:5:length(candidate)
    im_mat_c2 = im_mat_c;
    R = candidate(i).R;
    T = candidate(i).T;
    figure;
    for r=1:size(im_mat_c,1)
        for c=1:size(im_mat_c,2)
            model_match_cr = round(R\([c;r]-T));
            if model_match_cr(2)>0 && model_match_cr(2)<size(model_mat,1) && ...
               model_match_cr(1)>0 && model_match_cr(1)<size(model_mat,2) 
                % if model not white
                if sum(model_mat(model_match_cr(2),model_match_cr(1),:))~=255*3
                    % overlap model
                    im_mat_c2(r,c,:) = [255 0 0];
                end
            end
        end
    end
    imshow(im_mat_c2);
    
    % match plot
    match_plot(im_mat_c,im_model,cr(:,match(1,candidate(i).match))',model.cr(:,match(2,candidate(i).match))');
    

end

end