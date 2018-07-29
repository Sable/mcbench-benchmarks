function [rep_motion motion_vector] = fastMV(im1, im2, w)
% Author:    Arash Jalalian
% E-mail:    arash.jalalian@gmail.com
% Arguments: [rep_motion motion_vector] = fastMV(im1, im2, w)
% This is the simplified block matching algorithm(BMA) which is proposed by
% L. Hao. I've simplified this algorithm for use it in a real-time problem.
% We have a dynamic search pattern during finding the motion vector. 
% 1. check with big diamond.
% 2. check with one of the hexagon subject to previous results.
% 3. check with small diamond.
% 'im1' is base frame of a video and 'im2' is the second frame. and 'w' is 
% the window size. 'rep_motion' is the representative motion vector and
% 'motion_vector' declare motion vectors for each block of image.
% Example:
% im1 = imread('frame001.jpg');
% im2 = imread('frame002.jpg');
% w = 16;
% [rep_m m_vector] = fastMV(im1, im2, w);

%   clear all
%   close all
%   clc
%   im1 = imread('img_1057.pgm');
%   im2 = imread('img_1058.pgm');
%  % dis = 2;
%   w = 8;


% initialization
[r1 c1] = size(im1);
[r2 c2] = size(im2);
if r1 ~= r2 || c1 ~= c2 
    error('The images must be in a same size')
end

pat.org    = [0; 0];
pat.diam1  = [2 0 -2 0; 0 2 0 -2];%big diamond
pat.diam2  = [1 0 -1 0; 0 1 0 -1];%small diamond
pat.hexver = [2 1  -1 -2 -1 1; 0 2 2 0 -2 -2];
pat.hexhor = [2 0 -2 -2 0 2 ;1 2 1 -1 -2 -1];

r_time = int16(floor(r1 ./ w));
c_time = int16(floor(c1 ./ w));

% for preventing index exceeding from end of image. 4 is the maximum
% Magnitude of the motion vector
if mod(r1, w) < 4 
    r_time = r_time -1;
end
if mod(c1, w) < 4
    c_time = c_time -1;
end
slice1 = cell(r_time, c_time);
slice2 = cell(r_time, c_time);
motion_vector = cell(r_time, c_time);

% creating slices with cell array of slices
for i = 1:r_time
    for j = 1:c_time
        slice1{i, j} = im1(((i-1) * w) + 1:i * w, ((j-1) * w) + 1:j * w);
        slice2{i, j} = im2(((i-1) * w) + 1:i * w, ((j-1) * w) + 1:j * w);
    end
end

% first step checking with 4 points of big diamond and the origin
mad_org = zeros(r_time, c_time);
min_mad = zeros(r_time, c_time);
idx_min_mad = zeros(r_time, c_time);
for i = 1:r_time
    for j = 1:c_time       
        s_h_r = ((i-1) * w) + 1;%slice head row
        s_h_c = ((j-1) * w) + 1;%slice head column
        diff.org{i, j} = abs(slice2{i, j} - slice1{i, j});
        [r_diam c_diam] = size(pat.diam1);
        for k = 1:c_diam
            if s_h_r + pat.diam1(1, k) > 0 && s_h_c + pat.diam1(2, k) > 0
                diff.diam1{1, k} = abs(slice1{i, j}- im2(s_h_r + pat.diam1(1, k):...
                    i *w + pat.diam1(1, k),...
                    s_h_c + pat.diam1(2, k):...
                    j * w + pat.diam1(2, k)));
                % calculating MAD = Mean Absolute Difference
                diff.diam1{2, k} = sum(sum(diff.diam1{1,k})) / (w ^ 2);% insert each MAD below each Pat
                mad(k) = sum(sum(diff.diam1{1,k})) / (w ^ 2);
            else
                diff.diam1{1, k} = 9999999999999;
                diff.diam1{2, k} = 9999999999999;
                mad(k) = sum(sum(diff.diam1{1,k})) / (w ^ 2);
            end
        end
        % calculating minimum of mad in 4 pat and the origin and inserting
        % them into a min_mad(i, j). where i, j decler the position of the
        % slice in the image
        mad_org(i , j) = sum(sum(diff.org{i,j})) / (w ^ 2);
        mad = [mad mad_org(i, j)];
        [min_mad(i, j) idx_min_mad(i, j)] = min(mad);
        clear mad
        
    end
end 
% if the idx_min_mad == 5 it means that the origin has the minimum value of
% mad (between 4 big diamond points and the origin the orogin has the
% minimum value) otherwise the index in idx_min_mad shows the pat index that
% has the min mad value.
idx_min_mad2 = zeros(r_time, c_time);
min_mad2 = zeros(r_time, c_time);
for i = 1:r_time
    for j = 1:c_time
        clear mad
        if idx_min_mad(i, j) == 5
            % it means this point didn't moved and it's better to do not use
            % any motion vectors so we must put [0; 0] for these points as a
            % motion vector.accourding to the paper for any slices that 
            % idx_min_mad(i, j) ==5 we must use anothe four points as new
            % pat and check the slices with these i and j for mad. and the
            % final solution for these slices is these mad. here we must
            % use pat.diam2 as new patterns and repeat thise process again.
            s_h_r = ((i-1) * w) + 1;%slice head row
            s_h_c = ((j-1) * w) + 1;%slice head column
