function [ mapz ] = laws( image , averWindSize)
%LAWS Laws image filters
%   Law's image filters applied to input image

%% convert to grayscale

    if size(image,3) == 3
        imageG=rgb2gray(image);
    else
        imageG=image;
    end
    
%% define fiters
    
    filters={};
    filters{1}=[1 4 6 4 2];
    filters{2}=[-1 -2 0 2 1];
    filters{3}=[-1 0 2 0 -1];
    filters{4}=[1 -4 6 -4 1];

%% smooth image
    
    smooth = ones(averWindSize, averWindSize)/(averWindSize^2);
    imageG=imfilter(imageG,smooth,'conv','symmetric');
    
%% define filters and apply to images

    filtered2D={};

    for i=1:size(filters,2)
        for j=1:size(filters,2)
            temp=filters{i}'*filters{j};
            filtered2D{end+1}=imfilter(imageG,temp);
        end
    end
    
%% get resulting 9 maps

    mapz={};

    mapz{end+1}=wfusmat(filtered2D{2},filtered2D{5},'mean');
    mapz{end+1}=wfusmat(filtered2D{4},filtered2D{13},'mean');
    mapz{end+1}=wfusmat(filtered2D{7},filtered2D{10},'mean');
    mapz{end+1}=filtered2D{11};
    mapz{end+1}=filtered2D{16};
    mapz{end+1}=wfusmat(filtered2D{3},filtered2D{9},'mean');
    mapz{end+1}=filtered2D{6};    
    mapz{end+1}=wfusmat(filtered2D{8},filtered2D{14},'mean');
    mapz{end+1}=wfusmat(filtered2D{12},filtered2D{15},'mean');
    
end

