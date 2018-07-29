% This is material illustrating the methods from the book
% Financial Modelling  - Theory, Implementation and Practice with Matlab
% source
% Wiley Finance Series
% ISBN 978-0-470-74489-5
%
% Date: 02.05.2012
%
% Authors:  Joerg Kienitz
%           Daniel Wetterau
%
% Please send comments, suggestions, bugs, code etc. to
% kienitzwetterau_FinModelling@gmx.de
%
% (C) Joerg Kienitz, Daniel Wetterau
% 
% Since this piece of code is distributed via the mathworks file-exchange
% it is covered by the BSD license 
%
% This code is being provided solely for information and general 
% illustrative purposes. The authors will not be responsible for the 
% consequences of reliance upon using the code or for numbers produced 
% from using the code.

function call_price_fft = CallPricingFFT(model,n,S,K,T,r,d,varargin)

lnS = log(S);
lnK = log(K);

%optAlpha = optimalAlpha(model,lnS,lnK,T,r,d,varargin{:});
optAlpha = .75;

DiscountFactor = exp(-r*T);


%-------------------------
%--- FFT Option Pricing --
%-------------------------
% from: Option Valuation Using the Fast Fourier Transform, 
%       Peter Carr, March 1999, pp 10-11
%-------------------------

% predefined parameters
FFT_N = 2^n;                               % must be a power of two (2^14)
FFT_eta = 0.05;                             % spacing of psi integrand

% effective upper limit for integration (18)
% uplim = FFT_N * FFT_eta;

FFT_lambda = (2 * pi) / (FFT_N * FFT_eta);  %spacing for log strike output (23)
FFT_b = (FFT_N * FFT_lambda) / 2;           % (20)

uvec = 1:FFT_N;
%log strike levels ranging from lnS-b to lnS+b
ku = - FFT_b + FFT_lambda * (uvec - 1);     %(19)

jvec = 1:FFT_N;
vj = (jvec-1) * FFT_eta;


% optimal alpha illustration (payoff independent) 
% alpharange = -3:0.1:8;
% resultrangef = zeros(1,length(alpharange));
% resultrangef1 = zeros(1,length(alpharange));
% eps = 0.000001;
% for n = 1:length(alpharange)
%     resultrangef(n)= (-alpharange(n) * log(K) + log(psialpha(model,alpharange(n),lnS,T,r,d,varargin{:})));
%     resultrangef1(n)= (-(alpharange(n) + eps) * log(K) ...
%                         + log(psialpha(model,alpharange(n)+eps,lnS,T,r,d,varargin{:})));
%     resultrangef1(n)= (resultrangef1(n) - resultrangef(n)) / eps;
% end
% plot(alpharange,resultrangef); hold on; plot(alpharange,resultrangef1, 'g'); hold off;

%applying FFT
tmp = DiscountFactor * psi(model,vj,optAlpha,lnS,T,r,d,varargin{:}) .* exp(1i * vj * (FFT_b)) * FFT_eta;
tmp = (tmp / 3) .* (3 + (-1).^jvec - ((jvec - 1) == 0) );   %applying simpson's rule
cpvec = real(exp(-optAlpha .* ku) .* fft(tmp) / pi);        %call price vector resulting in equation 24

indexOfStrike = floor((lnK + FFT_b)/FFT_lambda + 1); 
iset = max(indexOfStrike)+1:-1:min(indexOfStrike)-1;
xp = ku(iset);
yp = cpvec(iset);
call_price_fft = real(interp1(xp,yp,lnK));

end

%analytical formula for zhi in equation ( 6 ) of Madan's paper
function ret = psi(model,v,alpha,varargin)
  ret = exp(feval(@CharacteristicFunctionLib, model, v - (alpha + 1) * 1i,varargin{:})) ./ (alpha.^2 + alpha - v.^2 + 1i * (2 * alpha + 1) .* v);
end

% function ret = psialpha(model,alpha,varargin)
%   ret = exp(feval(@CharacteristicFunctionLib, model, - (alpha + 1) * 1i,varargin{:}))./ (alpha.^2 + alpha);
% end