%           diff.org{i, j} = abs(slice2{i, j} - slice1{i, j});
            [r_diam c_diam] = size(pat.diam1);
            for k = 1:c_diam
                if s_h_r + pat.diam2(1, k) > 0 && s_h_c + pat.diam2(2, k) > 0
                    diff.diam2{1, k} = abs(slice1{i, j}- im2(s_h_r + pat.diam2(1, k):...
                        i *w + pat.diam2(1, k),...
                        s_h_c + pat.diam2(2, k):...
                        j * w + pat.diam2(2, k)));
                    % calculating MAD = Mean Absolute Diffrence
                    diff.diam2{2, k} = sum(sum(diff.diam2{1,k})) / (w ^ 2);% insert each MAD below each Pat
                    mad(k) = sum(sum(diff.diam2{1,k})) / (w ^ 2);
                else
                    diff.diam2{1, k} = 9999999999999;
                    diff.diam2{2, k} = 9999999999999;
                    mad(k) = sum(sum(diff.diam2{1,k})) / (w ^ 2);
                end
            end
            % calculating minimum of mad in 4 pat and the origin and inserting
            % them into a min_mad(i, j). where i, j decler the position of the
            % slice in the image
%            mad_org(i , j) = sum(sum(diff.org{i,j})) / (w ^ 2);
%            mad = [mad mad_org(i, j)];
            [min_mad2(i, j) idx_min_mad2(i, j)] = min(mad);

        end
    end
end
for i = 1:r_time
    for j = 1:c_time
        if idx_min_mad2(i, j) ~= 0
            motion_vector{i , j} = pat.diam2(:, idx_min_mad2(i, j));
        end
    end
end

% other points that their minimum mads idx ~= 5. it means that these slices
% are closer to farder slices.
idx_min_mad3 = zeros(r_time, c_time);
min_mad3 = zeros(r_time, c_time);
for i = 1:r_time
    for j = 1:c_time
        clear mad
        if idx_min_mad(i, j) ~= 5
            s_h_r = ((i-1) * w) + 1;%slice head row
            s_h_c = ((j-1) * w) + 1;%slice head column
%           diff.org{i, j} = abs(slice2{i, j} - slice1{i, j});
            [r_hex c_hex] = size(pat.hexhor);
            for k = 1:c_hex
                if s_h_r + pat.hexhor(1, k) > 0 && s_h_c + pat.hexhor(2, k) > 0 && (idx_min_mad(i, j) == 1 || idx_min_mad(i, j) == 3)
                    diff.hex{1, k} = abs(slice1{i, j}- im2(s_h_r + pat.hexhor(1, k):...
                        i *w + pat.hexhor(1, k),...
                        s_h_c + pat.hexhor(2, k):...
                        j * w + pat.hexhor(2, k)));
                    % calculating MAD = Mean Absolute Diffrence
                    diff.hex{2, k} = sum(sum(diff.hex{1,k})) / (w ^ 2);% insert each MAD below each Pat
                    mad(k) = sum(sum(diff.hex{1,k})) / (w ^ 2);
                elseif s_h_r + pat.hexver(1, k) > 0 && s_h_c + pat.hexver(2, k) > 0 && (idx_min_mad(i, j) == 2 || idx_min_mad(i, j) == 4)
                    diff.hex{1, k} = abs(slice1{i, j}- im2(s_h_r + pat.hexver(1, k):...
                        i *w + pat.hexver(1, k),...
                        s_h_c + pat.hexver(2, k):...
                        j * w + pat.hexver(2, k)));
                    % calculating MAD = Mean Absolute Diffrence
                    diff.hex{2, k} = sum(sum(diff.hex{1,k})) / (w ^ 2);% insert each MAD below each Pat
                    mad(k) = sum(sum(diff.hex{1,k})) / (w ^ 2);
                else
                    diff.hex{1, k} = 9999999999999;
                    diff.hex{2, k} = 9999999999999;
                    mad(k) = sum(sum(diff.hex{1,k})) / (w ^ 2);
                end
            end
            % calculating minimum of mad in 4 pat and inserting
            % them into a min_mad(i, j). where i, j decler the position of the
            % slice in the image
%            mad_org(i , j) = sum(sum(diff.org{i,j})) / (w ^ 2);
%            mad = [mad mad_org(i, j)];
            [min_mad3(i, j) idx_min_mad3(i, j)] = min(mad);

        end
    end
end
% org_mov declare the movement vector for new pattern origins.
org_mov = cell(r_time, c_time);
for i = 1:r_time
    for j = 1:c_time
        if idx_min_mad3(i, j) ~= 0 && (idx_min_mad(i, j) == 1 || idx_min_mad(i, j) == 3)
            org_mov{i , j} = pat.hexhor(:, idx_min_mad3(i, j));
        elseif idx_min_mad3(i, j) ~= 0 && (idx_min_mad(i, j) == 2 || idx_min_mad(i, j) == 4)
            org_mov{i , j} = pat.hexver(:, idx_min_mad3(i, j));
        end
    end
