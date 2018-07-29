function liga(pattern)
%*************************************************
%DATE: 13/8/2007 (created); 	13/8/2007 (modified)
%FUNCTION:
%INPUTS:
%OUTPUTS:
%muwn.gu@gmail.com
%*************************************************

global layerMatrix;

segLengthArray = extractPattern (pattern);

for segIndex = 1: size(segLengthArray, 2)
	
	segFrom = round ( 96 * segLengthArray(segIndex).from);
	if (segFrom == 0)
		segFrom = 1;
	end
	segEnd	= round ( 96 * segLengthArray(segIndex).end); 

	for pointIndex = segFrom:segEnd 			% horzontal sweep

		prIndex = find(layerMatrix(:,pointIndex) == 9); % find the photo resister sublines in current pointIndex
		layerMatrix (prIndex, pointIndex) = 0;

	end
end


function [segLengthArray] = extractPattern(pattern)
%*************************************************
%DATE: 11/8/2007 (created); 	11/8/2007 (modified)
%FUNCTION:	extract segment number and length array from pattern
%INPUTS:	pattern string
%OUTPUTS:	segLengthArray
%*************************************************
%'  -- -- -'
%'1234567890 
segIndex = 1;
patternLength = length (pattern);

if (pattern(1, 1) == ' ')
segLengthArray(1).from = 0;
end

for charIndex =  1:patternLength - 1

	if (pattern(1, charIndex) == '-') & (pattern(1, charIndex+1) == ' ')
		segLengthArray(segIndex).from = (charIndex)/(patternLength);
	end

	if (pattern(1, charIndex) == ' ') & (pattern(1, charIndex+1) == '-')
		segLengthArray(segIndex).end = (charIndex)/(patternLength);
		segIndex =  segIndex + 1;
	end
end

	if (pattern(1, patternLength) == ' ')
		segLengthArray(segIndex).end = 1;
	end

