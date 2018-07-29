function res = csv2cell( filename, delimiter )
% res = csv2cell( filename )
% res = csv2cell( filename, delimiter )

if nargin < 2
    delimiter = ',';
end
rawData = textread( filename, '%s', 'delimiter', '\t' );
nLines = length( rawData );
idxDelim = cell( nLines, 1 );
nDelim = zeros( nLines, 1 );
for k = 1 : nLines
    idxDelim{ k } = [ find( rawData{ k } == delimiter ), length( rawData{ k } ) + 1 ];
    nDelim( k ) = length( idxDelim{ k } );
end
if any( diff( nDelim ) )
    fprintf( 'Warning: number of fields is not constant.\n' );
end
nFields = max( nDelim );
res = cell( nLines, nFields );
for k = 1 : nLines
    idx = 1;
    for field = 1 : nDelim( k )
        val = rawData{ k }( idx : idxDelim{ k }( field ) - 1 );
        val_num = str2double( val );
        if isnan( val_num )
            res{ k, field } = val;
        else
            res{ k, field } = val_num;
        end
        idx = idxDelim{ k }( field ) + 1;
    end
end
return