end
% now we must go the theird step. the minimum mad point found in the
% previous search step is repositioned as the center point to form a new
% hexagon nad only three new non overlaped points will be checked as
% candidates each time. so we must define new pattern. this time our
% patterns must have a dynamic behavior. and also these pattern must be
% created based on the old pat.hexver and pat.hexhor
[r_mov c_mov] = size(org_mov);
idx_min_mad4 = zeros(r_mov, c_mov);
min_mad4 = zeros(r_mov, c_mov);
for i = 1:r_mov
    for j = 1:c_mov
        clear mad
        nu = sparse(org_mov{i, j});
        [r_nu c_nu] = size(nu);
        if r_nu ~= 0 || c_nu ~= 0
            for z = 1:c_hex
                pat.hexver_new(:, z) = pat.hexver(:, z) + org_mov{i, j};
                pat.hexhor_new(:, z) = pat.hexhor(:, z) + org_mov{i, j};
            end
            s_h_r = ((i-1) * w) + 1;%slice head row
            s_h_c = ((j-1) * w) + 1;%slice head column
%           diff.org{i, j} = abs(slice2{i, j} - slice1{i, j});
            [r_hex c_hex] = size(pat.hexhor_new);
            for k = 1:c_hex
%                clear mad
                if s_h_r + pat.hexhor_new(1, k) > 0 && s_h_c + pat.hexhor_new(2, k) > 0 && (idx_min_mad(i, j) == 1 || idx_min_mad(i, j) == 3)
                    diff.hex{1, k} = abs(slice1{i, j}- im2(s_h_r + pat.hexhor_new(1, k):...
                        i *w + pat.hexhor_new(1, k),...
                        s_h_c + pat.hexhor_new(2, k):...
                        j * w + pat.hexhor_new(2, k)));
                    % calculating MAD = Mean Absolute Diffrence
                    diff.hex{2, k} = sum(sum(diff.hex{1,k})) / (w ^ 2);% insert each MAD below each Pat
                    mad(k) = sum(sum(diff.hex{1,k})) / (w ^ 2);
                elseif s_h_r + pat.hexver_new(1, k) > 0 && s_h_c + pat.hexver_new(2, k) > 0 && (idx_min_mad(i, j) == 2 || idx_min_mad(i, j) == 4)
                    diff.hex{1, k} = abs(slice1{i, j}- im2(s_h_r + pat.hexver_new(1, k):...
                        i *w + pat.hexver_new(1, k),...
                        s_h_c + pat.hexver_new(2, k):...
                        j * w + pat.hexver_new(2, k)));
                    % calculating MAD = Mean Absolute Diffrence
                    diff.hex{2, k} = sum(sum(diff.hex{1,k})) / (w ^ 2);% insert each MAD below each Pat
                    mad(k) = sum(sum(diff.hex{1,k})) / (w ^ 2);
                else
                    diff.hex{1, k} = 9999999999999;
                    diff.hex{2, k} = 9999999999999;
                    mad(k) = sum(sum(diff.hex{1,k})) / (w ^ 2);
                end
            end
            % calculating minimum of mad in 4 pat and inserting
            % them into a min_mad(i, j). where i, j declare the position of the
            % slice in the image
%            mad_org(i , j) = sum(sum(diff.org{i,j})) / (w ^ 2);
            mad = [mad mad_org(i, j)];
            [min_mad4(i, j) idx_min_mad4(i, j)] = min(mad);
%              clear mad
        end
    end
end
% org_mov declare the movement vector for new pattern origins.
% final motion vector calculation
for i = 1:r_mov
    for j = 1:c_mov
        if idx_min_mad4(i, j) == 7 
            motion_vector{i, j} = pat.org;
        elseif idx_min_mad4(i, j) ~= 0 && (idx_min_mad(i, j) == 1 || idx_min_mad(i, j) == 3)
            motion_vector{i , j} = pat.hexhor_new(:, idx_min_mad4(i, j));
        elseif idx_min_mad4(i, j) ~= 0 && (idx_min_mad(i, j) == 2 || idx_min_mad(i, j) == 4)
            motion_vector{i , j} = pat.hexver_new(:, idx_min_mad3(i, j));
        end
    end
end

% now we want to find rep_motion vector
motion_vectors = cat(2, motion_vector{:});
most_motion_vector = zeros(1, r_time .* c_time);
clear temp
temp = motion_vectors;
for i=1:r_time .* c_time
    my_count = 0;
    element(:, 1) = temp(:, i);
    for k = i+1:r_time .* c_time
        if temp(:, k) == element(:, 1)
            my_count = my_count+1;
%             temp(:, k) = [];
        end
    end
    most_motion_vector(i) = my_count;
end
[value, idx] = max(most_motion_vector);
rep_motion= motion_vectors(:, idx);