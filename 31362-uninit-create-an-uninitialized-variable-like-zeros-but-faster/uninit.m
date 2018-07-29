%  UNINIT returns an unitialized array of specified size and class.
%*************************************************************************************
% 
%  MATLAB (R) is a trademark of The Mathworks (R) Corporation
% 
%  Function:    uninit
%  Filename:    uninit.c
%  Programmer:  James Tursa
%  Version:     1.00
%  Date:        May 03, 2011
%  Copyright:   (c) 2011 by James Tursa, All Rights Reserved
% 
%  Change Log:
%  2011/May/03 --> 1.00, Initial Release
% 
%   This code uses the BSD License:
% 
%   Redistribution and use in source and binary forms, with or without 
%   modification, are permitted provided that the following conditions are 
%   met:
% 
%      * Redistributions of source code must retain the above copyright 
%        notice, this list of conditions and the following disclaimer.
%      * Redistributions in binary form must reproduce the above copyright 
%        notice, this list of conditions and the following disclaimer in 
%        the documentation and/or other materials provided with the distribution
%       
%   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%   POSSIBILITY OF SUCH DAMAGE.
% 
%  Building:
% 
%  UNINIT is typically self building. That is, the first time you call UNINIT,
%  the uninit.m file recognizes that the mex routine needs to be compiled and
%  then the compilation will happen automatically. UNINIT uses the undocumented
%  MATLAB API function mxCreateUninitNumericMatrix. It has been tested in PC
%  versions R2008b through R2011a, but may not work in future versions of MATLAB.
% 
%  Syntax (nearly identical to the ZEROS function)
% 
%  B = uninit
%  B = uninit(n)
%  B = uninit(m,n)
%  B = uninit([m n])
%  B = uninit(m,n,p,...)
%  B = uninit([m n p ...])
%  B = uninit(size(A))
%  B = uninit(m, n,...,classname)
%  B = uninit([m,n,...],classname)
%  B = uninit(m, n,...,complexity)
%  B = uninit([m,n,...],complexity)
%  B = uninit(m, n,...,classname,complexity)
%  B = uninit([m,n,...],classname,complexity)
% 
%  Description
% 
%  B = uninit
%      Returns a 1-by-1 scalar uninitialized value.
%
%  B = uninit(n)
%      Returns an n-by-n matrix of uninitialized values. An error message
%      appears if n is not a scalar. 
%
%  B = uninit(m,n) or B = uninit([m n])
%      Returns an m-by-n matrix of uninitialized values. 
%
%  B = uninit(m,n,p,...) or B = uninit([m n p ...])
%      Returns an m-by-n-by-p-by-... array of uninitialized values. The
%      size inputs m, n, p, ... should be nonnegative integers. Negative
%      integers are treated as 0.
%
%  B = uninit(size(A)) 
%      Returns an array the same size as A consisting of all uninitialized
%      values.
%
%  If any of the numeric size inputs are empty, they are taken to be 0.
%
%  The optional classname argument can be used with any of the above.
%  classname is a string specifying the data type of the output.
%  classname can have the following values:
%          'double', 'single', 'int8', 'uint8', 'int16', 'uint16',
%          'int32', 'uint32', 'int64', 'uint64', 'logical', or 'char'.
%          (Note: 'logical' and 'char' are not allowed in the ZEROS function)
%  The default classname is 'double'.
%
%  The optional complexity argument can be used with any of the above.
%  complexity can be 'real' or 'complex', except that 'logical' and 'char'
%  outputs cannot be complex. (this option not allowed in the ZEROS function)
%  The default complexity is 'real'.
%
%  UNINIT is very similar to the ZEROS function, except that UNINIT returns
%  an uninitialized array instead of a zero-filled array. Thus, UNINIT is
%  faster than the ZEROS function for large size arrays. Since the return
%  variable is uninitialized, the user must take care to assign values to
%  the elements before using them. UNINIT is useful for preallocation of an
%  array where you know the elements will be assigned values before using them.
% 
%  Example
% 
%    x = uninit(2,3,'int8');
% 
%***************************************************************************/
 
function varargout = uninit(varargin)
fname = 'uninit';
disp(' ');
disp(['Detected that the mex routine for ' fname ' is not yet built.']);
disp('Attempting to do so now ...');
disp(' ');
try
    mname = mfilename('fullpath');
catch
    mname = fname;
end
cname = [mname '.c'];
if( isempty(dir(cname)) )
    disp(['Cannot find the file ' fname '.c in the same directory as the']);
    disp(['file ' fname '.m. Please ensure that they are in the same']);
    disp('directory and try again. The following file was not found:');
    disp(' ');
    disp(cname);
    disp(' ');
    error(['Unable to compile ' fname '.c']);
else
    disp(['Found file ' fname '.c in ' cname]);
    disp(' ');
    disp('Now attempting to compile ...');
    disp('(If prompted, please press the Enter key and then select any C/C++');
    disp('compiler that is available, such as lcc.)');
    disp(' ');
    disp(['mex(''' cname ''',''-output'',''',mname,''')']);
    disp(' ');
    try
        mex(cname,'-output',mname);
        disp([ fname ' mex build completed ... you may now use ' fname '.']);
        disp(' ');
    catch
        disp(' ');
        error(['Unable to compile ' fname ' ... Contact author.']);
    end
    [varargout{1:nargout}] = uninit(varargin{:});
end
end
