function [Y,FS,NBITS,tag_info] = flacread(FILE)
%FLACREAD Read FLAC (".flac") sound file. (Free Lossless Audio Codec)
%    Y = flacread(FILE) reads a FLAC file specified by the string FILE,
%    returning the sampled data in Y. Amplitude values are in the range [-1,+1].
% 
%    [Y,FS,NBITS,tag_info] = FLACREAD(FILE) returns the sample rate (FS) in Hertz
%    and the number of bits per sample (NBITS) used to encode the
%    data in the file.
%
%    'tag_info' is a string containing the tag information of the file
% 
%    Supports up to 8 channels of data, with up to 32 bits per sample.
% 
%    See also FLACWRITE, WAVWRITE, AUREAD, AUWRITE.
a = length(FILE);
if a >= 5
    exten = FILE(a-4:a);
    if exten ~= '.flac'
        FILE = strcat(FILE,'.flac');
    end
end
if a <= 4
    FILE = strcat(FILE,'.flac');
end
if exist(FILE) ~= 2
    error('File not Found')
end
%%%%%% Location of the ".exe" Files
s = which('flacread.m');
ww = findstr('flacread.m',s);
location = s(1:ww-2);
%%%%Temporary file%%%%%%
tmpfile = ['temp.wav'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Info extraction using "flacinfo.exe"%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[stat,data_title] = dos([location,'\metaflac', ' --show-tag=TITLE  ', FILE]);
[stat,data_version] = dos([location,'\metaflac', ' --show-tag=VERSION  ', FILE]);
[stat,data_tracknumber] = dos([location,'\metaflac', ' --show-tag=TRACKNUMBER ', FILE]);
[stat,data_artist] = dos([location,'\metaflac', ' --show-tag=ARTIST  ', FILE]);
[stat,data_performer] = dos([location,'\metaflac', ' --show-tag=PERFORMER  ', FILE]);
[stat,data_copyright] = dos([location,'\metaflac', ' --show-tag=COPYRIGHT ', FILE]);
[stat,data_license] = dos([location,'\metaflac', ' --show-tag=LICENSE ', FILE]);
[stat,data_organization] = dos([location,'\metaflac', ' --show-tag=ORGANIZATION ', FILE]);
[stat,data_genre] = dos([location,'\metaflac', ' --show-tag=GENRE ', FILE]);
[stat,data_date] = dos([location,'\metaflac', ' --show-tag=DATE ', FILE]);
[stat,data_location] = dos([location,'\metaflac', ' --show-tag=LOCATION ', FILE]);
[stat,data_contact] = dos([location,'\metaflac', ' --show-tag=CONTACT ', FILE]);
tag_info = [data_title data_version data_tracknumber data_artist data_performer data_copyright data_license data_organization data_genre data_date data_location data_contact]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% File Decoding using "oggdec.exe" %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[stat_2,raw_data] = dos([location,'\flac', ' -d ', FILE ,' -f ',' -o ', '"',tmpfile,'"'])
if stat_2 == 1
    error('Error while decodong file. File may be corrupted')
end
[Y,FS,NBITS] = wavread(tmpfile);    % Load the data and delete temporary file
delete(tmpfile);