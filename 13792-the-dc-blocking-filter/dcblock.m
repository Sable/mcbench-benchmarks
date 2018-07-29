function [varargout] = dcblock(varargin);
%
% DCBLOCK   determines the filter coefficient a for the dc blocking/high- 
%           pass filter y(t) = x(t) - x(t-1) + a*y(t-1).
%           
%           [a] = dcblock(Fc) returns the filter coefficient a for 
%           normalized cut-on frequency Fc.
%
%           [a] = dcblock(fc,fs)returns the filter coefficient a for cut-on 
%           frequency fc, and sampling frequency fs, when both are given in
%           Hz.
%
%           [aQ] = dcblock(fc,fs,B) returns the quantized filter
%           coefficient aQ when the quantization level B is given.
%
%           dcblock(...) plots the frequency and phase response of the
%           filter.
%
%           Note that if two parameters are passed to the function without
%           an output argument, the plot routine always interprets the
%           first as fc and the second as fs.
%
% SYNTAX    [a] = dcblock(Fc);
%           [a] = dcblock(fc,fs);
%           [aQ] = dcblock(fc,fs,B);
%           [Fc,fc] = dcblock(a,fs);
%           dcblock(Fc)
%           dcblock(fc,fs)
%           dcblock(fc,fs,B)
%
% INPUT     Fc      Normalized frequency cut-on of the filter.
%                   Fc = fc[Hz]/(fs[Hz]/2); fs/2 is the Nyquist frequency.
%                   Note that 0 < Fc < 1/3;
%
%           fc      filter cut-on frequency in Hz (or other reciprocal
%                   units of frequency e.g. 1/metre).
%
%           fs      sampling frequency in Hz (or other reciprocal
%                   units of frequency e.g. 1/metre).
%
%           B       quantization level for fixed point processing e.g. B is
%                   16 for 16-bit operation.
%
% OUTPUT    a       filter coefficient; 0 < a < 1 for floating point
%                   operation.
%
%           aQ      quantized filter coefficient a; 0 < aQ < 2^(B-1) - 1.
%                   The quantization level is set by B which is assumed to 
%                   be signed integer.
%
% EXAMPLES  (1) Calculate the filter coefficient a when the normalized
%               frequency is 1E-5:
%
%           >> format long                      % set display format 
%           >> a = dcblock(1E-5)                % Fc = 0.00001
%           >> a = 0.99994558749947             % filter coefficient
%
%           (2) Calculate the normalized and true cut-on frequency when the
%               coefficient a is 0.9987 and the sampling frequency is 1MHz:
%
%           >> [Fc,fc] = dcblock(0.9987,1E6)    % a = 0.9987; fs = 1MHz
%           >> Fc = 2.3906E-004                 % this output is normalized 
%           >> fc = 119.5323                    % this output is in Hz
%
%           Note the difference in inputs between [Fc,fc] = dcblock(a,fs), 
%           the function call [a] = dcblock(fc,fs), and its plot facility
%           dcblock(fc,fs). You can plot the filter response using   
%
%           >> dcblock(119.5323,1E6)            % fc = 119.5323; fs = 1E6
%
%           (3) Carry out filtering operation using the dc blocking filter
%               with cut-on frequency of 70Hz and sampling rate of 10kHz. 
%
%           t = -0.1:1/10000:0.1-1/10000;       % set up time base
%           s = sin(2*pi*2.5*t+pi/6)+0.01*randn(size(t))+1.25;
%           x = gauspuls(t,250,0.6) + s;        % noisy Gaussian test pulse
%           p = dcblock(70,10000);              % get filter coefficient
%           b = [1 -1];                         % set up differentiator
%           a = [1 -p];                         % set up integrator
%           y = filter(b,a,x);                  % filter test data
%           plot(t,x,t,y)                       % plot results to screen
%           legend('Original','DC Filtered','location','northwest');
%
%           The forward pass of the filter creates a distortion in the
%           Gaussian pulse. This distortion can be removed by using the 
%           filtfilt form of the filter. If you now try
%
%           y2 = filtfilt(b,a,x);               % filter test data
%           plot(t,x,t,y,t,y2)                  % plot results to screen
%           legend('Original','DC Filtered','Undistorted','location','northwest');
%
%           you will notice that the symmetry of the Gaussian pulse has
%           been restored.
%
% See also FILTER, FILTFILT, SPTOOL, FDATOOL.

% Author:   J M De Freitas
%           QinetiQ Ltd, Winfrith Technology Centre
%           Winfrith, Dorchester DT2 8XJ, UK. 
%
% Email     jdefreitas@qinetiq.com
%
% Revision  1.0
% 
% Date      11 October 2006.
%


% Perform checks on input and output
Lin = nargin;
Lout = nargout;
if Lin > 3
    error('dcblock error: Too many input arguments.');
