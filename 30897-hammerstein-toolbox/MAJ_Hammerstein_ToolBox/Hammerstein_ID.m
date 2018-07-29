function hhat = Hammerstein_ID(input_sig,output,duration,f1,f2,fs,N,opt_meth,opt_filt)

%---------------------------------------------------------
%
% hhat = Hammerstein_ID(input_sig,output,f1,f2,fs,N,opt_meth,opt_filt)
%
% Estimates the Kernels "h" of the cascade of Hammerstein model of order N fed with
% the input signal "input" and where the corresponding output signal "output"
% has been recorded. "input" has to be an exponential sine sweep going from
% f1 to f2.
%
% Input parameters:
%   input_sig  : input exponential sine sweep
%   output : output of the system fed with the input signal
%   f1 : starting frequency of the sweep
%   f2 : end frequency of the sweep
%   fs : sampling frequency
%   N  : Order of the model to be identified
%   opt_meth : Method to use for the estimation (string expected)
%       - 'Reb': Method proposed by Rébillat et al. in [1]
%       - 'Nov': Method proposed by Novak et al in [2]
%   opt_filt : Specifies the method to use to compute the inverse filter 
%       (string expected). By default 'TFB_linear' is chosen.
%       - 'TFB_square': FTT based filter with a square window and
%         regularization (see [1])
%       - 'TFB_linear': FTT based filter with a square window with continuous
%         linear borders and regularization (see [1])
%       - 'TFB_gevrey': FTT based filter with a square window with infinitely
%         continuous gevrey borders and regularization (see [1])
%       - 'Nov' : Filter based on the analytical formulation using aymptotic 
%         signals (see [2]).
%
% Output:
%   h : 2D matrix containing the pseudo impulse responses (temporal domain) 
%   of the estimated kernels.
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
% Modified by Antonin Novak - 01/2012
% ant.novak@gmail.com, http://ant-novak.com
%
%--------------------------------------------------------------------------

display('--> Hammerstein Identification in progress ...')

% Check arguments
if nargin<6
    display('    => ERROR : Incorrect number of arguments')
    return
elseif nargin<7
    display('    => No method option and filtering option specified. ')
    display('    => Method option = ''Reb'' chosen by default.')
    display('    => Filtering option = ''TFB_linear'' chosen by default.')
    opt_meth = 'Reb' ;
    opt_filt = 'TFB_linear';
elseif nargin<8
    display(['    => Method ' opt_meth ' chosen'])
    display('    => No filtering option specified. ')
    if strcmp(opt_meth,'Reb')
        opt_filt = 'TFB_linear';
        display('    => Filtering option = ''TFB_linear'' chosen by default.')
    elseif strcmp(opt_meth,'Nov')
        opt_filt = 'Nov';
        display('    => Filtering option = ''Nov'' chosen by default.')
    else 
        display('    => ERROR : Unknown method option')
        display('    => Select ''Reb'' or ''Nov''')
        return
    end
else
    
    if ( strcmp(opt_meth,'Nov') || strcmp(opt_meth,'Reb'))
        display(['    => Method ' opt_meth ' chosen'])
    else
        display('    => ERROR : Unknown method option')
        display('    => Select ''Reb'' or ''Nov''')
        return
    end
    
    if ( strcmp(opt_filt,'TFB_square') || strcmp(opt_filt,'TFB_linear') || strcmp(opt_filt,'TFB_gevrey') || strcmp(opt_filt,'Nov'))
        display(['    => Filtering ' opt_filt ' chosen'])
    else
        display('    => ERROR : Unknown filtering option')
        display('    => Select ''TFB_square'', ''TFB_linear'', ''TFB_gevrey'' or ''Nov''')
        return
    end
end

% Equivalent pulsations
w1 = f1/fs*2*pi;
w2 = f2/fs*2*pi;

% Actual length of the sweep (in samples)
T = length(input_sig);

% Convolution of the response with the inverse of the sweep
if strcmp(opt_meth,'Reb')
    inverse_input_sig = compute_inverse_filter(input_sig,f1,f2,fs,opt_filt) ;
    gToCut = convq(output,inverse_input_sig);
elseif strcmp(opt_meth,'Nov')
    % Nonlinear convolution in the spectral domain
    gToCut = nonlinear_convolution(output,duration,f1,f2,fs);        
    gToCut = [gToCut; gToCut];
end

% Computation of the delay of the pseudo RI
if strcmp(opt_meth,'Reb')
    deltaT = T*log(1:N)/log(w2/w1);
elseif strcmp(opt_meth,'Nov')
    L = 1/f1*round( (duration*f1)/(log(f2/f1)) ); 
    deltaT = L*log(1:N)*fs;
end

% The time lags may be non integer, the non integer delay must be applied later
remainDeltaT = deltaT - floor(deltaT);

% Extraction of the pseudo RI
M = floor(min(diff(deltaT))/2);

% Windows for temporal windowing
M_2 = round(M/2) ;
win = ones(2*M+1,1);
winhann = hann(floor(M/4)*2);
win(1:M_2-floor(M/4)+1) = 0;
win(M_2-floor(M/4)+1:M_2) = winhann(1:round(end/2));
win(end-floor(M/4)+1:end) = 0;
win(end-2*floor(M/4)+1:end-floor(M/4)) = winhann(round(end)/2+1:end);
win = win.^2;

% Non-linear impulse responses extraction
g = zeros(N,2*M+1);
for k=1:N
    % Integer delay and windowing of the RI
    g(k,:) = gToCut(T-floor(deltaT(k))-M:T-floor(deltaT(k))+M).*win;
    % Non integer delay of the RI
    g(k,:) = delayNC(g(k,:),remainDeltaT(k));
end

% Chebyshev Matrix
Ac = transformation_matrix(N,opt_meth);

% computation of the RI (estimated hk)
hhat = Ac*g;
