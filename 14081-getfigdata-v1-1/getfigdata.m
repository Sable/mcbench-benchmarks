function ldata = getfigdata(fignum)
% GETFIGDATA extracts the data from the lines on a plot
%  LDATA = GETFIGDATA(FIGNUM)
%
% GETFIGDATA retrieves the data from a MATLAB .fig file and saves it as
%   workspace variables that you can use. GETFIGDATA only works for lines,
%   not images or other data that might be in a .fig file.
%
% FIGNUM is the figure number of the plot of interest. If not given, the
%         current plot is used.
%
% LDATA is a cell array with the data from each line from each
%         axis in the plot. Each row is an axis and each column is a data
%         set (a line). Each cell is a structure with fields X and Y. A
%         figure with a basic plot of a single line will return a cell
%         array with one item. More complex plots will return larger
%         arrays.
%
% Example:
%
%   If Figure 2 is a plot of ten random numbers,
%
%   >> d = getfigdata(2)
%
%   d = 
% 
%       [1x1 struct]
%
%   retrieves the data from the lines in Figure 2. Access the data with cell
%   notation (curly brackets):
%
%   >> d{1}
%   ans = 
%             x: [1 2 3 4 5 6 7 8 9 10]
%             y: [1x10 double]
%     colorname: 'blue'
%        Marker: 'none'
%     
%
%   >> xpoints1 = d{1}.x;
%   >> ypoints1 = d{1}.y;
%
%   etc. Complex plots have many lines that are not data (errorbars,
%   arrows, etc). Use the color, Marker, and length to figure out which
%   ones are the data.
%
%
%
% M. A. Hopcroft
%  hopcroft at mems stanford edu
%
% MH MAY2007
% v1.1  add LineStyle
%       add line handle
%
% MH FEB2007
% v1.0  change x,y cell arrays to line cell arrays
%       add length display to help decide which cell has good data
%       add color function (is there a built-in for this?)
% v0.9
%

if nargin < 1
    fignum = gcf;
end


fprintf(1,'getfigdata: Get data from figure number %d.\n', fignum);

% how many axes are in the current figure?
chillun = get(fignum,'Children');

fprintf(1,'getfigdata: There are %d axes in the figure.\n', length(chillun));


k=0;
% for each axis
for i = chillun'
    k=k+1;
    % find all the lines on this axis
    dataline = findobj(i,'Type','line');
    fprintf(1,'getfigdata: Axis %f has %d lines.\n', i,length(dataline));
    m=0;
    % for each line, get the relevant properties
    for j = dataline'
        m=m+1;
        ldata{m,k}.handle = j;
        ldata{m,k}.x = get(j,'XData');
        ldata{m,k}.y = get(j,'YData');
        colordata = num2str(get(j,'Color'));
        if ~isnumeric(Mgetcolorname(colordata))
            ldata{m,k}.colorname = Mgetcolorname(colordata);
        else
            ldata{m,k}.Color = get(j,'Color');
        end
        ldata{m,k}.LineStyle = get(j,'LineStyle');
        ldata{m,k}.Marker = get(j,'Marker');
        if length(dataline) > 1
            lengtharray(m,k)=length(ldata{m,k}.x);
        end
    end
end

if length(dataline) > 1
    fprintf(1,'getfigdata: There are multiple lines;\n');
    fprintf(1,'   The length of each data set is:\n');
    disp(lengtharray)
end

return

function lname = Mgetcolorname(ctriple)
% Mgetcolor returns the long name for the common MATLAB colors.
% LNAME = MGETCOLORNAME(CTRIPLE)
%

namearray = {
    '1  1  0','yellow';
    '1  0  1','magenta';
    '0  1  1','cyan';
    '1  0  0','red';
    '0  1  0','green';
    '0  0  1','blue';
    '1  1  1','white';
    '0  0  0','black';
};

lname = 0;
for i = 1:length(namearray)
    if strcmp(ctriple,namearray{i,1})
        lname = namearray{i,2};
    end
end

return