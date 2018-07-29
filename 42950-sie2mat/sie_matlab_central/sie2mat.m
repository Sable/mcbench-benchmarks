function [  ] = sie2mat( sie_flnme, varargin )
%sie2mat - calls sie2mat_ws.exe and loads the data from the sie file to the
%Matlab workspace
%   Syntax
%       sie2mat( sie_flnme )  - returns a SIE_DATA structure with data from
%                               the sie file as defined in sie_flnme
%       sie2mat( sie_flnme, 'sie2mat_loc', path_str )  -  path_str defines
%                               the location of the sie2mat_ws.exe . 
%                               Default - 'C:\Program Files\VDG\sie2mat_ws\sie2mat_ws.exe'
%       sie2mat( sie_flnme, 'data_name', struct_name_str )  -  data_name
%                               changes the name of the output structure to struct_name_str  
%                               Default - 'SIE_DATA'                            
%       sie2mat( sie_flnme, 'video', video_int )  -  if video_out is
%                               set to 1, a vid_data structure will be
%                               created if a video data channel is found
%                               Default - 0                           
%       sie2mat( sie_flnme, 'video_name', video_name_str )  -  video_name
%                               changes the name of the output video structure to video_name_str  
%                               Default - 'SIE_VIDEO'
%
% sie2mat.m
% Created by: MJ Stallmann
% Last modified: 02/08/2013


%% Start sie2mat
% get options
[options] = parseOptions( varargin{:});
% set path to MATLAB dll's
system(['set PATH="' matlabroot '";%PATH% ']);
% check if sie_flnme has a defined path, if not add current folder as path
[pathstr, name, ext] = fileparts(sie_flnme) ;
if isempty(pathstr)
    currentFolder = pwd;   
    sie_flnme=fullfile(currentFolder,sie_flnme);
end
% run sie2mat.exe
system(['"' options.sie2mat_loc '" -input "' sie_flnme '" -output_data  ' options.data_name ' -video ' num2str(options.video) ' -output_vid  ' options.video_name ]);
end

%% Set options
function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('sie2mat_loc', 'C:\Program Files\VDG\sie2mat_ws\sie2mat_ws.exe', @ischar)
IP.addParamValue('data_name','SIE_DATA', @ischar)
IP.addParamValue('video',0, @isnumeric)
IP.addParamValue('video_name','SIE_VIDEO', @ischar)
IP.parse(varargin{:});
options = IP.Results;
end

