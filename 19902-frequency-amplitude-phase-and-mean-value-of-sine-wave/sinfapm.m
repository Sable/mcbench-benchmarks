function [frq,amp,phi,ave] = sinfapm(x,fs,varargin)
%   Amplitude, frequency, phase and mean value of sampled sine wave
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The function sinfap.m evaluates frequency, amplitude, phase and mean
% value of a uniformly sampled harmonic signal 
%   x(t) = a.sin(2.pi.f.t + phi) + x_m
% It uses a vector version of 3-point formulae derived by application of 
% Z-transform (see [1]) for finding amplitude and frequency of a signal.
% If more than two output parameters are to be determined, all of them are
% optimized in the least squares sense by the function LMFnlsq.
%
% Calls:
%   frq = sinfapm(x,fs);            %   Get only frequaency of sine-wave
%   [frq,amp] = sinfapm(x,fs);      %   Get frequency and amplitude
%   [frq,amp,phi] = sinfapm(x,fs);  %   Get frequency, amplitude and phase
%   [frq,amp,phi,ave] = sinfapm(x,fs);% ditto plus mean value
% The set of more than two output parameters can be found by calling
%   [frq,amp,phi] = sinfapm(x,fs,Name_1,Val_1,Name_2,Val_2, ...);
%   [frq,amp,phi,ave] = sinfapm(x,fs,Name_1,Val_1,Name_2,Val_2, ...);
%
% Input arguments:
%   x       vector of samples
%   fs      sampling frequency [Hz]
%   Name_i  name of the i-th optional parameter for optimization
%   Val_i   value of the i-th optional parameter (see function LMFnlsq)
% Output arguments:
%   frq     frequency of x [Hz]
%   amp     amplitude of x
%   phi     phase in radians
% Examples:
%   [f,a,phi,ave] = sinfapm([1.3633;-.2428;-0.9705;1.8130;-1.9631],10);
%       f   = 4.0000
%       a   = 2.0000
%       phi = 0.7500
%       ave = -2.2806e-005
%   [f,a,phi] = sinfapm([.707,1,.707,0],20,'Xtol',1e-4);
%       f   = 2.5001
%       a   = 0.9999
%       phi = 0.7853    %   pi/4 = 0.785398...
% Requirement:
%   The function LMFnlsq for optimization of output parameters is at
% www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=17534
%
% Reference:
% [1]  Balda M.: An estimation of the residual life of blades. Proc. Colloq.
%   DYNAMICS OF MACHINES '99, Inst. of Thermomechanics ASCR, Prague, Feb.
%   9-10, 1999, pp. 11-18, ISBN 80-85918-48-X
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   Miroslav Balda
%   balda at cdm dot cas dot cz
%   1998-10-26 - v 1.0
%   2008-05-05 - v 1.1,  complemented evaluation of phase and mean value

if nargin<2, error('Number of input arguments should be >= 2'), end
N   = length(x);                %   Length of time series of x
n   = 2:N-1;
x   = x(:);                     %   Make x a column vector
ave = mean(x);
xs  = x(n-1)+x(n+1);
C   = xs'*x(n)/(x(n)'*x(n))/2;
frq = acos(C)*fs*.5/pi;         %   frequency
if nargout>1                    %   amplitude:
    amp = sqrt((x(n)'*x(n)-2*x(n)'*x(n+1)*C + x(n+1)'*x(n+1))/(1-C^2)/(N-2));
    if nargout>2
        phi = asin(x(1)/amp);   %   Phase approximation
        ip  = [phi,amp,frq];    %   initial estimates for 3 parameters
        if nargout>3
            ip = [ip,ave];      %   initial estimates for 4 parameters
        end
        t   = (0:length(x)-1)'/fs;
        options = LMFnlsq('default');
        if nargin>2
            for k = 1:2:length(varargin)
                options = LMFnlsq(options,varargin{k},varargin{k+1});
            end
        end
        fap = LMFnlsq(@faphi,ip,options); % Optimize parameters
        frq = fap(3);
        amp = fap(2);
        phi = fap(1);
        if nargout>3, ave = fap(4); end
    end
end

function r = faphi(p)
%%%%%%%%%%%%%%%%%%%%%   Residuals of regression
r = p(2)*sin(2*pi*p(3)*t + p(1)) - x;
if length(p)>3, r = r+p(4); end
end

end
