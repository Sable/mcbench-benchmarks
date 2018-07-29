function [psd,sample,ASAcontrol] = arma2psd(varargin)
%ARMA2PSD ARMA parameters to power spectral density
%   [F,SAMPLE] = ARMA2PSD(AR,MA,N) determines N values of the normalized 
%   power spectral density function of an ARMA process determined by the 
%   parameter vectors AR and MA and returns the result in F. The function 
%   is restricted to a domain from 0 to 0.5/T Hz, corresponding with a 
%   time domain sampling period T. T = 1 is used by default. The values 
%   in the frequency domain, at which the function is evaluated, are 
%   returned in SAMPLE. N can also be omitted from the input list, in 
%   which case 129 values are returned.
%   
%   ARMA2PSD(AR,MA,SAMPLE) evaluates the function at those values in its 
%   frequency domain that are supplied by the row vector SAMPLE.
%   
%   ARMA2PSD(AR,MA,N,T,K) or ARMA2PSD(AR,MA,SAMPLE,T,K) allows to set the 
%   sampling period T. N or SAMPLE can also be empty arrays, in which 
%   case the default number of samples is chosen. A positive integer K, 
%   that serves as a multiplier of the sampling period T, can optionally 
%   be added to the input argument list. In combination with a default 
%   number of frequency values, these values will be determined, such 
%   that they will coincide with frequency values earlier determined in 
%   combination with other values of K.
%   
%   By omitting all output arguments, the function generates a graph. 
%   After turning on the HOLD status, additional graphs can be plotted in 
%   the same figure, while line colors are automatically varied.
%   
%   ARMA2PSD is an ARMASA main function.
%   
%   See also: ARMA2COR

%   References: S. M. Kay and S. L. Marple, Spectrum Analysis - a Modern
%               Perspective, Proceedings IEEE, Vol. 69, 1981,
%               pp. 1380-1419, section D.

%Header
%==============================================================================

%Declaration of variables
%------------------------

%Declare and assign values to local variables
%according to the input argument pattern
[ar,ma,sample,T,k,ASAcontrol]=ASAarg(varargin, ...
{'ar'       ;'ma'       ;'sample'   ;'T'        ;'k'        ;'ASAcontrol'}, ...
{'isnumeric';'isnumeric';'isnumeric';'isnumeric';'isnumeric';'isstruct'  }, ...
{'ar'       ;'ma'                                                        }, ...
{'ar'       ;'ma'       ;'sample'                                        }, ...
{'ar'       ;'ma'       ;'sample'   ;'T'                                 }, ...
{'ar'       ;'ma'       ;'sample'   ;'T'        ;'k'                     });

if isequal(nargin,1) & ~isempty(ASAcontrol)
      %ASAcontrol is the only input argument
   ASAcontrol.error_chk = 0;
   ASAcontrol.run = 0;
end

%ARMASA-function version information
%-----------------------------------

%This ARMASA-function is characterized by
%its current version,
ASAcontrol.is_version = [2001 3 19 14 30 0];
%and its compatability with versions down to,
ASAcontrol.comp_version = [2000 12 30 20 0 0];

%This function calls other functions of the ARMASA
%toolbox. The versions of these other functions must
%be greater than or equal to:
ASAcontrol.req_version.arma2cor = [2000 12 30 20 0 0];

%Checks
%------

if ~isfield(ASAcontrol,'error_chk') | ASAcontrol.error_chk
      %Perform standard error checks
   %Input argument format checks
   ASAcontrol.error_chk = 1;
   if ~isnum(ar)
      error(ASAerr(11,'ar'))
   elseif ~isavector(ar)
      error(ASAerr(15,'ar'))
   elseif size(ar,1)>1
      ar = ar';
      warning(ASAwarn(25,{'column';'ar';'row'},ASAcontrol))         
   end
   if ~isnum(ma)
      error(ASAerr(11,'ma'))
   elseif ~isavector(ma)
      error(ASAerr(15,'ma'))
   elseif size(ma,1)>1
      ma = ma';
      warning(ASAwarn(25,{'column';'ma';'row'},ASAcontrol))         
   end
   if ~isempty(sample)
      if ~isnum(sample) | ~isavector(sample) |...
            sample(1)<0 | ~isascending(sample)
         error(ASAerr(31,{'sample of frequencies';'sample'}))
      elseif size(sample,1)>1
         sample = sample';
         warning(ASAwarn(25,{'column';'sample';'row'},ASAcontrol))
      end
   end
   if ~isempty(T) & (~isnum(T) | ...
         ~isascalar(T) | T<=0)
      error(ASAerr(32,'T'))
   end
   if ~isempty(k) & (~isnum(k) | ...
         ~isintscalar(k) | k<=0)
      error(ASAerr(17,'k'))
   end
   
   %Input argument value checks
   if ~(isreal(ar) & isreal(ma))
      error(ASAerr(13))
   end
   if ar(1)~=1
      error(ASAerr(23,{'ar','parameter'}))
   end
   if ma(1)~=1
      error(ASAerr(23,{'ma','parameter'}))
   end
   if ~isempty(sample) & ~isreal(sample)
      error(ASAerr(13))
   end
   if ~isempty(T) & ~isreal(T)
      error(ASAerr(13))
   end
   if ~isempty(sample) 
      if isascalar(sample)
         if sample==0
            error(ASAerr(33,{'number of frequency samples';'sample';'zero'}))
         end
      else
         if isempty(T)
            T_test=1;
         else
            T_test=T;
         end
         if isempty(k)
            k_test=1;
         else
            k_test=k;
         end
         freq_lim_test = 0.5/(T_test*k_test);
         if sample(end)>freq_lim_test
            error(ASAerr(34,{'sample';num2str(freq_lim_test)}))
         end
      end
   end
