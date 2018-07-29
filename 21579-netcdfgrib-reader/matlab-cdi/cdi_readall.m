% CDI_READALL: Read all variables and all their metadata from a file. 
% The result is an array of structure.
% 
% X = CDI_READALL(file, nametable)
%
%    Input:
%    ------
% 
%     -file (mandatory): file to read (NetCDF or GRIB file)
%     -nametable (mandatory, not applicable for NetCDF files): non standard GRIB nametable used by SMHI. 
%           If the nametable is empty or not given, a standard nametable from CDI is used.
%
%    Output:
%    -------
%
%     An array of structure with the following fields:
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
%     -data: A 4D matrix of size (XxYxZxT) where X and Y are the grid size, 
%         Z is the levels number and T is the timestep number.
%         If there is one level and one timestep, the output will be a 4D (i.e. 2D) matrix (XxYx1x1)
%         If there is one level and several timesteps, the output will be a 4D matrix (XxYx1xT).
%         If there are several levels and one timestep, the output will be a 4D (i.e. 3D) matrix (XxYxZx1).
%         If there are several levels and several timesteps, the output will be a 4D matrix (XxYxZxT).
%  
%   Example
%   -------
%   a = cdi_readall('./examples/NA011_0410010600+000H00M','./examples/rcaname.txt');
%
%   See also CDI_VARLIST, CDI_READMETA, CDI_READALL, CDI_READFIELD.
% 
%   $Revision: 1.1.1.1 $  $Date: 2008/02/19 11:03:07 $
