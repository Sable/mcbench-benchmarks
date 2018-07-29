% num2str str2num. num2strexact does an exact number to string conversion
%*************************************************************************************
% 
%  MATLAB (R) is a trademark of The Mathworks (R) Corporation
% 
%  Function:    num2strexact
%  Filename:    num2strexact.c
%  Programmer:  James Tursa
%  Version:     1.1
%  Date:        August 5, 2009
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
%  Building:
%
%  num2strexact requires that a mex routine be built (one time only). This
%  process is typically self-building the first time you call the function
%  as long as you have the files num2strexact.m and num2strexact.c in the
%  same directory somewhere on the MATLAB path. If you need to manually
%  build the mex function, here are the commands:
%
%  >> mex -setup
%    (then follow instructions to select a C / C++ compiler of your choice)
%  >> mex num2strexact.c
%
%  If you have an older version of MATLAB, you may need to use this command:
%
%  >> mex -DDEFINEMWSIZE num2strexact.c
% 
%  num2strexact is a mex function that converts a double or single input to
%  the exact decimal string. The conversion is done with hundreds of digits
%  of precision to maintain the exact conversion. The conversion uses the
%  exact decimal value of each bit of the IEEE double precision floating
%  point format along with the exact application of 2^exponent. Inf and NaN
%  bit patterns are recognized, and denormalized numbers are handled also.
% 
%  Don't confuse the exact conversion with significance! Double numbers will
%  only be significant to about 15 decimal digits, and single numbers will
%  only be significant to about 7 decimal digits. For example,
% 
%  >> format hex
%  >> 1.2
%  ans =
%      3ff3333333333333
%  >> num2strexact(1.2)
%  ans =
%      1.1999999999999999555910790149937383830547332763671875
% 
%  >> 1.2 + eps(1.2)
%  ans =
%      3ff3333333333334   <-- one bit different from 1.2
%  num2strexact(1.2 + eps(1.2))
%  ans =
%      1.20000000000000017763568394002504646778106689453125
% 
%  >> num2strexact(eps(1.2))
%  ans =
%      2.220446049250313080847263336181640625e-16
% 
%  You can see that 1.2 is not represented exactly in IEEE double format.
%  The difference shows up in the 18th digit for this example. Then note
%  that the very next number in the IEEE double format model is about 2e-16
%  bigger. The exact conversions are shown for each number, but they are
%  not significant beyond the 16th digit shown. There are no numbers in
%  between these two numbers that can be represented in IEEE double format.
% 
%  Syntax:
% 
%    Y = num2strexact(X)
%    [Y1 Y2] = num2strexact(X1,X2)
%    [Y1 Y2 Y3] = num2strexact(X1,X2,X3)
%        :           :
%       etc         etc
% 
%  The number of inputs must match the number of outputs, except in the
%  special case of 1 input and 0 outputs where the result will simply be
%  put into ans. If the input is a scalar, the output will be a char string.
%  If the input is any other size array, the result will be a cell array of
%  the same dimensions as the input, with each cell containing the char
%  string conversion of the corresponding element. The input must be double
%  or single.
% 
%****************************************************************************/

function varargout = num2strexact(varargin)
disp(' ');
disp('You must build the mex routine before you can use num2strexact.');
disp('Attempting to do so now ...');
disp(' ');
mname = mfilename('fullpath');
cname = [mname '.c'];
if( isempty(dir(cname)) )
    disp('Cannot find the file num2strexact.c in the same directory as the');
    disp('file num2strexact.m. Please ensure that they are in the same');
    disp('directory and try again. The following file was not found:');
    disp(' ');
    disp(cname);
    disp(' ');
    error('Unable to compile num2strexact.c');
else
    disp(['Found file num2strexact.c in ' cname]);
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
        disp('mex num2strexact.c build completed ... you may now use num2strexact.');
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
            disp('mex num2strexact.c build completed ... you may now use num2strexact.');
            disp(' ');
        catch
            disp('Hmmm ... That didn''t work either.');
            disp(' ');
            disp('The mex command failed. This may be because you have already run');
            disp('mex -setup and selected a non-C compiler, such as Fortran. If this');
            disp('is the case, then rerun mex -setup and select a C/C++ compiler.');
            disp(' ');
            error('Unable to compile num2strexact.c');
        end
    end
    [varargout{1:nargout}] = num2strexact(varargin{:});
end
end
