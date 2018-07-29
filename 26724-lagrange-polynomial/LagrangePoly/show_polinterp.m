function F = show_polinterp(x,y)
% Polynomial Interpolation Problem: Lagrange Form
% x and y are vectors with the same dimensions
% Given n points: (x_k,y_k) k = 1,2,...n
% this function finds a polynomial P(x) of degree less
% than n such that P(x_k) = y_k 
% ----------------------------------------------------------
% Remarks:
% The resulting polynomial is displayed in symbolic notation
% ----------------------------------------------------------
% Example
% x=[0 1 2 3 4 5 6 7];
% y=[4 -6 -1 16 -2 6 12 17];
% pol=show_polinterp(x,y);
% --
% x=[1 2 3 4 5 6 7];
% y=1+x.^3-x.^6;
% pol=show_polinterp(x,y);
%
% For evaluating pol, try 
% subs(pol,x), it will return vector y
%-----------------------------------------------------------
% University of Essex. Ernesto Momox Beristain

L = length(x);
if length(x)~=length(y)
    F = ' Error: x and y vectors must have same dimensions';
elseif length(x)>10
    F = ' Error: number of elements <= 10';
else
for k = 1:L
    P(k) = coefficient(x,y,k); %#ok<AGROW>
end
F = simple(sum(P)); 
fprintf('\n')
disp('Polynomial Interpolation Problem: Lagrange From')
disp('-----------------------------------------------')

plot(x,y,'ro','MarkerSize',10,'LineWidth',1.5), grid, hold on
plot(x,subs(F,x),'LineWidth',1)
xlabel('Vector x'), ylabel('Vector y'), title('Polynomial Interpolation Problem: Lagrange Form')
end
disp(F)