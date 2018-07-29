function varargout = output(f, out_indices)

% varargout = output(f, out_indices)
% 
% Select outputs from a function with multiple outputs. This is most useful
% when writing anonymous functions, where it is otherwise difficult to use
% anything but the first output.
% 
% Example:
%
% >> index = output(@() min([3 1 4]), 2)
% index =
%      2
%
% Multiple indices work as well.
%
% >> [index, minimum] = output(@() min([3 1 4]), [2 1])
% index =
%      2
% minimum =
%      1
%
% Tucker McClure
% Copyright 2013 The MathWorks, Inc.

    [outs{1:max(out_indices)}] = f();
    varargout = outs(out_indices);

end
