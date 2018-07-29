function etch(materialName)
%*************************************************
%DATE: 13/8/2007 (created); 	22/8/2007 (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%muwn.gu@gmail.com
%*************************************************
global layerMatrix;

layerMatrix = flipud(layerMatrix);

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


if (isempty(find(layerMatrix == 9 )))
%	no photo resister
h = 1
for subLayerIndex = 1: size(layerMatrix, 1)	% sweep from left to right
	materialLocArray = find(layerMatrix(subLayerIndex, :) == materialNrm);
	if (isempty(materialLocArray)) % no material in this layer
		airLocArray = find(layerMatrix(subLayerIndex, :) == 0);
		 if (isempty (airLocArray))
			layerMatrix = flipud(layerMatrix);
			return;
		 end
	else							% have material in this layer
		layerMatrix(subLayerIndex, materialLocArray) = 0;
	end
end

else
%	if photoresister exist 
for pointIndex = 1: 96	% sweep from left to right
	etchFrom = find (layerMatrix(:, pointIndex), 1, 'first'); 	% find the first non-zero in each column
	if (etchFrom ~= 0)											% if this is not zero

		while (layerMatrix(etchFrom, pointIndex) == materialNrm )	% if it is materila number
			layerMatrix(etchFrom, pointIndex) = 0;
			etchFrom = etchFrom + 1;	
			if etchFrom == length(layerMatrix(:, pointIndex)) + 1  % if etch approch to the last, then return it to first, which mean stop it
			etchFrom = etchFrom - 1;	
			end
		end
	end
	
end;

end;

layerMatrix = flipud(layerMatrix);

function firstPart = extractfirstpart(allpart)
%*************************************************
%DATE: ?/?/200? (created); 	?/?/200? (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%*************************************************
for index = 1:length(allpart)-1
	diff(index) = allpart(index+1) - allpart(index);
end

index = 1;
while (diff(index) == 1)
	index = index + 1;
end
firstPart = allpart (1:index);
