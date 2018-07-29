function [out1,out2] = spline_scale_function(varargin)
out2 = linspace(varargin{1:3});        % wavelet support.
out1 = spline_function(out2);
