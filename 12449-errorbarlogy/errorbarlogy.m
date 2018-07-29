function errorbarlogy
% ERRORBARLOGY Show the vertical errorbar line in log y scale plot when the 
%   data error is larger than data itself.
%    
%   If ERRORBARLOGX is used, please run it before ERRORBARLOGY.
%
%   Example:
%      x = logspace(1,3,20);
%      y = 5*(1 + 0.5*(rand(1,20)-0.5)).*x.^(-2);
%      y_err(1:13) = y(1:13)/2;
%      y_err(14:20) = y(14:end)*5;
%      errorbar(x,y,y_err,'o');
%      errorbarlogy;
% 
%   This code is inspired by F. Moisy's ERRORBARLOGX.
%
%   Z Jiang
%   Revision: 1.00,  Date: 2006/09/28
%   Revision: 1.01,  Date: 2006/09/29
%
%   See also ERRORBAR, ERRORBARLOGX

hA = gca;
hObj = get(hA,'Children');
for ihObj = 1:length(hObj)
    YData = get(hObj(ihObj),'YData');
    hLine = get(hObj(ihObj),'Children');
    if length(hLine) <= 1, continue; end
    if length(get(hLine(1),'XDATA')) > length(get(hLine(2),'XDATA'))
        hE = hLine(1); hL = hLine(2);
    else
        hE = hLine(2); hL = hLine(1);
    end
    EXData = get(hE,'XData');  EYData = get(hE,'YData');    
    lengthD = length(EXData);
    if length(EYData) ~= 9*length(YData), continue;   end
    for jD = lengthD:-9:1
        EXData =  [EXData(1:jD-8),EXData(jD-8), EXData(jD-7:end)];
        EYData =  [EYData(1:jD-8),YData(jD/9), EYData(jD-7:end)];
    end
    set(hE,'XData',EXData); set(hE,'YData',EYData); 
end
set(hA,'yscale','log');


