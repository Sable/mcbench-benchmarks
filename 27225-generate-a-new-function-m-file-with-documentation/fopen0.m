function fid = fopen0(varargin)
%FOPEN0 Wrapper for fopen that throws an error if the file could not be
% opened.
% 
% FID = FOPEN0(VARARGIN) is a wrapper for fopen that throws an error if
% the file could not be opened.

% $Author: rcotton $  $Date: 2010/04/12 10:36:31 $ $Revision: 1.2 $
% Copyright: Health and Safety Laboratory 2010

fid = fopen(varargin{:});
if fid == -1
   error('fopen0:CouldNotOpenFile', 'Could not open file');
end

end
