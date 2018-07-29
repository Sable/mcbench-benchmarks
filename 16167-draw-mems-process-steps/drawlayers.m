function drawlayers(varargin)
%*************************************************
%DATE: 11/8/2007 (created); 	11/8/2007 (modified)
%FUNCTION:	draw layers according to Layerstructure
%INPUTS:	layer structure matrix
%OUTPUTS:	NULL
%muwn.gu@gmail.com
%*************************************************
global Layerprofile;
global layerMatrix;
global layerColor;
layerNrm =  max(max(layerMatrix));
matrixSize =  size(layerMatrix);
lineNrm   =  matrixSize(1,1);
lineLength=  matrixSize(1,2);

for lineIndex = 1: lineNrm	% for layers

	for realLayerIndex = 1 : layerNrm    % for different layers

		if (layerMatrix(lineIndex, 1) == realLayerIndex)
			seg.from = 0;
		end

		for pointIndex = 1 : (lineLength-1)	% for point in one layer

			if (~(layerMatrix(lineIndex, pointIndex) == realLayerIndex)) & (layerMatrix(lineIndex, pointIndex + 1) == realLayerIndex)  
			seg.from = (pointIndex)/(lineLength);
			end

			if (layerMatrix(lineIndex, pointIndex) == realLayerIndex) & (~(layerMatrix(lineIndex, pointIndex + 1) == realLayerIndex))
			seg.end = (pointIndex)/(lineLength);
			fillColor	= getlayercolor (realLayerIndex);
			drawsegment (seg, fillColor);
			end
		end

		if (layerMatrix(lineIndex, lineLength) == realLayerIndex)
			seg.end = 1;
			fillColor	= getlayercolor (realLayerIndex);
			drawsegment (seg, fillColor);
		end
	end
			Layerprofile.currentY = Layerprofile.currentY + Layerprofile.lineWidth;
end

Layerprofile.currentY =  Layerprofile.currentY + Layerprofile.stepSpace;

function drawsegment(seg, fillcolor)
%*************************************************
%DATE: 11/8/2007 (created); 	11/8/2007 (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%*************************************************
global Layerprofile;
			xfrom 	= Layerprofile.diameter * seg.from; 
			xrange 	= Layerprofile.diameter * seg.end - xfrom;
			rectangle('Position',[Layerprofile.origin.x + xfrom, Layerprofile.currentY, xrange , Layerprofile.lineWidth], 'FaceColor', fillcolor, 'LineStyle', 'none')



function fillColor = getlayercolor(layerIndex)
%*************************************************
%FUNCTION:
%INPUTS:
%OUTPUTS:
%*************************************************
global 	Layerprofile;
switch	layerIndex 
	case 1 
		fillColor =  Layerprofile.color.silicon; 
	case 2 
		fillColor =  Layerprofile.color.sidioxi; 
	case 3 
		fillColor =  Layerprofile.color.metal; 
	case 4 
		fillColor =  Layerprofile.color.sini; 
	case 5 
		fillColor =  Layerprofile.color.posi; 
	case 9 
		fillColor =  Layerprofile.color.phore; 
	otherwise
		fillColor = [1, 1, 1];
end
