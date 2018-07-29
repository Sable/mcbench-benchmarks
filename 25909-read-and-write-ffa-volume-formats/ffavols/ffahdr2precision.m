function [ precision ] = ffahdr2precision( header );
%
%   function [ precision ] = ffahdr2precision( header );
%
%
%   Read info from the header fields and return an fwrite friendly
%   precision string.


precision = [];

if ( header.floatflag == 1 )
    if ( header.databits == 16 )
        precision = 'single';
    elseif ( header.databits == 32 )
        precision = 'float32';
    elseif ( header.databits == 64 )
        precision = 'double';
    end
   
    return;
end


if ( header.signflag == 0 )
    precision = 'u';
end

if ( header.voxelbits == 8 )
    precision = [ precision 'int8' ];
    
elseif ( header.voxelbits == 16 )
    precision = [ precision 'int16' ];
    
elseif ( header.voxelbits == 32 )
    precision = [ precision 'int32' ];
end

