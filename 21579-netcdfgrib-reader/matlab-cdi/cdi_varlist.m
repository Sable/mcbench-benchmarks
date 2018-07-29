% CDI_VARLIST: Returns the list of variables in a file . 
% The result is an array of structures with variable names and auxiliary information
% 
% X = CDI_VARLIST(file,nametable)
% 
%    Input:
%    ------
% 
%     -file (mandatory): file to read (NetCDF or GRIB file)
%     -nametable (mandatory): non standard GRIB nametable used by SMHI. 
%     If the nametable is empty or not given, a standard nametable from CDI is used.
%    
%    Output:
%    -------
%    
%     A structure array with the following fields:
% 	-varname: variable name of the variable (string)
% 	-long_name: long_name of the variable (string)
% 	-units: units (string)
%     The following fields are added if the file is a GRIB file:
% 	-grib_par=GRIB parameter (scalar)
% 	-grib_typ=GRIB type (scalar)
% 	-grib_lev=GRIB level (scalar)
% 
%   Example
%   -------
%   c = cdi_varlist('./examples/NA011_0410010600+000H00M','./examples/rcaname.txt');
%
%   See also CDI_READFIELD, CDI_READMETA, CDI_READALL, CDI_READFULL.
%
%   $Revision: 1.1.1.1 $  $Date: 2008/02/19 11:03:07 $
