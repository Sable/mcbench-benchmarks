% This MEX function will make feature vectors from local intensity regions
% in an image. Compile with "mex get_feature_vectors.c".
%
% F = get_feature_vectors(Iin,x,y,Rsizes)
% Inputs,
%      Iin : Input image gray scale or RGB (or more colors)
%      x,y : Coordinate in the image
%      Rsizes : The size of the local intensity patch [sizex, sizey]
%
% Outputs,
%      A matrix with the intensity feature vectors, first feature
%          vector is F(:,1);
%
% Function is written by D.Kroon University of Twente (July 2009)
