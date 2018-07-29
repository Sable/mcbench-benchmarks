function file = rel2fullfile(file,refpath)
%REL2FULLFILE   Build full filename from relative file name
%   REL2FULLFILE(RELFILE,PATH) builds a full file name from the relative
%   path name RELFILE with respect to PATH. RELFILE may be a cellstr array
%   of file names.
%
%   REL2FULLFILE(RELFILE) builds the full filename using the current
%   MATLAB working directory as PATH.
%
%   See also relfile, fileparts, fullfile, filesep.

% Written by: Takeshi Ikuma
% Date: 10/31/2009
% Revision History:
%  (12/03/2010) allow '/' as the file separator in Windows
%  (01/19/2011) allow multiple file to be converted at once
%  (05/16/2013) whole function rewritten to use regexp with 'split' option

error(nargchk(1,2,nargin));

if nargin<2, refpath = ''; end

if isempty(file), return; end
if isempty(refpath), refpath = pwd; end

% make sure the input is char not cellstr, convert if necessary
if iscellstr(file)
   % if cell array, use recursion
   file = cell(size(file));
   for n = 1:numel(file)
      file{n} = rel2fullfile(file{n},refpath);
   end
elseif ~ischar(file)
   error('FILE must be a string or a cellstr array.');
end

if iscellstr(refpath), refpath = char(refpath); end
if ~ischar(refpath) || size(refpath,1)~=1
   error('PATH must be a string');
end

% check if file is already fullfile, & if so exit immediately 
switch computer
   case {'PCWIN' 'PCWIN64'} % Win
      % replace all slash with backslash
      file = strrep(file,'\',filesep);
      refpath = strrep(refpath,'\',filesep);
      
      if file(1)==filesep % root directory given
         if file(2)~=filesep % if local, append the root's drive letter
            file = strcat(refpath(1:2),file);
         end
         return;
      elseif file(2)==':' % drive letter given
         return;
      end
   case {'GLNXA64' 'MACI64'} % Unix
      if file(1)==filesep || file(1)=='~'
         return;
      end
   otherwise
      error('Unsupported operating system.');
end

% split file name into cell array of folders
pathsepexp = ['(?<!\' filesep ')\' filesep '(?!\' filesep ')'];
fileparts = regexp(file,pathsepexp,'split');
refparts = regexp(refpath,['\' filesep '{1,2}'],'split');

for n = 1:numel(fileparts)
   part = fileparts{n};
   N = numel(part);
   if N==1 && part(1)=='.'
      continue; % nothing to do
   elseif N==2 && all(part=='..')
      if isempty(refparts)
         error('Invalid path.');
      end
      refparts(end) = [];
   else
      break;
   end
end

file = fullfile(refparts{:},fileparts{n:end});
if isempty(refparts{1}) % Linux root directory
   file = [filesep file];
end

% Copyright (c)2009-2013, Takeshi Ikuma
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer. *
%     Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in the
%     documentation and/or other materials provided with the distribution.
%     * Neither the name of the <ORGANIZATION> nor the names of its
%     contributors may be used to endorse or promote products derived from
%     this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
% IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
% PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
% CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
% EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
% PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
% LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
% NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
% SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

