function deposit(varargin)
%*************************************************
%DATE: 11/8/2007 (created); 	23/8/2007 (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%*************************************************
materialName 	= varargin{1};
thickness		= varargin{2};

shiftFrom	= 0;

%=======================material color table=========================
global Layerprofile;
global layerMatrix;

switch materialName
	case 'Si' 
		materialNrm = 1;
	case 'SiO2' 
		materialNrm = 2;
	case 'metal' 
		materialNrm = 3;
	case 'SiNi' 
		materialNrm = 4;
	case 'PoSi' 
		materialNrm = 5;
	case 'PR' 
		materialNrm = 9;
end

newLayerMatrixHeight = round (thickness);
newLayerMatrix = zeros(newLayerMatrixHeight, 96);

if sum(sum(layerMatrix)) == 0 % if it is empty
layerMatrix =  newLayerMatrix + materialNrm;
else
layerMatrix = vertcat(newLayerMatrix, layerMatrix); % unite
	for pointIndex = 1:96
		depositFrom = find(layerMatrix(:, pointIndex), 1,'last');
      	layerMatrix (((depositFrom+1 ) : (depositFrom+1+newLayerMatrixHeight)), pointIndex) = materialNrm;
	end
end

layerMatrix = rounddeposit(layerMatrix, materialNrm);

function layerMatrix = rounddeposit(layerMatrix, materialNrm)
%*************************************************
%DATE: 23/8/2007 (created); 	23/8/2007 (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%*************************************************

	for pointIndex = 1:96
		depositFromArray(pointIndex) = find(layerMatrix(:, pointIndex), 1,'last');
	end

	oldDepositFromArray = depositFromArray;
save('old', 'oldDepositFromArray');
	for pointIndex = 1:95
		diff = oldDepositFromArray(pointIndex) - oldDepositFromArray(pointIndex+1);
		if (diff>0)	
		addDepositArray = calculateroundarray(diff);

		index = pointIndex + 1;
		nrm   = 1;
			while (index <= 96 & nrm <= size(addDepositArray, 2))
			depositFromArray(index) = depositFromArray(index) + addDepositArray(nrm);
			index = index + 1;
			nrm   = nrm + 1;
			end
		end
	end

	for pointIndexI = 0:94
		pointIndex = 96 - pointIndexI;
		diff = oldDepositFromArray(pointIndex) - oldDepositFromArray(pointIndex-1);
		if (diff>0)	
		addDepositArray = calculateroundarray(diff);

			index = pointIndex - 1;
			nrm   = 1;
			while (index > 0 & nrm <= size(addDepositArray, 2))
			depositFromArray(index) = depositFromArray(index) + addDepositArray(nrm);
			index = index - 1;
			nrm   = nrm + 1;
			end
		end
	end

	for pointIndex = 1:96
		layerMatrix(oldDepositFromArray(pointIndex):depositFromArray(pointIndex), pointIndex) = materialNrm;	
	end

function roundArray = calculateroundarray(diff)
%*************************************************
%FUNCTION:
%INPUTS:
%OUTPUTS:
%*************************************************
roundArray(1) = 0;
		a = -4/diff;
		b = diff;
		for pointDiff=1:round(diff/2)
		temp = floor (a * pointDiff^2 + b);
			if (temp < 0)
				return;
			end
			roundArray(pointDiff) = temp;
		end

