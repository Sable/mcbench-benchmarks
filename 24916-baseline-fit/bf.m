function [ycorr,yfit] = bf(y,varargin)
% Baseline Fit each column in "x".
% Syntax: [ycorr,yfit] = bf(y,pts,avgpts,method,confirm);  
%   ycorr = bf(y);  ycorr = bf(y,method); ycorr = bf(y,avgpts); 
%   ycorr = bf(y,pts);  ycorr = bf(y,pts,avgpts); 
% A baseline fit is interpolated from selected points and then applied to the data.
%   "y" is a vector or array.
%       If an array, the baseline fit is performed for each column of data (dim 1).
%   Arguments following "y" may be in any order.
%   "pts" is vector specifying the indices of the points for a baseline fit.
%       If not specified then a plot is displayed and the user is instructed to
%       interactively select points for the baseline fit.
%       End points are always automatically included for interactive "pts" selection,
%       and do not need to explicitly selected. It is recommended that the end points
%       be included in any list of "pts".
%       It is not necessary to order or sort "pts" before use.
%   "avgpts" determines the width in points for the calculation of the mean y(x)
%       value, where x is a selected point in "pts". (Default = 3).
%       This can be helpful for noisy data.
%   "method" controls the algorithm applied for the baseline fit. The routine uses
%       Matlab's interp1 command. "method" must be one of the methods supported by
%       interp1. (Default is 'spline').
%   "confirm", if specified as the string 'confirm', will allow the user to see the
%       result and to confirm it is acceptable. If not the user can reslect "pts". 
%   "ycorr" is the baseline corrected data in the same format as "y".
%   "yfit" is a vector or array with the interpolated baseline fit.
%
% Examples:
%   [y,yfit] = bf(y,'confirm','linear');
%       "y" will be plotted and the user is instructed to select points for the fit.
%       A baseline will be linearly interpolated from the selected points and will be
%       plotted together with "y". The user is prompted as to whether to redo the
%       baseline selection. Upon completion, the corrected data "y" and the fitted 
%       baseline "yfit" are output.
%   ycorr = bf(y,5);
%      "y" is plotted and the user is instructed to select points for the fit.
%       The baseline fit is based on the mean value of "y" over 5 points centered on
%       the selected points. Cubic spline interpolation is used for the baseline fit.
%       The corrected data "ycorr" is output.
%   ycorr = bf(y,[5,10,15,30,35,40],'pchip');
%       Points with the specified indices are used to calculate a baseline fit using
%       the piecewise cubic Hermite interpolation method. No data is plotted.
%       The baseline fit is based on the mean value of "y" over 3 points centered on
%       the selected points. The corrected data "ycorr" is output.
%
% See Also:   interp1, spline, ginput

% Copyright 2009 Mirtech, Inc.
% Created by    Mirko Hrovat    08/01/2009  contact:mhrovat@email.com

def_method  = 'spline';
def_avgpts  = 3;

method = [];
avgpts = [];
pts    = [];
confirm = false;
for n = 2:nargin,
    f = varargin{n-1};
    if ischar(f),
        if strcmpi(f,'confirm'),
            confirm = true;
        else
            method = f;
        end
    elseif isnumeric(f) && numel(f) == 1,
        avgpts = f;
    elseif isnumeric(f) && numel(f) > 1,
        pts = f;
    elseif isempty(f),
        continue
    else
        error ('  Invalid input argument!')
    end
end
if isempty(method),     method = def_method;        end
if isempty(avgpts),     avgpts = def_avgpts;        end
dimy = size(y);
lst = dimy(1);
newdimy = [dimy(1),prod(dimy(2:end))];
y = reshape(y,newdimy);
x = 1:lst;
if isempty(pts),
    interactive = true;
else
    interactive = false;
end
if interactive || confirm,
    bffig = figure;
else
    bffig = 0;
end
ok = false;
while ~ok,
    if interactive,
        plot(x,real(y(:,1)))
        set(bffig,'Name','Baseline Fit - Select points')
        fprintf(['\n Now select baseline points to fit by positioning cursor,',...
            '\n   and selecting points with mouse button or key press.',...
            '\n Press Enter key when done.\n'])
        [a,b] = ginput;                                 %#ok
        pts = round(a.');
    end
    pts = sort(pts);
    pts(diff(pts)==0) = [];         % delete duplicate points
    if pts(1)~=1,       pts = [1,pts];          end     %#ok
    if pts(end)~=lst,   pts = [pts,lst];        end     %#ok
    npts = numel(pts);
    pss = zeros(npts,2);
    pss(:,1) = pts - floor(avgpts/2);
    pss(:,2) = pss(:,1) + avgpts;
    pss(pss < 1) = 1;
    pss(pss > lst) = lst;
    yavg = zeros([npts,newdimy(2)]);
    for n = 1:npts,
        yavg(n,:) = mean(y(pss(n,1):pss(n,2),:),1);
    end
    yfit = interp1(pts,yavg,x,method);
    if size(yfit,1) ==1,    
        yfit = shiftdim(yfit,1);    % make yfit a column if it is a row vector
    end
    if confirm,
        interactive = true;
        figure(bffig)
        plot(x,real(y(:,1)),'b',x,real(yfit(:,1)),'r',pts,real(yavg(:,1)),'ob')
        set(bffig,'Name','Baseline Fit - Verify baseline')
        answer = input('  Do you to redo fit and reselect baseline points?[N] ','s');
        if isempty(answer),     answer = 'n';   end
        if strcmpi(answer,'y'),
            ok = false;
        else
            ok = true;
        end
    else
        ok = true;
    end
end
if any(findobj('Type','figure')==bffig),
    close(bffig),                   % close figure if it exists
end
ycorr = y - yfit;
ycorr = reshape(ycorr,dimy);
yfit = reshape(yfit,dimy);