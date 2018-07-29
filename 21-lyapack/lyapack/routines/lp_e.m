function s = lp_e(i1,i2,i3,i4,i5,i6,i7,i8,i9,i10,i11,i12,i13,i14,i15,i16,...
             i17,i18,i19,i20)
%
%  Auxiliary routine for the execution of strings with MATLAB 
%  expressions, which depend on numerical values.
%
%  Input:
%
%    i1,...,i20 strings or numerical values.    
%
%  Output:
%
%    s          string.
%
%
%  LYAPACK 1.0 (Thilo Penzl, November 1999)

ni = nargin;

if ni>=1, if ischar(i1), s = i1; else, s = num2str(i1); end, end 
if ni>=2, if ischar(i2), s = [s,i2]; else, s = [s,num2str(i2)]; end, end 
if ni>=3, if ischar(i3), s = [s,i3]; else, s = [s,num2str(i3)]; end, end 
if ni>=4, if ischar(i4), s = [s,i4]; else, s = [s,num2str(i4)]; end, end 
if ni>=5, if ischar(i5), s = [s,i5]; else, s = [s,num2str(i5)]; end, end 
if ni>=6, if ischar(i6), s = [s,i6]; else, s = [s,num2str(i6)]; end, end 
if ni>=7, if ischar(i7), s = [s,i7]; else, s = [s,num2str(i7)]; end, end 
if ni>=8, if ischar(i8), s = [s,i8]; else, s = [s,num2str(i8)]; end, end 
if ni>=9, if ischar(i9), s = [s,i9]; else, s = [s,num2str(i9)]; end, end 
if ni>=10, if ischar(i10), s = [s,i10]; else, s = [s,num2str(i10)]; end, end 
if ni>=11, if ischar(i11), s = [s,i11]; else, s = [s,num2str(i11)]; end, end 
if ni>=12, if ischar(i12), s = [s,i12]; else, s = [s,num2str(i12)]; end, end 
if ni>=13, if ischar(i13), s = [s,i13]; else, s = [s,num2str(i13)]; end, end 
if ni>=14, if ischar(i14), s = [s,i14]; else, s = [s,num2str(i14)]; end, end 
if ni>=15, if ischar(i15), s = [s,i15]; else, s = [s,num2str(i15)]; end, end 
if ni>=16, if ischar(i16), s = [s,i16]; else, s = [s,num2str(i16)]; end, end 
if ni>=17, if ischar(i17), s = [s,i17]; else, s = [s,num2str(i17)]; end, end 
if ni>=18, if ischar(i18), s = [s,i18]; else, s = [s,num2str(i18)]; end, end 
if ni>=19, if ischar(i19), s = [s,i19]; else, s = [s,num2str(i19)]; end, end 
if ni>=20, if ischar(i20), s = [s,i20]; else, s = [s,num2str(i20)]; end, end 
if ni>=21, error('Too many input arguments.'); end


