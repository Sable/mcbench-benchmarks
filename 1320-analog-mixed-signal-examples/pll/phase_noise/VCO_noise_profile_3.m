function noise_filt=VCO_noise_profile_3(Npts,Level_dB,Freq,OverSample,Interp_Select,Verify); 
% Npts = length of filter kernel. More provides increased freq resolution
% Freq     = Vector of frequencies in Hz
% Level_dB = Corresponding Vector of noise levels
% OverSample = Sets Fs , must be > 2*max freq spec
% Verify   = true to show plots
% Create a filter kernel (FIR coefficients) that approximates a user spec'd
% power spectrum Level is dB/Hz
% To get dBc, carrier must be 1 Watt.
% Dick Benson  December 2009
% Copyright 2009-2013 The MathWorks, Inc.

L     = round(Npts/2);         
f     =(0:(L-1))/L;     % frequency vector normalized to Fs/2
ph    = reshape([0;pi]*ones(1,L/2),L,1)'; % phase curve

Fs = OverSample*Freq(end); 

switch Interp_Select
   case 1
     % linear X axis 
     Level    = [Level_dB(1),Level_dB,Level_dB(end)];    % pad start and end
     Freq     = [0,          Freq,    Fs/2 ];            % ditto
     % linearly interpolate in the dB realm.
     shape_dB = interp1(Freq,Level,f*Fs/2,'linear');
     shape    =   10.^(shape_dB/20); 
   case 2
     % log x axis 
     Level    = [Level_dB,Level_dB(end)];    % pad  end
     Freq     = [Freq, Fs/2 ];        % ditto
     % linearly interpolate in the dB realm.
     log_Freq= log10(Freq);
     
     shape_dB = interp1(log_Freq,Level,log10(f*Fs/2),'linear');
     % remove any NaNs and pad
     bogus_nans = isnan(shape_dB);
     if sum(bogus_nans)==0
        shape    =   10.^(shape_dB/20); 
     else 
        N=sum(bogus_nans); 
        shape    =   10.^([shape_dB(N+1:2*N),shape_dB((N+1):end)]/20); 
     end;
   end
 
  
  dFspec = min(diff(Freq(2:end)));
  dF     = Fs/Npts;
  if dFspec<dF
     warndlg(['The frequency resolution of the Spec is greater than can be achieved. \n Consider Increasing the number of Points in the FIR Kernel, or removing the low Frequency Specs.',sprintf('F=%10.2f  ',Freq(2:3)), 'etc.'],[ 'Freq REsolution']); 
  end;

shape_2 = shape.*f*Fs/2; % multiply by Frequency to create derivative 
% Need to create a complex spectral description 
% which, when transformed with the ifft, creates a REAL impulse response.
mag=[shape_2,0, fliplr(shape_2(2:end))]; % construct magnitude
phase=[-ph,0,fliplr(ph(2:end))];     % and phase 
H=mag.*exp(1i*phase); % complex representation
h=ifft(H);            % Filter Kernel 

%  sanity checks ....
if Verify
   hf    =  findobj('Tag','plot_VCO');
   if isempty(hf) 
      hf =  figure('Tag','plot_VCO');
   else
      figure(hf);
   end

   subplot(2,1,1)
   plot((h)); title('Filter Impulse Response (no window)');
   xlabel('samples')
end;

% If the filter is used as is, there may be ripples in the frequency
% reponse due to the abrupt transistions at the impulse response endpoints.
% To mitigate this, apply a Hanning window and compare computed response with
% the spec and interpoloted spec. 

hout=h.*hann(2*L)';

if Verify
   H2=fft(hout);            % take fft of windowed filter kernel
   subplot(2,1,2)
   % undo derivative by dividing by frequency before displaying
   semilogx(f/2*Fs,20*log10(abs(H2(1:L)./(f.*Fs/2))),f/2*Fs,20*log10(shape),'x',Freq,Level,'o'); 
   legend('Filter Response','Interpolated Spec','Spec','location','southwest');
   title('Freq Responses of Specification and Attained Noise Profiles.  ');
   xlabel('Freq'); ylabel('dB');
end;

noise_filt=hout;