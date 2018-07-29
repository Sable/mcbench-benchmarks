function rpcode(varargin)
% RPCODE Generates P-files for all M-files recursively in all subfolders 
%                    
% USAGE:
%  RPCODE:                  without any arguments generates P-files for all the 
%                           M-files in current directory and in its 
%                           subdirectories recursively. 
%  RPCODE(path):            generates P-files for all the M-files in directory
%                           'path'and in its subdirectories recursively. 
%  RPCODE(path,flag):       if the flag -INPLACE is used, the result is placed 
%                           in the same directory in which the corresponding 
%                           M file was found. Otherwise, the result is placed 
%                           in the current directory.
%                                             
% INPUT:
%    path - name of the directory                                   
%    flag - flag for if the result is placed in the same directory ('-inplace')
%           or current directory                                 
%       
% OUTPUT:                              
%        
% EXAMPLES:
%    CurrPath = pwd;
%    rpcode(CurrPath,'-inplace');
%      
%   See also PCODE SUBDIR
%         
% Please note that RPCODE uses SUBDIR (Author: Elmar Tarajan) to lists
% (recursive) all subfolders and available in 
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=
% 1492&objectType=file 
%

% Author: Durga Lal Shrestha
% UNESCO-IHE Institute for Water Education, Delft, The Netherlands
% eMail: durgals@hotmail.com
% Website: http://www.hi.ihe.nl/durgalal/index.htm
% Copyright 2004-2008 Durga Lal Shrestha.
% $First created: 26-Mar-2008
% $Revision: 1.0.0 $ $Date: 26-Mar-2008 11:43:54 $

% ******************************************************************************
%% INPUT ARGUMENTS CHECK
error(nargchk(0,2,nargin))
% Default flag and path
inplace = false;                              
path = pwd;

if nargin >=1
	path = varargin{1};
	if ~exist(path, 'dir')
		error('RPCODE:PathNotFound', ...
          'Input argument must be valid path.');
	end
end
if nargin ==2
	if strcmpi(varargin{2},'-inplace'),
		inplace = true;                           % put F.P where F.M is
	else
		error('RPCODE:UnknownFlag', 'Unknown flag ''%s''.', varargin{2});
	end
end

%% 
subfolders = subdir(path);  % listing all path of the subfolders 
subfolders{end+1}=path;     % also include folder 'path' to the list 
nfolders = length(subfolders);
warning('off', 'MATLAB:pcode:FileNotFound');

% Apply pcode to each M-files of all subfolders
for i=1:nfolders
	disp(['Parsing M-files into the P-files: ' num2str(i) ' folder out of ' num2str(nfolders)])
	if inplace
		pcode([subfolders{i} '\*.m'],'-inplace')
	else
		pcode([subfolders{i} '\*.m'])
	end
end
% End of main function RPCODE
%*******************************************************************************
%
%% Sub Functions from file exchange
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1492&objectType=file
function [sub,fls] = subdir(CurrPath)
%   SUBDIR  lists (recursive) all subfolders and files under given folder
%    
%   SUBDIR
%        returns all subfolder under current path.
%
%   P = SUBDIR('directory_name') 
%       stores all subfolders under given directory into a variable 'P'
%
%   [P F] = SUBDIR('directory_name')
%       stores all subfolders under given directory into a
%       variable 'P' and all filenames into a variable 'F'.
%       use sort([F{:}]) to get sorted list of all filenames.
%
%   See also DIR, CD

%   author:  Elmar Tarajan [Elmar.Tarajan@Mathworks.de]
%   version: 2.0 
%   date:    07-Dez-2004
%
if nargin == 0
   CurrPath = cd;
end% if
if nargout == 1
   sub = subfolder(CurrPath,'');
else
   [sub fls] = subfolder(CurrPath,'','');
end% if
  %
  %
function [sub,fls] = subfolder(CurrPath,sub,fls)
%------------------------------------------------
tmp = dir(CurrPath);
tmp = tmp(~ismember({tmp.name},{'.' '..'}));
for i = {tmp([tmp.isdir]).name}
   sub{end+1} = [CurrPath '\' i{:}];
   if nargin==2
      sub = subfolder(sub{end},sub);
   else
      tmp = dir(sub{end});
      fls{end+1} = {tmp(~[tmp.isdir]).name};
      [sub fls] = subfolder(sub{end},sub,fls);
   end% if
end% if
