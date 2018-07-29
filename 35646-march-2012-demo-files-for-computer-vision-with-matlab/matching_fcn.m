%% Copyright 2011-2012 The MathWorks, Inc.
% This can be used to improve the speed of matchFeatures.  It requires
% MATLAB Coder.
%

function index_pairs = matching_fcn(ref_features, vid_features, th)
%#codegen
index_pairs = matchFeatures(ref_features, vid_features, 'MatchThreshold', th);
