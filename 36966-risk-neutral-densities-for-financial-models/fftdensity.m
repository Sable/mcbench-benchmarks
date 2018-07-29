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


function y = fftdensity(cf,a,N)
% simply calculates the density form a given characteristic function
% cf : the characteristic function as a function handle
% a  : The length of the interval
% N  : The number of gird points using transforms
b = a/N;                                    
u = ( (0:N-1) - N/2 ) * b;                      % create the grid
h2 = ((-1).^(0:N-1)) .* cf(u);                  % discrete points due to cf
g = fft(h2);                                    % calc inverse cf = pdist
y = real( ((-1).^(0:N-1)) .* g * b / (2*pi) );  % transform to values

end