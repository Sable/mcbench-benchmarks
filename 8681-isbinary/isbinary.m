function isbin =  isbinary(theFile,nChars)
%ISBINARY   True for binary files
%
%   Syntax:
%      IS = ISBINARY(FILE,N)
%
%   Inputs:
%      FILE
%      N     Number of elements in file where char 0 will be searched
%            [ 1000 ]
%
%   Output:
%      IS   1 if FILE is binary and 0 otherwise, or [] if file fid=-1
%
%   MMA 17-09-2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

if nargin < 2
  nChars = 1000;
end

isbin=0;
fid=fopen(theFile);
if fid~=-1
  c=fread(fid,nChars);
  if any(c==0), isbin = 1; end
  fclose(fid);
else
  isbin=[];
end
