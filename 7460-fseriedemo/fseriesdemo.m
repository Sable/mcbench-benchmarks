function [] = fseriesdemo(f,b,NN)
% FSERIESDEMO Plots a function f and it's Fourier series approximation.
% FSERIESDEMO(f,b,N) plots the function f and it's N term Fourier series
% approximation from zero to b.  FSERIESDEMO uses the FFT to approximate 
% the Trigonometric Fourier Series coefficients.  FSERIESDEMO only works
% for the function from 0 to b.  Input N must be an integer >=2.
% Example:     
%        
%           f = @(x) sin(x)./x+(cos(x)).^2-exp(x/8)+x.^(x/20);
%           fseriesdemo(f,20,100)  % Approx. f on (0,20) with 100 terms.
%
%
% Author:  Matt Fig
% Contact:  popkenai@yahoo.com

% First some argument checking.
if nargin<3
   error ('Not enough arguments. See help.')
end

if ~isreal(NN) || ~isreal(b) || b<=0 || NN < 2 || floor(NN)~=NN
    error ('2nd and 3rd args must be positive real scalars. See help.')
end
     
n = 2*NN;  
T = b-eps+(b-eps)/(n-2); % Get the appropriate endpoint for fft.
x = linspace(eps,T,n+1); % Use this x in fft.  
x(end) = [];   % But not the endpoint.
fun = f(x);  % Get discrete points.
FUNC = fft(fun);  % Call fft 
FUNC = [conj(FUNC(NN+1)) FUNC(NN+2:end) FUNC(1:NN+1)]/n; % Shift/scale.
A0 = FUNC(NN+1);   % First cosine term.
AN = 2*real(FUNC(NN+2:end));  % General cosine term.
BN = -2*imag(FUNC(NN+2:end));  % General sine term.

p = app1(x,A0,AN,BN,T);
% Now on to the plotting.
xx = linspace(eps,x(end),b*100);   
xx(end) = [];   
fun = f(xx); 
hand = plot(xx,fun,'r',x,p,'b');   
set(hand,'linewidth',2)
grid on;   
axis tight;   
legend('User Function',[num2str(NN),' Term Approximation'],0) 


function answ = app1(x,A0,AN,BN,T)
ii = 1:length(AN);   % The indeces.
lgh = length(x);
[ii x] = meshgrid(ii,x); % Arrays for angles.
AN = repmat(AN,lgh,1);   % Create arrays for approximation.
BN = repmat(BN,lgh,1);
theta = ii.*x.*(2*pi)/T; % The angles.
answ = (sum(AN.*cos(theta)+BN.*sin(theta),2)+A0)'; % the F approximation.