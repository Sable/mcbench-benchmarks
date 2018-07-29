function [compression_ratio] = flacwrite(varargin);
%flacWRITE Write FLAC (".FLAC") sound file. (Free Lossless Audio Codec)
%    FLACWRITE(Y,FS,NBITS,FLACFILE,ENCODING) writes data Y to a FLAC Vorbis
%    file specified by the file name FLACFILE, with a sample rate
%    of FS Hz and with NBITS number of bits. Stereo data should 
%    be specified as a matrix with two columns. 
%    ENCODING must be specified as an integer number from 1 to 9
% 
%   1 = Fast Encoding.
%   .
%   .
%   .
%   9 = Best Encoding.
%
%   Y,FS and NBITS are mandatory fields. If FLACFILE is not defined the file
%   name will be 'Default_name.flac'. If ENCODING is not defined encoding
%   type '2' will be used by deault.
%   
%   [compression_ratio] = flacwrite(Y,FS,NBITS,FLACFILE,ENCODING); returns
%   the compression ratio obtained.
%
%    See also FLACREAD, WAVREAD, WAVWRITE.
if length(varargin) < 3 | length(varargin) > 5
    error('Unsopported number of argument inputs') 
end
Y = varargin{1};
FS = varargin{2};
NBITS = varargin{3};
if NBITS~=8 & NBITS~=16 & NBITS~=24 & NBITS~=32
    error('Unsopported bit depth')
end
if length(varargin) >= 4
    FLACFILE = varargin{4};
    if ischar(FLACFILE) ~= 1
        error('File name is not a string') 
    end
else
    FLACFILE = 'Default_name.flac';
    disp('File name = Default_name.flac')
end

if isempty(findstr(FLACFILE,'.flac'))
    FLACFILE = strcat(FLACFILE,'.flac');
end

if length(varargin) == 5
    ENCODING = varargin{5};
else
    ENCODING = '2';
    disp('Variable bit rate, joint-stereo, 128 kb/s encoding')
end
app_dir = which('flacwrite.m');
app_dir_base = findstr('flacwrite.m',app_dir);
encoder_dir = app_dir(1:app_dir_base-2);
%%%%% Temporary File %%%%%
[data,channels] = size(Y);
wavwrite(Y,FS,NBITS,strcat(encoder_dir,'\temp.wav'));
tmpfile = strcat(encoder_dir,'\temp.wav');
FLACFILE = strcat(pwd,'\',FLACFILE);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Data Encoding  using "flac.exe"  %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ENCODING =  num2str(ENCODING);
switch ENCODING
    case {'1'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -0 ', ' -f ',' -o ',FLACFILE]);
    case {'2'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -1 ', ' -f ',' -o ',FLACFILE]);
    case {'3'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -2 ', ' -f ',' -o ',FLACFILE]);
    case {'4'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -3 ', ' -f ',' -o ',FLACFILE]);
    case {'5'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -4 ', ' -f ',' -o ',FLACFILE]);
    case {'6'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -5 ', ' -f ',' -o ',FLACFILE]);
    case {'7'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -6 ', ' -f ',' -o ',FLACFILE]);
    case {'8'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -7 ', ' -f ',' -o ',FLACFILE]);
    case {'9'}
        [stat,info_out] = dos([encoder_dir,'\flac.exe', ' ', tmpfile, ' ', ' -8 ', ' -f ',' -o ',FLACFILE]);       
    otherwise
        error('Encoding parameters not suported') 
        stat = 2;
end
compression_ratio_ini = findstr(info_out,'bytes, ratio=');
compression_ratio_end = compression_ratio_ini+18;
compression_ratio = info_out(compression_ratio_ini+6:compression_ratio_end);
if stat == 1
    delete(FLACFILE);
    delete(tmpfile);
    error('Error while encoding')
end
%Delete temporary file
delete(tmpfile);

