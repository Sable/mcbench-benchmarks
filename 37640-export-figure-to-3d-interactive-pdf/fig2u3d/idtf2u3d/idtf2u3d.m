function [] = idtf2u3d(idtffile, u3dfile)
%IDTF2U3D   Convert IDTF to U3D file.
%
% usage
%   IDTF2U3D
%   IDTF2U3D(IDTF_filename)
%   IDTF2U3D(IDTF_filename, U3D_filename)
%
% optional input
%   idtffile = filename string for IDTF file (default = 'matfig.idtf')
%   u3dfile = filename string for U3D file (default = 'matfig.u3d')
%
% output
%   Conerts the IDTF file into a U3D file which is saved to the disk.
%
% note
%   If only IDTF file name is provided without extension, then the '.idtf'
%   file extension is appended and the U3D file uses the same name with the
%   '.u3d' file extension appended.
%
%   If only the IDTF file name is provided with the extension '.idtf', then
%   the U3D file uses the same name with the '.idtf' extension replaced by
%   the extension '.u3d'.
%
%   If both file names are provided, any one without the appropriate
%   extension gets appended with that extension ('.idtf' and '.u3d',
%   respectively).
%
% reference
%   IDTF (Intermediate Data Text File) Format Description, Version 100,
%   Intel Corporation, 2005, available at:
%       http://u3d.svn.sourceforge.net/viewvc/u3d/releases/Gold12Update/Docs/IntermediateFormat/IDTF%20Format%20Description.pdf
%
% See also FIG2U3D, FIG2PDF3D, FIG2IDTF.
%
% File:      idtf2u3d.m
% Author:    Ioannis Filippidis, jfilippidis@gmail.com
% Date:      2011.02.17 - 2012.06.21
% Language:  MATLAB R2012a
% Purpose:   convert IDTF file to U3D file format
%
% Based on MESH_TO_LATEX.m by Alexandre Gramfort, which is part of
% "Matlab mesh to PDF with 3D interactive object"
% which is Copyright (c) by Alexandre Gramfort under the BSD License
% The link on the MATLAB Central File Exchange is:
% http://www.mathworks.com/matlabcentral/fileexchange/25383-matlab-mesh-to-pdf-with-3d-interactive-object

% depends
%   clear_file_extension, check_file_extension
%   IDTFConverter executables in ./bin directory

%% input
if nargin < 1
    idtffile = 'matfig.idtf';
    u3dfile = 'matfig.u3d';
end

if nargin < 2
    u3dfile = clear_file_extension(idtffile, '.idtf');
end

%% filenames & extensions

% fname extensions ok ?
idtffile = full_fname_with_extension(idtffile, 'idtf');
u3dfile = full_fname_with_extension(u3dfile, 'u3d');

%% prepare command
mfiledir = fileparts(mfilename('fullpath') );
curpath = pwd;

% Intel Mac
if ismac
    idtf_executable_path = [mfiledir, '/bin/maci/'];
    cd(idtf_executable_path)
    
    IDTFcmd = './IDTFConverter';
    
    %temp = [getenv('DYLD_LIBRARY_PATH'), ':"', mfiledir, '/bin/maci/"'];
    %setenv('DYLD_LIBRARY_PATH', temp)
    %IDTFcmd = ['"', mfiledir, '/bin/maci/', IDTFcmd, '"'];
end

% Linux
if isunix && ~ismac
    idtf_executable_path = [mfiledir, '/bin/glx/'];
    cd(idtf_executable_path)
    
    IDTFcmd = './IDTFConverter.sh';
    
    %temp = [getenv('LD_LIBRARY_PATH'), ':"', mfiledir, '/bin/glx/"'];
    %setenv('LD_LIBRARY_PATH', temp)
    %IDTFcmd = ['"', mfiledir, '/bin/glx/', IDTFcmd, '.sh"'];
end

% windows
if ispc
    win_mfiledir = strrep(mfiledir, '\', '\\');
    IDTFcmd = ['"', win_mfiledir, '\\bin\\w32\\IDTFConverter.exe"'];
end

%% idtf -> u3d conversion
s = [IDTFcmd, ' -input "%s" -output "%s"'];
idtf2u3dcmd = sprintf(s, idtffile, u3dfile);
disp(idtf2u3dcmd)
[status, result] = system(idtf2u3dcmd);
cd(curpath) % go back

disp(result)
if status ~= 0
    error('idtf2u3d:conversion',...
          'IDTFConverter executable returned with error.')
end

function [fname] = full_fname_with_extension(fname, extension)
fname = check_file_extension(fname, extension);
fname  = fullfile(cd, fname);
