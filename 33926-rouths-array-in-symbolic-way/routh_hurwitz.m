function [M L] = routh_hurwitz(P,N)
% [M L] = routh_hurwitz(P,N)
% This function gives the Routh's array from a numerical or symbolic polynomial and
% includes two special cases: (1) the first element of the row is zero; (b) a row of zeros.
%
% P       Numerical or symbolic array of coeficients. In the case of symbolic variables it is
%          necesarry to define them as: >> syms a b c ...
% N      Digits to be considered zero a number. E.g, for N=5, 10^(-5) is considered a zero. 
%          By default, N=10
% M     Routh's array without any simplification (e.g., with epsilon notation)
% L       Simplified first column of Routh's array with simplification (e.g., using the limit 
%          when epsilon tends to zero) that determines the number of roots in the right-half of 
%          the s-plane: the number of changes of signs.
%
% Examples:
% 1. [M, L]=routh_hurwitz([1 0 2 3 4])
% 2. syms a b c d K;  [M, L]=routh_hurwitz([1 b c d+a*K])
% 3. syms k; [M, L]=routh_hurwitz([1 k 1 1])
% 4. [M, L]=routh_hurwitz([1 -3 -15 -9 -58 12 72])
% 5. syms a; [M, L]=routh_hurwitz([1 0 2 3 a])
%
% Developed by Carlos M. Vélez S., cmvelez@eafit.edu.co
% http://sistemascontrol.wordpress.com/
% EAFIT University, http://www.eafit.edu.co
% Medellín, Antioquia, Colombia
% November 24th 2011

if nargin <2
    N=10;
end
n=length(P);
while P(n) == 0
    P=P(1:n-1);
    n=length(P);
end
P=sym(P);
syms epsilon

nfil = length(P); ncol = ceil(n/2);
M=sym(zeros(nfil,ncol));
if n/2 ~= floor(n/2)
    P=[P 0];
end
k=1;
for j=1:ncol
    for i=1:2
        M(i,j)=P(k);
        k=k+1;
    end
end

for i=3:nfil
    if isempty(symvar(M(i-1,1))) == 1 % There is a special case only if the first element is not a variable
        if isempty(symvar(M(i-1,:))) == 1 % Special cases when all values are numbers
            if abs(double(M(i-1,1))) < 10^(-N) && sum(abs(double(M(i-1,2:ncol)))) > 10^(-N) % Special case when the first element of the row iz zero
                M(i-1,1)=epsilon;
            elseif sum(abs(double(M(i-1,1:ncol)))) < 10^(-N) % Special case of a row of zeros
                disp(['Row of zeros: ' num2str(i-1) '. Order of auxiliar polynomial: ' num2str(n-i+2) ]);
                for j=1:ncol
                    M(i-1,j)=M(i-2,j)*( n-(i-2)-2*(j-1) );
                end
            end
        elseif double(M(i-1,1)) < 10^(-N) % Special case when the first element of the row iz zero and some other elements are variables
            M(i-1,1)=epsilon;
        end
    end
    for j=1:ncol-1
        M(i,j)=det([M(i-2,1) M(i-2,j+1);M(i-1,1) M(i-1,j+1)])/(-M(i-1,1));
    end
end
M=vpa(M);
M1=subs(M,epsilon,0); 
for i=1:n
    L(i,1)=M1(i,1);
end
