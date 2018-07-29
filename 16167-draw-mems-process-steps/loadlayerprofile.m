function loadlayerprofile(varargin)
%*************************************************
%DATE: 10/8/2007 (created); 	10/8/2007 (modified)
%FUNCTION: 	load layer profiles
%INPUTS: 	NULL
%OUTPUTS:	NULL
%muwn.gu@gmail.com
%*************************************************
global Layerprofile
Layerprofile.color.silicon =  	[53, 53, 53]/255;
Layerprofile.color.sidioxi=  	[85, 85, 85]/255;
Layerprofile.color.metal =  	[146, 146, 146]/255;
Layerprofile.color.sini=  		[190, 190, 190]/255;
Layerprofile.color.posi=  		[220, 220, 200]/255;
Layerprofile.color.phore =  	[0.1, 0.1, 0.4];

Layerprofile.origin.x = 20;
Layerprofile.origin.y = 10;

Layerprofile.stepSpace = 6;

Layerprofile.currentY = Layerprofile.origin.y;

Layerprofile.diameter = 54;


Layerprofile.lineWidth = 0.3;

global layerMatrix;
global layerColor;
