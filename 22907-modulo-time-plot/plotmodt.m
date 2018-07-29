function varargout=plotmodt(t,tper,y,fitflag,MarkerSize)

% plotmodt(t,tper,y)
% plotmodt(t,tper,y,fitflag)
% plotmodt(t,tper,y,fitflag,MarkerSize)
% [tt,yy]=plotmodt(t,tper,y)
% [tt,yy,yyres]=plotmodt(t,tper,y,1)
% 
% The Modulo Time Plot is useful for quick visual inspection
% of system performance including dynamic range, distortion and
% error plots, the detection of random bit errors, and timing errors
% between the test signal and the sample clock. [1]
%
% The method also works well on plotting eye diagrams.
%
% INPUTS        t: time vector, required as t is not always linearly spaced
%               tper: the trace period
%               y: input signal
%               fitflag: if 1, perform fit to find the residual
%                        works well for distorted 1-tones, see also (*)
%               MarkeSize: To adjust the resolution of the plot default:4
%                         (if y is large, MarkerSize should be small)
% OUPUTS        tt & yy: inputs t and y rearranged into a trace period
%               yyres: residual of y (if fit is done) also rearranged
%
% type plotmodt to launch two examples
%
% Author: Marko Neitola, University of Oulu, Finland
%
%[1] F. H. Irons andD. M. Hummels, 
%"The Modulo Time Plot - a Useful Data Acquisition Diagnostic Tool"
%IEEE Tr. on Instrumentation and Measurement, Vol.45, NO. 3, June 1996
%(*) the order of fit is fixed to 17, unless you download
%    the "polydeg" function (optimal polyn. degree) by Damien Garcia:
%    http://www.biomecardio.com/matlab/polydeg.html

if nargin ==0
    % Example 1 grabbed from for EYEMAP File ID: #15900
    n_simb = 1024; %Number of symbols
    ak=round(rand(1,n_simb)); %create random binary sequence
    n_pt=128; %Number of samples per symbol
    signal=zeros(1,length(ak)*n_pt); %initialize signal variable
    for k=1:length(ak) %Generate polar signal from digital sequence
        signal((k-1)*n_pt+1:k*n_pt) = 2*(ak(k)-0.5); 
    end;
    %Filter signal using a gaussian filter
    signal=real(ifft(fft(signal).*exp(-(1:length(signal)).^2/n_simb^2)));
    %Generate random gaussian noise
    noise=randn(size(signal))*0.1;
    %Visualize eye diagram of signal and noise
    figure
    plotmodt(0:131071,n_pt*4,signal+noise,0,4)
    %eyemap(signal+noise,n_pt*2)  % you can compare this to File ID: #15900
    
    %example 2: distorted sinusoid
    N=pow2(11);          	%vector length
    fs = pi*1e3;            %sampling freq
    ts = 1/fs;              %sampling interval
    freq = (N/128-1)*fs/N;  %freq (Hz)
    phase = -pi/8;          %phase (rad)
    offset = pi*4;          %offset (i.e mean)
    amplitude = pi/3;       %amplitude
    t = (0:(N-1))*ts;       %time vector
    std_jitter = 1e-2;  %standard deviation of jitter noise
    std_addnoi = 1e-1;  %standard deviation of  noise added to signal
    std_phase  = 0.2;   %standard deviation of phase noise
    noise = randn(1,N);
    std1_noise = noise/std(noise);  % random vector with stdev = 1
    jit_noise = std_jitter*std1_noise;
    phase_noise = std_phase*std1_noise;
    add_noise = std_addnoi*std1_noise;
    w=2*pi*freq;
    t = t + ts*jit_noise;                          % add clock jitter
    A2 = 0.1;     % 2. harmonic ampl
    A3 = 0.5;     % 3. harmonic ampl
    yin = cos(w*t+phase+phase_noise);  % sinusoid with phase noise
    yin = offset+amplitude*yin+A2*yin.*yin+A3*yin.*yin.*yin+add_noise; %add offset, noise & harmonics
    figure
    plotmodt(t,1/freq,yin,1,4)
    return
end

ts = norm(diff(t))/sqrt(length(t)-1);
lstyle = 'k.';

%The main idea is in these 3 lines:
tt=mod(t,tper);
[tt,index]=sort(tt);
yy=y(index);

if nargin == 3
    fitflag=0;
end
if nargin < 5
    MarkerSize = 4;
end

if fitflag == 1
    if exist('polydeg','file')==2
        n_poly = polydeg(tt,yy);
    else
        n_poly=17;
    end
    warning off %#ok<WNOFF>
    p=polyfit(tt,yy,n_poly);
    warning on %#ok<WNON>
    yest=polyval(p,tt);            
    legendtext = ['polyfit (o:',int2str(n_poly),')'];
    
    yyresi = yy-yest;
    subplot(211)

    plot(tt,yy,lstyle,tt,yest,'-r','MarkerSize',MarkerSize)
    title(['trace period plot, period is ', num2str(tper,2),'s. t_s = ', num2str(ts,2),'s'])
    axis tight,legend('data',legendtext,1),xlabel('time, 1 period')

    subplot(212)
    plot(tt,yyresi,lstyle,'MarkerSize',MarkerSize)
    title('trace period plot, residual'), axis tight,xlabel('time, 1 period')

else
    subplot(111)
    plot(tt,yy,lstyle,'MarkerSize',MarkerSize)
    title(['trace period plot, period is ', num2str(tper,2),'s. t_s = ', num2str(ts,2),'s'])
    axis tight,xlabel('time, 1 period')
end

if nargout>0
    varargout{1}=tt;
    varargout{2}=yy;
    if nargout == 3
        varargout{3}=yyresi;
    end
end