end
if Lin < 1
    errror('dcblock error: No input argument used.');
end
if Lout > 2
    error('dcblock error: Too many output arguments.');
end

% Calculate a when Fc is given and plot response if required
if Lin == 1
    Fc = varargin{1};
    if (Fc < 0)|(Fc > 1/3)
        error('dcblock error: Normalized cut-on frequency must be between 0 and 1/3.');
    end
    a = coef(Fc);
    if Lout == 1
        varargout{1} = a;
    elseif Lout == 0
        PlotResp(1,a);
    end
end

% Calculate a when fc and fs are given and plot response if required
% or Fc and fc when a and fs are given
if Lin == 2
    if (Lout == 1)|(Lout == 0)
        fc = varargin{1};
        fs = varargin{2};
        Fc = 2*fc/fs;
        if (Fc < 0)|(Fc > 1/3)
            error('dcblock error: Cut-on frequency must be between 0 and fs/6.');
        end
        a = coef(Fc);
        if Lout == 1
            varargout{1} = a;
        else
            PlotResp(fs/2,a);
        end
    elseif Lout == 2
        a = varargin{1};
        fs = varargin{2};
        if (a < 0)|(a > 1)
            error('dcblock error: Filter coefficient a must be between 0 and 1.');
        end
        Fc = atan(sqrt(3)*(1-a^2)/(1+4*a+a^2))/pi;       
        varargout{1} = Fc;
        varargout{2} = Fc*fs/2;
    end
end

% Calculate a when B, fc and fs are given and plot if required
if Lin == 3
    fc = varargin{1};
    fs = varargin{2};
    B = floor(varargin{3});
    Fc = 2*fc/fs;
    if (Fc < 0)|(Fc > 1/3)
        error('dcblock error: Cut-on frequency fc must be between 0 and fs/6.');
        return
    end
    if (B <= 2)|(B > 300)
        error('dcblock error: Quantization level B must be between 2 and 300.');
        return
    end
    a = coef(Fc);
    if Lout == 1
        varargout{1} = floor(a*(2^(B-1)-1));
    elseif Lout == 0
        aQ = floor(a*(2^(B-1)-1))/(2^(B-1)-1);
        PlotResp(fs/2,aQ);
    end
end


function a = coef(Fc);
% get up coefficient
    a = (sqrt(3) - 2*sin(pi*Fc))/(sin(pi*Fc) + sqrt(3)*cos(pi*Fc));

function PlotResp(Fn,a);
% Plot frequency and phase response
    f = 0.000001:0.000001:1-0.000001;
    h = (1+a)*sin(pi*f/2)./sqrt(1+a^2-2*a*cos(pi*f));
    phi = atan((1-a)*(sin(pi*f)./(1-cos(pi*f)))/(1+a));
    indigo = [.48 .06 .89];
    subplot(2,1,1);
        loglog(Fn*f,h,'LineWidth',1.5,'Color',indigo);
        title('\bf Frequency Response: IIR DC Blocking Filter','Color','k');
        if Fn == 1
            xlabel('Normalized Frequency');
        else
            xlabel('Frequency (Hz)');
        end
        ylabel('Magnitude ');
        minY = min(get(gca,'YTick'));
        minX = min(get(gca,'XTick'));
        maxX = max(get(gca,'XTick'));
        if minY >= 0.1 
            TickY = [0.1 1];  
        else
            for j = 1:abs(log10(minY))+1 TickY(j) = 10^(log10(minY)+j-1); end 
        end
        for j = 1:(log10(maxX)-log10(minX))+1 TickX(j) = 10^(log10(minX)+j-1); end
        ylim([TickY(1) 1.1]);
        set(gca,'XGrid','on','YGrid','on','XMinorGrid','on',...
        'YMinorGrid','on','GridLineStyle','-',...
        'MinorGridLineStyle','-','Xtick',TickX,'Ytick',TickY,...
        'Color',[0.835 0.918 0.918]);
    subplot(2,1,2);
        loglog(Fn*f,phi*180/pi,'LineWidth',1.5,'Color',indigo);
        title('\bf Phase Response: IIR DC Blocking Filter','Color','k');
        if Fn == 1
            xlabel('Normalized Frequency');
        else
            xlabel('Frequency (Hz)');
        end
        ylabel('Phase (degree) ');
        ylim([0.1 100]);
        minX = min(get(gca,'XTick'));
        maxX = max(get(gca,'XTick'));
        for j = 1:(log10(maxX)-log10(minX))+1 
            TickX2(j) = minX*10^(j-1) ;
        end
        set(gca,'XGrid','on','YGrid','on','XMinorGrid','on',...
        'YMinorGrid','on','GridLineStyle','-',...
        'MinorGridLineStyle','-','Xtick',TickX2,'YTick',[0.1 1 10 100],...
        'Color',[0.835 0.918 0.918]);
        
