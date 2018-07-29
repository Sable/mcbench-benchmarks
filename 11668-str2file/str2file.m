function str2file(str, file, directory)
% str2file   writes a cell array of strings into a file 
% 
% Input:
% * str ... cell array of strings, i.e. str = {'aa','bbbb','','cc'}
% * file ... name of the file, i.e. file = 'test.txt'
% * (optional) directory ... destination directory
%
% Output:
% * A text file.
%
% Example
% Write cell array to textfile.
%+ str2file( {'aa','bbbb','','cc'}, 'test.txt' );
%
% See also: file2str
%
%% Signature
% Author: W.Garn
% E-Mail: wgarn@yahoo.com
% Date: 2005/12/01 20:00:00 
% 
% Copyright 2005 W.Garn
%
if nargin<3
    fid = fopen( file,'w' );
else   
    if directory(length(directory))== '/' || directory(length(directory))== '\',
        directory = directory(1:length(directory)-1);
    end
    if ~exist(directory,'dir'), mkdir(directory); end
    fid = fopen( [directory '/' file],'w' );
end

line_end = [char(13) char(10)]; %[char(10) char(13)]; % or '\n'
for k=1:length(str)
     fwrite(fid,[str{k} line_end], 'uchar'); 
end
fclose(fid);
