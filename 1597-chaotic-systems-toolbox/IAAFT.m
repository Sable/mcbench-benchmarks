function [s,iter]=IAAFT(x,c,maxiter)
%Syntax: [s,iter]=IAAFT(x,c,maxiter)
%___________________________________
%
% Makes c Iterative Amplitude Adjusted Fourier Transformed (AAFT) surrogates
% of a time series x.
%
% s is the IAAFT surrogate time series.
% iter is the number of iterations needed of the i-th surrogate series.
% x is the original time series.
% c is the number of surrogates.
% maxiter is the maximum number of iterations allowed.
%
%
% References:
%
% Schreiber T, Schmitz A (1996): Improved surrogate data for nonlinearity
% tests. Physical Review Letters 77: 635-638
%
% I am grateful to Dr D. Kugiumtzis for providing me a version of his Matlab
% function concerning this algorithm.
%
% 
% Alexandros Leontitsis
% Department of Education
% University of Ioannina
% 45110 - Dourouti
% Ioannina
% Greece
%
% University e-mail: me00743@cc.uoi.gr
% Lifetime e-mail: leoaleq@yahoo.com
% Homepage: http://www.geocities.com/CapeCanaveral/Lab/1421
%
% 20 November 2001.

if nargin<1 | isempty(x)==1
   error('You should provide a time series.');
else
   % x must be a vector
   if min(size(x))>1
      error('Invalid time series.');
   end
   x=x(:);
end

if nargin<2 | isempty(c)==1
   c=1;
else
   % c must be scalar
   if sum(size(c))>2
      error('c must be scalar.');
   end
   % c must be greater or equal than 1
   if c<1
      error('c must be greater or equal than 1.');
   end
end

if nargin<3 | isempty(maxiter)==1
   maxiter=1000;
else
   % maxiter must be scalar
   if sum(size(maxiter))>2
      error('maxiter must be scalar.');
   end
   % maxiter must be greater or equal than 1
   if maxiter<1
      error('maxiter must be greater or equal than 1.');
   end
end

% The magnitudes of x
amp=abs(fft(x));

% Shuffle x
s=shuffle(x,c);

% Sort x
[x,r]=sort(x);


for j=1:c
    
    % Calculate the phases of the shuffled series
    phase=angle(fft(s(:,j)));
    
    % Initialize the loop
    k=1;
    indold=r;
    converge = 0;
    while k<=maxiter & converge == 0 
        % Make phase-randomized surrogates ...
        s(:,j)=amp.*exp(phase.*i); 
        s(:,j)=real(ifft(s(:,j)));
        % ... and give them the distribution of x
        [s(:,j),T]=sort(s(:,j));
        [s(:,j),indnew]=sort(T);
        s(:,j)=x(indnew);
        % Check the convergence
        if indnew==indold
            converge=1;
        else
            indold=indnew;
            k=k+1;
        end
        % Loop again if needed, calculating the phases once more
        phase=angle(fft(s(:,j)));
    end
    
    % Get the iterations of each surrogate series
    iter(j)=k;
    
end
