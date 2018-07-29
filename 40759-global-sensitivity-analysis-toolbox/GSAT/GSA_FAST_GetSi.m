%% GSA_FAST_GetSi: calculate the FAST sensitivity indices
% Ref: Cukier, R.I., C.M. Fortuin, K.E. Shuler, A.G. Petschek and J.H.
% Schaibly (1973). Study of the sensitivity of coupled reaction systems to uncertainties in rate coefficients. I Theory. Journal of Chemical Physics 
%
% Max number of input variables: 50
%
% Usage:
%   Si = GSA_FAST_GetSi(pro)
%
% Inputs:
%    pro                project structure
%
% Output:
%    Si                 vecotr of sensitivity coefficients
%
% ------------------------------------------------------------------------
% See also
%
% Author : Flavio Cannavo'
% e-mail: flavio(dot)cannavo(at)gmail(dot)com
% Release: 1.0
% Date   : 01-05-2011
%
% History:
% 1.0  01-05-2011  First release.
%%


function Si = GSA_FAST_GetSi(pro)


k = length(pro.Inputs.pdfs);

M = 4;

W = fnc_FAST_getFreqs(k);

Wmax = W(k);
N = 2*M*Wmax+1;
q = (N-1)/2;


S = pi/2*(2*(1:N)-N-1)/N;
alpha = W'*S;

NormedX = 0.5 + asin(sin(alpha'))/pi;

X = fnc_FAST_getInputs(pro, NormedX);

Y = nan(N,1);

for j=1:N
    Y(j) = pro.Model.handle(X(j,:));
end

A = zeros(N,1);
B = zeros(N,1);
N0 = q+1;

for j=2:2:N
    A(j) = 1/N*(Y(N0)+(Y(N0+(1:q))+Y(N0-(1:q)))'* ...
        cos(pi*j*(1:q)/N)');
end

for j=1:2:N
    B(j) = 1/N*(Y(N0+(1:q))-Y(N0-(1:q)))'* ...
        sin(pi*j*(1:q)/N)';
end

V = 2*(A'*A+B'*B);


for i=1:k
    Vi=0;
    for j=1:M
        Vi = Vi+A(j*W(i))^2+B(j*W(i))^2;
    end
    Vi = 2*Vi;
    Si(i) = Vi/V;
end