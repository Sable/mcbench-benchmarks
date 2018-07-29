function e = sweep(f1,f2,fs,duration,opt_meth)

%--------------------------------------------------------------------------
%
%       e = sweep(f1,f2,fs,duration,opt_meth)
% 
% Computation of an exponential sine-sweep with a length chosen in order to
% satisfy the fundamental phase property [1].
%
% input arguments:  - f1,f2: frequency bounds
%                   - fs : sampling frequency
%                   - duration : length of the sweep (in second). this
%                   length will be adjusted according to the chosen method.
%                   - opt_meth : method chosen for the computation. 'Reb'
%                       for [1] or 'Nov' for [2].
%
% output arguments: - e : sweep
%
% References:
%
% [1] M. Rébillat, R. Hennequin, E. Corteel, B.F.G. Katz, "Identification
% of cascade of Hammerstein models for the description of non-linearities 
% in vibrating devices", Journal of Sound and Vibration, Volume 330, Issue 
% 5, Pages 1018-1038, February 2011. 
%
% [2] A. Novak, L. Simon, F. Kadlec, P. Lotton, "Nonlinear system 
% identification using exponential swept-sine signal", IEEE Transactions on
% Instrumentation and Measurement, Volume 59, Issue 8, Pages 2220-2229,
% August 2010.
%
% Marc Rébillat & Romain Hennequin - 02/2011
% marc.rebillat@limsi.fr / romain.hennequin@telecom-paristech.fr
%
%xxx% Modified by Antonin Novak - 01/2012
% ant.novak@gmail.com, http://ant-novak.com
%
%--------------------------------------------------------------------------

if nargin<5
    display('    => ERROR : You have to specify a method option')
    display('    => Select ''Reb'' or ''Nov''')
    return
end

if strcmp(opt_meth,'Reb')
    display('    => Sweep generated using ''Reb'' option')
    
    w1 = f1/fs*2*pi;
    w2 = f2/fs*2*pi;
    Tmin = duration*fs ;
    
    % Choice of m (in order that the phase property is valid)
    m = ceil((Tmin/(log(w2/w1)/w1)+pi/2)/(2*pi));

    % Actual length in samples
    T = (2*m*pi - pi/2)*log(w2/w1)/w1 ;

    % Time
    t = 0:T;

    % Computation of the phase
    Phi = w1*T/log(w1/w2)*(exp(t/T*log(w2/w1))-1)-pi/2;

    % Computation of the sweep
    e = cos(Phi);
    
elseif strcmp(opt_meth,'Nov')
    display('    => Sweep generated using ''Nov'' option')

    % L parameter
    L = 1/f1*round( (duration*f1)/(log(f2/f1)) ); 
    T_hat = L*log(f2/f1);
    
    % Time
    t = 0:1/fs:(fs*T_hat-1)/fs;

    % Computation of the phase
    Phi = 2*pi*f1*L*(exp(t/L)-1);

    % computation of the sweep
    e = sin(Phi);
    
else
    display('    => ERROR : Unknown method option')
    display('    => Select ''Reb'' or ''Nov''')
    return
end
