function Anew = h_trid(A)
%  H_TRID(A) uses Householder method to form a tridiagonal matrix from A.
%  Must have a SQUARE SYMMETRIC matrix as the input.
%
%
%  Example:   
%
%             B=[0 1 1;1 2 1;1 1 1];   
%             h_trid(B)
%             
%
% Author:  Matt Fig
% Contact: popkenai@yahoo.com

[M N] = size(A);
if M~=N || ~isequal(A,A')  %This just screens matricies that can't work.
   error('Matrix must be square symmetric only, see help.');
end


lngth = length(A);  % Preallocations. 
v = zeros(lngth,1);  
I = eye(lngth);  
Aold = A;  

for jj=1:lngth-2  % Build each vector j and run the whole procedure.
    v(1:jj) = 0;
    S = ss(Aold,jj);
    v(jj+1) = sqrt(.5*(1+abs(Aold(jj+1,jj))/(S+2*eps)));
    v(jj+2:lngth) = Aold(jj+2:lngth,jj)*sign(Aold(jj+1,jj))...
                   /(2*v(jj+1)*S+2*eps);
    P = I-2*v*v';
    Anew = P*Aold*P;
    Aold = Anew;
end

Anew(abs(Anew(:))<5e-14)=0; % Tolerence.


function anss = ss(A,jj)
% Subfunction for h_trid.
anss = sqrt(sum(A(jj+1:end,jj).^2));
