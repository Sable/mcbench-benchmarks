function [ nimg ] = num_images(  )
%NUM_IMAGES Determine number of images used in a NEB calculation.
%   N = NUM_IMAGES() determines the number of images used in an NEB
%   calculation by looking for directories 00, 01 ... N+1.

    a = dir;
    images = arrayfun(@(x) ~sum(~isstrprop(x.name,'digit')) & x.isdir , a);
    nimg = sum(images)-2;
    
    
end

