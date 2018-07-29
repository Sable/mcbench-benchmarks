
function out = avsReader( varargin )
% Author Ivar Eskerud Smith
% Read avisynth files, or read video files by invoking DirectShowSource(or other avisynth commands)
% with avisynth. (Avisynth must be installed, see http://avisynth.org/mediawiki/Main_Page)
% An avisynth script can be as simple as this:
% DirectShowSource( "avifile.avi" )
% The function returns an m*n*3 rgb image, or an info struct
%
% Usage:
% img = avsReader( 'avisynthfile.avs', 2 ) %get frame nr 2
%
% img = avsReader( avsargs, 2 ) %open an avifile by
%   using the avisynth arguments specified in avsargs. args has to be cell.
%   Args can be (the order is important):
%   {'video=DirectShowSource("avifile.avi")','video = video.TurnLeft()','return video'}
%   In this example DirectShowSource loads the file using DirectShow, then
%   the video is rotated 90 degrees left, and then the resulting video is
%   returned.
%   Note that when using avisynth commands, you have to specify them like
%   above with the video object.
%   Good:
%   {'video=DirectShowSource("avifile.avi")','video = video.TurnLeft()','return video'}
%   Bad:
%   {'DirectShowSource("avifile.avi")','TurnLeft()'}
%
% img = avsReader( 'avifile.avi', 2 ) %get frame nr 2 of avifile. This is
%   the same as calling img = avsReader( args, 2 ) with
%   args = { 'DirectShowSource("avifile.avi")' }
%
% info = avsReader( 'avisynthfile.avs' )   %returns a struct with info
%   about the video (width, height, fps, numFrames)
% info = avsReader( 'avisynthfile.avi' )   %same as above
%
% clearAvsReader %free avisynth library & pointers
%


if nargin==1
    filename = varargin{1};
    out = mavs(filename);
elseif nargin==2
    filename = varargin{1};
    framenr  = varargin{2};
    out = mavs( filename, framenr );
else
    error('Wrong number of input arguments') ;
end


