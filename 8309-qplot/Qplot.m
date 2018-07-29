function Qplot()
%QPLOT interactive ploting program
%	Qplot opens a standadr MATLAB figure with three options added to the
%	menu bar: Qfile, Qoptions and Qgraph. Under Qfile you can read data
%	files (text or Excel). Under Qoptions you can set the options of the
%	graph: what columns are the X, the Y and the Z, axis labels, etc. Under
%	Qgraph are the graph types that can be plotted under three categories:
%	2D, 3D and Stats. By default graphs are typically made with the X or X-Y
%	columns. Any number of subplots can be opened within the figure.

%	The full list of graphs is:
%	2D: XY Scatter, XY Line, XY Line with error bar, Horizontal Bar
%	(grouped), Horizontal Bar (stacked), Vertical Bar (grouped), Vertical
%	Bar (stacked), Vertical Bar with error bars, Histogram, Stem, Stairs,
%	Rose, Polar, Compass, Pie
%
%	3D: Scatter 3D, Stem 3D, Bar 3D, Waterfall, Ribbon, Grid, Surface,
%	Lighted Surface, Contour
%
%	Stats: Histogram (yes, repeated in 2D), Histogram 3D, Correlation X-Y,
%	Correlation All, QQplot, Normplot. 
%
%	'Correlation All' produces ouput to the command window. For more
%	details see function 'mcorr' in the File Exchange
%
%	Example data files are provided. Both comma separated and Excel
%
%	Author: F. de Castro. Last update: Nov 2009


clear all
warning off
global A cds opt holdon leg label figmain smmethod subpl

% Defaults form some things
opt= struct('xc',1,'yc',2,'ec',3,'zc',3);
label= struct('x','X','y','Y','z','Z','t','Title');
holdon= 0;
fullm= 0;
smmethod= {'linear','nearest','cubic','v4'};
smoothf= 1;
subpl= [1;1;1];

% Open figure
fp = get(0,'defaultfigureposition');
figmain= figure ('Toolbar','figure','Name','Qplot','Resize','On','NumberTitle','off','Color','white','Position',fp);

% Menu definitions
mfile= uimenu('Label','Qfile');
	uimenu(mfile,'Label','Read Text File','Callback','getdata(1)','Accelerator','R');
	uimenu(mfile,'Label','Read Excel File: All','Callback','getdata(2)','Accelerator','E');
	uimenu(mfile,'Label','Read Excel File: Selected Data','Callback','getdata(3)','Accelerator','I');
	uimenu(mfile,'Label','Save as...','Callback','savefigas','Accelerator','S');
	uimenu(mfile,'Label','Quit','Callback','exit','Separator','on','Accelerator','Q');

mopt= uimenu('Label','Qoptions');
	uimenu(mopt,'Label','X column  (def. 1)','Callback','getcols(''x'')','Accelerator','X')
	uimenu(mopt,'Label','Y columns','Callback','getcols(''y'')','Accelerator','Y')
	uimenu(mopt,'Label','Z column','Callback','getcols(''z'')','Accelerator','Z')
	uimenu(mopt,'Label','Error column','Callback','getcols(''e'')')
	uimenu(mopt,'Label','Axis Labels','Callback','getlabel','Accelerator','L')
	uimenu(mopt,'Label','Add graph to plot','Callback','window','Accelerator','A')
	uimenu(mopt,'Label','Subplots','Callback','subplots')
	msmoothf= uimenu(mopt,'Label','Smoothing method');
		uimenu(msmoothf,'Label','No smoothing','Callback','smoothf= 0;');
		uimenu(msmoothf,'Label','Linear','Callback','smoothf= 1;');
		uimenu(msmoothf,'Label','Nearest','Callback','smoothf= 2;');
		uimenu(msmoothf,'Label','Cubic','Callback','smoothf= 3;');
		uimenu(msmoothf,'Label','V4','Callback','smoothf= 4;');

graph= uimenu('Label','Qgraphs');
	m2d= uimenu(graph,'Label','2D');
		uimenu(m2d,'Label','XY Scatter','Callback','plot2d(''xyscatter'')');
		uimenu(m2d,'Label','XY Line','Callback','plot2d(''xyline'')');
		uimenu(m2d,'Label','XY Line with error bar','Callback','plot2d(''error'')');
		uimenu(m2d,'Label','Horizontal Bar (grouped)','Callback','plot2d(''hbarg'')');
		uimenu(m2d,'Label','Horizontal Bar (stacked)','Callback','plot2d(''hbars'')');
		uimenu(m2d,'Label','Vertical Bar (grouped)','Callback','plot2d(''vbarg'')');
		uimenu(m2d,'Label','Vertical Bar (stacked)','Callback','plot2d(''vbars'')');
		uimenu(m2d,'Label','Vertical Bar with error bars','Callback','plot2d(''barerror'')');
		uimenu(m2d,'Label','Histogram (Y)','Callback','plot2d(''hist'')');
		uimenu(m2d,'Label','Stem','Callback','plot2d(''stem'')');
		uimenu(m2d,'Label','Stairs','Callback','plot2d(''stairs'')');
		uimenu(m2d,'Label','Rose','Callback','plot2d(''rose'')');
		uimenu(m2d,'Label','Polar','Callback','plot2d(''polar'')');
		uimenu(m2d,'Label','Compass','Callback','plot2d(''compass'')');
		uimenu(m2d,'Label','Pie','Callback','plot2d(''pie'')');

	m3d= uimenu(graph,'Label','3D');
		uimenu(m3d,'Label','Scatter 3D','Callback','plot3d(''plot3'',smoothf)');
		uimenu(m3d,'Label','Stem 3D','Callback','plot3d(''stem3'',smoothf)');
		uimenu(m3d,'Label','Bar 3D','Callback','plot3d(''bar3'',smoothf)');
		uimenu(m3d,'Label','Waterfall','Callback','plot3d(''waterfall'',smoothf)');
		uimenu(m3d,'Label','Ribbon','Callback','plot3d(''ribbon'',smoothf)');
		uimenu(m3d,'Label','Grid','Callback','plot3d(''grid'',smoothf)');
		uimenu(m3d,'Label','Surface','Callback','plot3d(''surface'',smoothf)');
		uimenu(m3d,'Label','Lighted Surface','Callback','plot3d(''smoothfed'',smoothf)');
		uimenu(m3d,'Label','Contour','Callback','plot3d(''contour'',smoothf)');

	mstat= uimenu(graph,'Label','Stats');
		uimenu(mstat,'Label','Histogram (Y)','Callback','plotstat(''histo'')');
		uimenu(mstat,'Label','Histogram 3D','Callback','plotstat(''histo3'')');
		uimenu(mstat,'Label','Correlation X-Y','Callback','plotstat(''corrxy'')');
		uimenu(mstat,'Label','Correlation All','Callback','plotstat(''corrall'')');
		uimenu(mstat,'Label','QQplot','Callback','plotstat(''qqplot'')');
		uimenu(mstat,'Label','Normplot','Callback','plotstat(''normplot'')');


return
