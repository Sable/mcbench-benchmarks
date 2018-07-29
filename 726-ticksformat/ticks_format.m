function ticks_format(x_formatstring, y_formatstring, z_formatstring)
%TICKS_FORMAT - Controls the format of tick labels
%
%Syntax:  ticks_format(x_formatstring, y_formatstring, z_formatstring);
%
%Inputs:  x_formatstring    %See online help for SPRINTF to learn
%         y_formatstring    %more about valid format strings
%         z_formatstring
%
%Output:  none
%
%Examples:  ticks_format('%5.2f');
%           ticks_format('%5.2f', '%4.1f');
%           ticks_format('%4.1f', '%5.2f', '%6.3f');
%           ticks_format('%4.1f', '%5.2f', '%+9.2e')
%
%M-files required: none
%Subfunctions:  none
%MAT-files required: none
%
%See also:  SPRINTF

%Author: Denis Gilbert, Ph.D., physical oceanography
%Maurice Lamontagne Institute, Dept. of Fisheries and Oceans Canada
%email: gilbertd@dfo-mpo.gc.ca  Web: http://www.qc.dfo-mpo.gc.ca/iml/
%September 2001; Last revision: 13-Sep-2001


if nargin == 1
    y_formatstring = x_formatstring;
    z_formatstring = x_formatstring;
end

xtick = get(gca,'xtick');
for i = 1:length(xtick)
    xticklabel{i} = sprintf(x_formatstring,xtick(i));
end
set(gca,'xticklabel', xticklabel)

ytick = get(gca,'ytick');
for i = 1:length(ytick)
    yticklabel{i} = sprintf(y_formatstring,ytick(i));
end
set(gca,'yticklabel', yticklabel)

if nargin == 3
    ztick = get(gca,'ztick');
    for i = 1:length(ztick)
        zticklabel{i} = sprintf(z_formatstring,ztick(i));
    end
    set(gca,'zticklabel', zticklabel)
end