end

if ~isfield(ASAcontrol,'version_chk') | ASAcontrol.version_chk
      %Perform version check
   ASAcontrol.version_chk = 1;
      
   %Make sure the requested version of this function
   %complies with its actual version
   ASAversionchk(ASAcontrol);
   
   %Make sure the requested versions of the called
   %functions comply with their actual versions
   arma2cor(ASAcontrol);
end

if ~isfield(ASAcontrol,'run') | ASAcontrol.run
   ASAcontrol.run = 1;
end

if ASAcontrol.run %Run the computational kernel   
   ASAcontrol.version_chk = 0;
   ASAcontrol.error_chk = 0;

%Main   
%=====================================================
    
%Initializations
%---------------

if isempty(k)
   k = 1;
end

if isempty(T)
   T = 1;
end

%Determine the scale factor of the frequency axis
%with respect to a range from 0 to 1
freq_scale = 1/(2*k*T);

if isempty(sample) %Asess a default value of 'sample'
   %Asess the number of frequency samples in excess
   %of one
   pow2 = 128; %any power of two can be used
   n_sample = pow2/k;
   
   if n_sample == fix(n_sample) %The frequencies
         %coincide with the sample grid determined
         %for k=1
      sample = n_sample+1;
   else 
      %Determine frequencies that coincide with the
      %sample grid up to the frequency limit and
      %append 'sample' with this frequency limit
      n_sample = 2^ceil(log2(pow2/k));
      step = pow2/n_sample;
      sample = [0:1:fix(pow2/k)]/(step*n_sample);
      sample(end+1) = pow2/(k*step*n_sample);
      sample = k*freq_scale*sample;
   end
end

%Asess an appropriate computational mode:
%mode==0 : via FFT
%mode==1 : direct polynomial evaluation
if length(sample)==1
   if 0.5*length(ar)+1 > sample
      den_mode = 0;
   else
      den_mode = 1;
   end
   if 0.5*length(ma)+1 > sample
      num_mode = 0;
   else
      num_mode = 1;
   end
   if sample==1
      sample = 0;
   else
      n_fft = (sample-1)*2;
      sample = (freq_scale/(sample-1))*[0:sample-1];
   end
else
   num_mode = 0;
   den_mode = 0;
end

%Determination of the sampled normalized power
%spectral density function
%---------------------------------------------

%Determine the power gain (variance_sig/variance_noise)
%of the ARMA proces
[cor,gain] = arma2cor(ar,ma,0,ASAcontrol);

if ~num_mode | ~den_mode
   z = exp((pi*i/freq_scale)*sample);
end
if num_mode
   numerator = fft(ma,n_fft);
   numerator = numerator(1:n_fft/2+1);
else
   numerator = polyval(ma,z);
end
if den_mode
   denominator = fft(ar,n_fft);
   denominator = denominator(1:n_fft/2+1);
else
   denominator = polyval(ar,z);
end
h = abs(numerator./denominator).^2;
psd = h/(2*freq_scale*gain);

%Graphical representation
%------------------------

if nargout==0
   handle_spec = semilogy(sample,psd,'-b.');
   hold_state = ishold;
   hold on;
   y_lim = get(gca,'ylim');
   handle_lim = ...
      plot(freq_scale*[1 1],[y_lim(1) y_lim(2)],':');
   string = strvcat(' ',['T = ' num2str(T) ' '],...
      ['k = ' num2str(k)]);
   handle_tag = text(freq_scale,y_lim(2),string,...
      'FontName','FixedWidth','Units','data',...
      'VerticalAlignment','top',...
      'HorizontalAlignment','right');
   set(handle_tag,'Units','data')
   string = '\rightarrow frequency f  [Hz]          ';
   handle_xlabel=xlabel(string,...
      'HorizontalAlignment','right','Units',...
      'normalized');
   pos_xlabel=get(handle_xlabel,'Position');
   set(handle_xlabel,'Units','normalized',...
      'Position',[1 pos_xlabel(2)*1.2])
   string = ['\rightarrow normalized power '...
         'spectral density F( f )'];
   handle_ylabel=ylabel(string,...
      'HorizontalAlignment','right','Units',...
      'normalized');
   pos_ylabel=get(handle_ylabel,'position');
   set(handle_ylabel,'units','normalized',...
      'Position',[pos_ylabel(1) 1])
   title(['Right-sided Frequency Spectrum '...
      '( log-scale )'])

   persistent color_entry
   if isempty(color_entry)
      color_entry = 0;
   end
   if hold_state
      color_entry = color_entry+1;
      color_mtx = get(gca,'ColorOrder');
      s_color = size(color_mtx);
      s_color = s_color(1);
      color_entry = max(1,s_color*(color_entry/...
         s_color-fix(color_entry/s_color)));
      color = color_mtx(color_entry,:);
      set(handle_spec,'color',color);
      set(handle_lim,'color',color);
      set(handle_tag,'color',color);
   else
      color_entry=1;
      set(handle_tag,'color',[0 0 1]);
   end
   
   if ~hold_state
      hold
   end
   
   clear psd
end

%Footer
%=====================================================

else %Skip the computational kernel
   %Return ASAcontrol as the first output argument
   if nargout>1
      warning(ASAwarn(9,mfilename,ASAcontrol))
   end
   psd = ASAcontrol;
   ASAcontrol = [];
   sample = [];
end

%Program history
%================================================================================
%
% Version                Programmer(s)          E-mail address
% -------                -------------          --------------
% former versions        P.M.T. Broersen        p.m.t.broersen@tudelft.nl
%                        S. de Waele            
% [2000 12 30 20  0 0]   W. Wunderink           
% [2001  3 19 14 30 0]         ,,                