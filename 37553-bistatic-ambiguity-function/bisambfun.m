function varargout=bisambfun(u,r,fs,cut)
%% Bistatic ambiguity function(u,r,fs,cut)
%
% This function aims to calculate the values of the bistatic ambiguity
% function of the signals u (the signal measured) and r (the reference
% signal), sampled to the fs frequency. The main advantage to use this 
% function is just the need of the signals and the sampling frequency. 
% The cut parameter is used to differentite the kind of results to display:
% '2D', it returns the Ambiguity Function in the Doppler-Delay Space
% 'Delay' displays the Zero Delay cut
% 'Doppler' displays the Doppler Delay Cut
%
%
%
%
dim=size(u);
N=dim(1);

t = (0:(N-1))/fs;
u = u/norm(u);

tau = -(N-1):(N-1);
taulen = 2*N - 1;

nfreq = 2^nextpow2(taulen);

Fd = -fs/2:fs/nfreq:fs/2-fs/nfreq;

switch cut
    case 'Delay'
        amf_delaycut = nfreq*abs(ifftshift(ifft(abs(u).^2,nfreq)));
    case 'Doppler'
        fftx = fft(u.',taulen);
        amf_dopplercut = abs(fftshift(ifft(abs(fftx).^2)));
    case '2D'
        C = zeros(nfreq,taulen);
        for m = 1:taulen
            v = localshift(r(:),tau(m),N);
            C(:,m) = abs(ifftshift(ifft(u.*conj(v),nfreq)));
        end
        C = nfreq*C;
end


tau = [-t(end:-1:2) t];

[~,tau_scale,tau_label] = engunits(max(abs(tau)));
[~,fd_scale,fd_label] = engunits(max(abs(Fd)));
 



switch cut
        case '2D'
             %% Contour plot
            [~,hc] = contour(tau*tau_scale,Fd*fd_scale,C); grid on;
            set(get(hc,'Parent'),'Tag','ambg');
            xlabel_str = sprintf('Delay %s (%ss)',texlabel('tau'),tau_label);
            xlabel(xlabel_str);
            ylabel_str = sprintf('Doppler %s (%sHz)',texlabel('f_d'),fd_label);
            ylabel(ylabel_str);
            title('Ambiguity Function');
            colorbar;
            
            %% Surf of the function 
            figure(2),surf(tau*1e6,Fd/1e3,C,'LineStyle','none');
            axis tight; grid on; view([140,35]); colorbar;
            xlabel('Delay \tau (us)');ylabel('Doppler f_d (kHz)');
            title('Linear Wifi-Beacon Ambiguity Function');
        case 'Doppler'
            hl = plot(tau*tau_scale,amf_dopplercut); grid on;
            set(get(hl,'Parent'),'Tag','ambg');
            xlabel_str = sprintf('Delay %s (%ss)',texlabel('tau'),tau_label);
            xlabel(xlabel_str);
            ylabel('Ambiguity Function');
            title('Ambiguity Function, Zero Doppler Cut');
        case 'Delay'
            hl = plot(Fd*fd_scale,amf_delaycut); grid on;
            set(get(hl,'Parent'),'Tag','ambg');
            xlabel_str = sprintf('Doppler %s (%sHz)',texlabel('f_d'),fd_label);
            xlabel(xlabel_str);
            ylabel('Ambiguity Function');
            title('Ambiguity Function, Zero Delay Cut');
end


switch cut
        case '2D'
            varargout = {C,tau,Fd};
        case 'Doppler'
            varargout = {amf_dopplercut,tau};
        case 'Delay'
            varargout = {amf_delaycut,Fd};
end       



%--------------------------------------
function v = localshift(x,tau,xlen)
v = zeros(xlen,1);
if tau >= 0
    v(1:xlen-tau) = x(1+tau:xlen);
else
    v(1-tau:xlen) = x(1:xlen+tau);
end

% [EOF]