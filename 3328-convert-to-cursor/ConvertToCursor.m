function out = ConvertToCursor(i)

% Converts an RGB image to a matlab compatiable cursor CData.
%
% White Pixels and black pixels will be kept. All other values
% will be converted to NaN (transparent)
%
% Author: Richard Medlock. (2003)

nRows = size(i,1);
nCols = size(i,2);

for r = 1:nRows
    
    for c = 1:nCols
        
        if i(r,c,1) == 255 & i(r,c,2) == 255 & i(r,c,3) == 255 % White
            
            out(r,c) = 2;
            
        elseif i(r,c,1) == 0 & i(r,c,2) == 0 & i(r,c,3) == 0 % Black
            
            out(r,c) = 1;
            
        else % Any other colour
            
            out(r,c) = NaN; 
            
        end
    end
end

