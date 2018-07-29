function A = mycol2im(v,par1, par2)
% FUNCTION K = mycol2im(v,par1,par2)
%   AUTHOR:    Makoto Yamada
%              (myamada@ism.ac.jp)
%   DATE:       02/16/08
% 
%  DESCRIPTION:
% 
%   This function is for converting 1D signal to 2D signal. 
%   

count = 1; 
A =zeros(par2(1), par2(2));

for ii = 1:par2(1)
    for jj = 1:par2(2)
        A(jj,ii) = v(count);
        count = count + 1;
    end
end