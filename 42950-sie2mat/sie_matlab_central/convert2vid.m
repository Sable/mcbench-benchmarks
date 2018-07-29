function [  ] = convert2vid( vid_data, varargin )
%convert2vid - converts the video structure, as created by sie2mat.exe,
%and converts it to a video.
% Program is not optimised, but requires no video processing toolbox
%   Syntax
%       convert2vid( vid_data )  - returns a SIE_DATA structure with data from
%                               the sie file as defined in sie_flnme
%       convert2vid( vid_data, 'path', path_str )  -  path_str defines
%                               the location where the video is saved. 
%                               Default - current folder                        
%       convert2vid( vid_data, 'video_name', video_name_str )  -  video_name
%                               changes the name of the output video  
%                               Default - 'SIE_VIDEO'
%       convert2vid( vid_data, 'profile', profile_str )  -  profile
%                               String enclosed in single quotation marks that describes 
%                               the type of file to create. Specifying a profile sets default
%                               values for video properties such as VideoCompressionMethod. 
%                               Possible values:
%                                     'Archival' - Motion JPEG 2000 file with lossless compression
%                                     'Motion JPEG AVI' - Compressed AVI file using Motion JPEG codec 
%                                     'Motion JPEG 2000' - Compressed Motion JPEG 2000 file
%                                     'MPEG-4' - Compressed MPEG-4 file with H.264 encoding (Windows 7 systems only)
%                                     'Uncompressed AVI' - Uncompressed AVI file with RGB24 video
%                               Default: 'Motion JPEG AVI'
%       convert2vid( vid_data, 'framerate', FrameRate_int )  - FrameRate
%                               Rate of playback for the video in frames per second.
%                               Default: 30
%
% convert2vid.m
% Created by: MJ Stallmann
% Last modified: 02/08/2013


%% Start sie2mat
% get options
[options] = parseOptions( varargin{:});
[pathstr, name, ext] = fileparts(options.video_name) ;
vid_name=fullfile(options.path,name,'.avi');
writerObj = VideoWriter(vid_name,options.profile);
writerObj.FrameRate=options.framerate;
open(writerObj);
nframes=length(vid_data);
disp('Processing frames.... Please wait...')
for k = 1:nframes
    fid = fopen('temp.jpg', 'w');
    fwrite(fid, vid_data(k).Video_data, 'uint8');
    fclose(fid);
    frame = imread('temp.jpg');
    writeVideo(writerObj,frame);
end

close(writerObj);
delete('temp.jpg');
end

%% Set options
function options = parseOptions(varargin)
IP = inputParser;
IP.addParamValue('path', pwd, @ischar)
IP.addParamValue('video_name','SIE_VIDEO', @ischar)
IP.addParamValue('profile','Motion JPEG AVI', @ischar)
IP.addParamValue('framerate',30, @isnumeric)
IP.parse(varargin{:});
options = IP.Results;
end

