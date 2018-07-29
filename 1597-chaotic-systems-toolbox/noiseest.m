function [sigma,dkm,g,r]=noiseest(dlogCr,dlogr,method)
%Syntax: [sigma,dkm,g,r]=noiseest(dlogCr,dlogr,method)
%_____________________________________________________
%
% Calculates the noise standard deviation from the derivative of the 
% Correlation Integral. Requires the auxilary function "dkmminusg".
%
% sigma is the noise standard deviation.
% dkm is the empirical effect of noise on the Correlation Integral.
% g is the theoritical effect of noise on the Correlation Integral.
% r is the range.
% dlogCr is the derivative of the logCr.
% dlogr is the log(range).
% method can take one of the folloing values:
%  'full' for Schreiber's full minimization
%  'mod' for Leontitsis et al. modified minimization
%
%
% References:
%
% Schreiber T (1993): Determination of the noise level of chaotic time
% series. Physical Review E 48(1): R13-R16
%
% Leontitsis A, Pange J., Bountis T. (2003): Large noise level estimation.
% International Journal of Bifurcation and Chaos 13(8): 2309-2313
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
% June 15, 2001.

% dlogCr and dlogr must have the same number of rows
if size(dlogCr,1)~=size(dlogr,1)
   error('dlogCr and dlogr must have the same number of rows.');
end

r=10.^dlogr;
options=optimset('Display','off');
for i=2:size(dlogCr,2)
   dkm(:,i-1)=(dlogCr(:,i)-dlogCr(:,1))/(i-1);
   sigma(i-1)=fminbnd(@dkmminusg,r(1),r(end),options,dkm(:,i-1),r,method);
end
z=r./2./sigma(1);
g=2.*z.*exp(-z.^2)./sqrt(pi)./erf(z);


function error=dkmminusg(s,dkm,r,method)
%Syntax: error=dkmminusg(s,dkm,r,method)
%_______________________________________
%
% Auxilary function for "noiseest". Calculates the  error between the dkm
% and function "g" given a noise standard deviation (s) and a vector of 
% range values (r).
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
% June 15, 2001.

% Calculate the auxilary variable z
z=r./2./s;

% Calpculate the g fumction
g=2*z.*exp(-z.^2)/sqrt(pi)./erf(z);

switch method
    case 'full'
        % The ordinary (low noise) calculation
        error=norm(dkm-g);    
    case 'mod'
        % The modified (large noise) estimation
        if any(dkm<g)==1
            i=find(dkm<g);
            error=sum(abs(dkm(i)-g(i)));
        else
            error=norm(dkm-g,-inf);
        end
   otherwise
       error('You should provide another value for method.');
end
        

