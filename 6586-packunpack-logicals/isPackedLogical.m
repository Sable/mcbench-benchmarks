function bool = isPackedLogical(input)
%"isPackedLogical"
%   Returns one if input data was created by the packLogicals function,
%   zero if not.  A valid packedLogical is a struct with 3 fields, one
%   of which contains a comment saying 'Use unpackLogicals to decompress.'.
%
%By James R. Alaly
%
%JRA 12/27/04
%
%Usage:
%   function bool = isPackedLogical(input)

bool = 0;
if isstruct(input) & ...
   isfield(input, 'comment') & ...
   isfield(input, 'data') & ...
   isfield(input, 'dataSize') & ...
   strcmp(input.comment, 'Use unpackLogicals to decompress.')

    bool = 1;
    
end  