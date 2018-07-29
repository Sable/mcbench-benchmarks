function [X,Y,Z] = unplot(filename)
%%To unplot data from a matlab figure (.fig) files generated
% using version 7 or later. It can be used for both 2D and 3D plots
% Example usage:
% To unplot 2D graphs 
% [x,y] = unplot('example2D.fig')
% To unplot 3D graphs 
% [x,y,z] = unplot('example3D.fig') 

% Pradyumna
% January 2012

if nargin==1
    fig1 = load (filename,'-mat');
    a = fig1.hgS_070000.children.children(1,1).properties;
    if isfield(a,'ZData')
        % unploting 3D plot
        Y = fig1.hgS_070000.children.children(1,1).properties.YData;
        X = fig1.hgS_070000.children.children(1,1).properties.XData;
        Z = fig1.hgS_070000.children.children(1,1).properties.ZData;
    else
        % unploting 2D plot
        Y = fig1.hgS_070000.children.children(1,1).properties.YData;
        X = fig1.hgS_070000.children.children(1,1).properties.XData;
    end
else
    disp('Usage unplot(''filename.fig''). See ''help unplot'' for more details');
end