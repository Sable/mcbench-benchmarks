% swapbytes reverses byte ordering converting little-endian big-endian
%*************************************************************************************
% 
%  MATLAB (R) is a trademark of The Mathworks (R) Corporation
% 
%  Function:    swapbytes
%  Filename:    swapbytes.c
%  Programmer:  James Tursa
%  Version:     1.1
%  Date:        August 4, 2009
%  Copyright:   (c) 2009 by James Tursa, All Rights Reserved
%
%  This code uses the BSD License:
%
%  Redistribution and use in source and binary forms, with or without 
%  modification, are permitted provided that the following conditions are 
%  met:
%
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%      
%  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
%  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
%  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
%  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
%  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
%  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
%  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
%  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
%  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
%  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
%  POSSIBILITY OF SUCH DAMAGE.
% 
%  swapbytes is a mex function that mimics the MATLAB intrinsic function of
%  the same name. Mainly intended for those users with older version of MATLAB
%  that do not have this intrinsic function available. But there are extensions
%  listed below.
%
%  Building:
%
%  swapbytes requires that a mex routine be built (one time only). This
%  process is typically self-building the first time you call the function
%  as long as you have the files swapbytes.m and swapbytes.c in the same
%  directory somewhere on the MATLAB path. If you need to manually build
%  the mex function, here are the commands:
%
%  >> mex -setup
%    (then follow instructions to select a C / C++ compiler of your choice)
%  >> mex swapbytes.c
%
%  If you have an older version of MATLAB, you may need to use this command:
%
%  >> mex -DDEFINEMWSIZE swapbytes.c
% 
%  Calling sequence:  out1 = swapbytes(in1)
%                     [out1,out2] = swapbytes(in1,in2)
%                     etc. (any number of input/output pairs)
% 
%  Description (from the MATLAB documentation):
% 
%  Y = swapbytes(X) reverses the byte ordering of each element in array X,
%  converting little-endian values to big-endian (and vice versa).
% 
%  Example 1
% 
%  Reverse the byte order for a scalar 32-bit value, changing hexadecimal
%  12345678 to 78563412: 
% 
%  >> A = uint32(hex2dec('12345678'));
%  >> B = dec2hex(swapbytes(A))
%     B =
%       78563412
% 
%  Example 2
% 
%  Reverse the byte order for each element of a 1-by-4 matrix: 
% 
%  >> X = uint16([0 1 128 65535])
%     X =
%         0      1    128  65535
%  >> Y = swapbytes(X)
%     Y =
%         0    256  32768  65535
% 
%  Examining the output in hexadecimal notation shows the byte swapping: 
% 
%  >> format hex
%  >> X, Y
%     X =
%      0000   0001   0080   ffff
%     Y =
%      0000   0100   8000   ffff
% 
%  Example 3
% 
%  Create a three-dimensional array A of 16-bit integers and then swap the
%  bytes of each element: 
% 
%  >> format hex
%  >> A = uint16(magic(3) * 150);
%  >> A(:,:,2) = A * 40;
%  >> A
%     A(:,:,1) =
%      04b0   0096   0384
%      01c2   02ee   041a
%      0258   0546   012c
%     A(:,:,2) =
%      bb80   1770   8ca0
%      4650   7530   a410
%      5dc0   d2f0   2ee0
% 
%  >> swapbytes(A)
%     ans(:,:,1) =
%      b004   9600   8403
%      c201   ee02   1a04
%      5802   4605   2c01
%     ans(:,:,2) =
%      80bb   7017   a08c
%      5046   3075   10a4
%      c05d   f0d2   e02e
% 
%  Extensions of this mex function to the MATLAB intrinsic:
% 
%  For structures and cell arrays, each component or cell is individually
%  converted. Other classes (e.g., vpa, function handles, etc.) are not
%  converted; a deep copy is returned instead. swapbytes takes any number
%  of input arguments; there must be the same number of matching output
%  arguments. Also, swapbytes will convert the complex portion of variables
%  as well as the real portion. swapbytes also works with sparse matrices.
% 
%  For users with later versions of MATLAB, this mex file will clash with
%  the actual intrinsic of the same name. If you want to use this mex file
%  and still have access to the MATLAB intrinsic, simply rename this file
%  and the help file to something unique, like swapbytesx.c and swapbytesx.m
% 
% ***************************************************************************/

function varargout = swapbytes(varargin)
disp(' ');
disp('You must build the mex routine before you can use swapbytes.');
disp('Attempting to do so now ...');
disp(' ');
mname = mfilename('fullpath');
cname = [mname '.c'];
if( isempty(dir(cname)) )
    disp('Cannot find the file swapbytes.c in the same directory as the');
    disp('file swapbytes.m. Please ensure that they are in the same');
    disp('directory and try again. The following file was not found:');
    disp(' ');
    disp(cname);
    disp(' ');
    error('Unable to compile swapbytes.c');
else
    disp(['Found file swapbytes.c in ' cname]);
    disp(' ');
    disp('Now attempting to compile ...');
    disp('(If prompted, please press the Enter key and then select any C/C++');
    disp('compiler that is available, such as lcc. Note: Older versons of)');
    disp('MATLAB may get lots of errors at this step ... ignore for now.)');
    disp(' ');
    disp(['mex(''' cname ''')']);
    disp(' ');
    try
        mex(cname);
        disp('mex swapbytes.c build completed ... you may now use swapbytes.');
        disp(' ');
    catch
        disp(' ');
        disp('Well, *that* didn''t work ... now trying it with mwSize defined ...');
        disp(' ');
        try
            disp(' ');
            disp(['mex(''-DDEFINEMWSIZE'',''' cname ''')']);
            disp(' ');
            mex('-DDEFINEMWSIZE',cname);
            disp('mex swapbytes.c build completed ... you may now use swapbytes.');
            disp(' ');
        catch
            disp('Hmmm ... That didn''t work either.');
            disp(' ');
            disp('The mex command failed. This may be because you have already run');
            disp('mex -setup and selected a non-C compiler, such as Fortran. If this');
            disp('is the case, then rerun mex -setup and select a C/C++ compiler.');
            disp(' ');
            error('Unable to compile swapbytes.c');
        end
    end
    [varargout{1:nargout}] = swapbytes(varargin{:});
end
end
