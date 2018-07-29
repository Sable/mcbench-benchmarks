function cab(varargin)

% This function closes all figures currently open EXCEPT for
% those listed as arguments.  'cab' stands for 'close all but'.
% 
% Usage:
%       cab figure_handle1 figure_handle2 ...
%       cab(figure_handle1, figure_handle2, ...)
%       cab('last') % or also:  cab last
%
%   - The 'last' option closes all figures except the last one opened.
%   - Calling 'cab' with no arguments is a convenient
%     alternative to 'close all'
%
% Example:
%   figure(5)
%   figure(7)
%   figure(9)
%   figure(11)
%   cab(7, 11)  % or also:  cab 7 11


% all_figs = findall(0, 'type', 'figure');  % Uncomment this to include ALL windows, including those with hidden handles (e.g. GUIs)
all_figs = findobj(0, 'type', 'figure');
figs2keep = [];
for i = 1:nargin
    if ischar(varargin{i})
        if strcmp(varargin{i}, 'last')
            figs2keep = all_figs(1);
            %figs2keep = gcf;
        else
            % In this case, function was called as follows:  cab 1 2 3
            figs2keep = [figs2keep, str2num(varargin{i})];
        end
    else
        % In this case, function was called as follows:  cab(1, 2, 3)
        figs2keep = [figs2keep, varargin{i}];
    end
end

delete(setdiff(all_figs, figs2keep))
