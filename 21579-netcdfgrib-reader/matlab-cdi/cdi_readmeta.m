% CDI_READMETA: Read all metadata for a variable from a file and return the result in a structure. 
% The result is a structure.
%
% X = CDI_READMETA(file, nametable, varname)
%
%    Input:
%    ------
% 
%     -file (mandatory): file to read (NetCDF or GRIB file)
%     -nametable (mandatory, not applicable for NetCDF files): non standard GRIB nametable used by SMHI. 
%           If the nametable is empty or not given, a standard nametable from CDI is used.
%     -varname (mandatory): string, or GRIB code, i.e. [grib_par grib_typ grib_lev] 
%           numeric triplet (c.f. output from cdi_varlist and cdi_readmeta). 
%           Example: varname can be “t22” or [11 109 22].
%
%    Output:
%    -------
%
%     A structure with the following fields:
%     -varname: variable_name of the variable 
%     -long_name: long_name of the variable 
%     -units: units 
%     -lon: array of longitudes
%     -lat: array of latitudes
%     -northpole_lon (present if relevant)
%     -northpole_lat (present if relevant)
%     -levels: array of vertical levels
%     -dates: array of timesteps in format 
%           YYYYMMDD.dec_hour where YYYY is a 4 digit year, MM a 2 digit month, DD a 2
%           digit day, and dec_hour the fraction of a 24-hour day
%   Example
%   -------
%   d = cdi_readmeta('./examples/NA011_0410010600+000H00M','./examples/rcaname.txt', 't2m');
%   d = cdi_readmeta('./examples/NA011_0410010600+000H00M','./examples/rcaname.txt', [11 105 2]);
%
%   See also CDI_VARLIST, CDI_READFIELD, CDI_READALL, CDI_READFULL.
%
%   $Revision: 1.1.1.1 $  $Date: 2008/02/19 11:03:07 $
