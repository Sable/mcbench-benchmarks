function [ result ] = export_df3( filename, chg )
%EXPORT_DF3 Export volumetric data as a DF3 file.
%   status = export_df3(filename,chg) exports the volumetric data contained
%   the 3 dimensional array chg as a DF3 file. This format is compatible 
%   with the POV-Ray ray-tracing package. The data is scaled up by a factor
%   of 1,000,000.

    fid = fopen(filename, 'w');
    if fid==-1
        error(['Error opening ' filename]); 
    end
    fwrite(fid, size(chg), 'ushort',0,'ieee-be');
    fwrite(fid, 1e6*chg, 'ulong',0,'ieee-be');
    result = fclose(fid);

end

