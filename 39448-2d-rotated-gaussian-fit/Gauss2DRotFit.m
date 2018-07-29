function [fitresult, gof] = gauss2DRotFit(im,varargin)
%gauss2DRotFit(im,fop,title)
%  Create a fit.
%  Input :
%   
%      im  : input image of 2D gaussian
%      fop : fitoptions - a structure with 3 fields : Lower,StartPoint and
%            Upper. Each of the fields is an array of 7 values : 
%            offset
%             amplitude of the 2D gaussian
%             centroid X of the 2D gaussian
%             centroid Y of the 2D gaussian
%             angle of rotation for the 2D gaussian
%             width X of the 2D gaussian
%             width Y of the 2D gaussian
%
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%

if nargin==0
    errordlg('gauss2DRotFit has to be called with at least 1 argument');
    return;
end
[sx,sy,sz]=size(im);
if sz==3
    im=rgb2gray(im);
end
[X,Y]=meshgrid(1:sy,1:sx);
 

mystr='Untitled fit';
 
[xData, yData, zData] = prepareSurfaceData( X,Y, im );

% Set up fittype and options.
ft = fittype( 'a + b*exp(-(((x-c1)*cosd(t1)+(y-c2)*sind(t1))/w1)^2-((-(x-c1)*sind(t1)+(y-c2)*cosd(t1))/w2)^2)', 'independent', {'x', 'y'}, 'dependent', 'z' );


opts = fitoptions( ft );
if numel(varargin)>0
    s=varargin{1};
    if isfield(s,'Lower')
        opts.Lower=s.Lower;
    end
    if isfield(s,'StartPoint')
        opts.StartPoint=s.StartPoint;
    end
    if isfield(s,'Upper')
        opts.Upper=s.Upper;
    end
end
if numel(varargin)==2
    mystr=varargin{2};
end
    
opts.Display = 'Off';
 

% Fit model to data.
[fitresult, gof,fout] = fit( [xData, yData], zData, ft, opts );


opts
gof
fout
% Create a figure for the plots.
figure( 1);
set(gcf,'Name', '2D Gaussian fit 1' );
set(gcf,'Position',[10,10,900,600]);

% Plot fit with data.

h = plot( fitresult, [xData, yData], zData);
legend( h, mystr, 'im vs. X, Y',  'Location', 'NorthEast' );
% Label axes
xlabel( 'X' );
ylabel( 'Y' );
zlabel( 'im' );
grid on
colormap(jet);

% Plot residuals.
figure(2);
set(gcf,'Name', 'Gaussian fit Residuals');
set(gcf,'Position',[100,100,900,600]);
h = plot( fitresult, [xData, yData], zData, 'Style', 'Residual');
legend( h, [mystr  ' - residuals'], 'Location', 'NorthEast' );
% Label axes
xlabel( 'X' );
ylabel( 'Y' );
zlabel( 'im' );
grid on
figure(1);

