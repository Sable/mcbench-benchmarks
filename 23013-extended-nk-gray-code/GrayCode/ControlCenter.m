% ControlCenter
% This algorithm is based on one paper : 
% Guan, Dah-Jyu. "Generalized Gray Codes with Applications". Proc.
%Natl. Sci. Counc. Repub. Of China .1998;(A) 22: 841-848

%Description:
% Range is to save the digits state for each variable. For example we need
% to produce a gray code space where there are 4 variables ranged in 2, 4
% ,2, 4 states. Then, we could do as : 

Range = [ 2 4 2 4];
[GrayCode,GrayCodeLength] = ImprovedGenerateGrayCode( Range )


% advance users can use my mex programming function, for fast generation.
% Example, I have tested it under linux.
mex GenerateGrayCode.c
Range = [ 2 4 2 4];
[GrayCode,GrayCodeLength] = ImprovedGenerateGrayCode( Range )
