function varargout = winsinc(x,dt,fc,ns,win,ftype,fo)
% Applies a windowed sinc filter
%
% USAGE:
%   [xf,Rh,Fh] = winsinc(x,dt,fc,ns,ftype,fo)
%
% DESCRIPTION:
%   Windowed Sinc Filter.
%   This is a digital symetric non-recursive filter
%   which can be Lowpass, Highpass, or Bandpass
%   by using a windowed sinc function.
%   Non-Recursive filters are based on convolving 
%   the input series with a weight function.
%   Their advantage compared to recursive filters
%   is that they are always stable and matematically simpler.
%   Their disadvantage is that they may require a large
%   number of weights to achieve a desired response.
%
%INPUT VARIABLES:
%   x = vector
%   dt = Sampling Interval
%   fc = Cutoff frequency
%   ns = Width of filter 
%       (>>ns produces a steeper cutoff
%       but is more computationally expensive)
%       2*ns + 1 = Order of Filter, (Number of Filter Coef.)
%   win = Window Type:
%       'welch','parzen','hanning','hamming'
%       'blackman','lanczos','kaiser'
%   
%   ftype = 'low', 'high' o 'pass'
%   fo = Central Frequency (for bandpass only) 
%
%OUTPUT VARIABLES:
%   xf = filtered vector
%   Rh = Filter Response
%   Fh = Frequencies for Filter Response
%
%Copy-Left, Alejandro Sanchez, 2005

switch nargin
    case 0
        n = 500;
        t = linspace(0,20,n);
        dt = diff(t(1:2));
        s1 = 3*sin(2*pi*t/1);
        s2 = 6*sin(2*pi*t/3);
        s3 = 4*sin(2*pi*t*3);
        x = s1 + s2 + s3 + 1*randn(1,n);
        fc = 1;
        ns = 80;
        win = 'welch';
        win = 'kaiser';
        win = 'lanczos';
%         win = 'gauss';
%         win = 'boxcar';
        ftype = 'low';
%         fc = 0.09;
%         ftype = 'pass';
%         fo = 1;
        winsinc(x,dt,fc,ns,win,ftype);
        return
    case {1,2,3}
        error('Faltan argumentos de entrada')
    case 4
        ftype = 'low'; %pasa baja 
    case {5,6}
        ftype = lower(ftype);
        switch ftype
            case {'low','high'}
                if nargin==6 
                    warning('El filtrado pasa-baja y alta no requieren fo')
                end %if
            case 'pass'
                if nargin==5
                    error('Bandpass filter requires fo')
                end %if
            otherwise 
                error('Invalid Filter Type');    
        end %switch
    otherwise
        error('Too many Inputs')
end %switch
   
N = length(x); 
fn = (1/(2*dt)); %Nyquist frequency
df = 2*fn/(N-1); %delta frec
fcc = fc;

%Frecuencia de corte para pasa alta
if strcmpi(ftype,'high')
    fc = fn - fc;   
end

delta = 4*fn/(2*ns+1);
d = delta/2;
if d>fc
    warning('Cutoff Frequency too small')
    fc = d;
end
n = -ns:ns;
h = zeros(1,2*ns+1);
hh = h;

warning off MATLAB:divideByZero

w = zeros(size(n));
an = abs(n);
ic = (an<ns);
switch lower(win(1:3))
    case 'wel' %welch
        w(ic) = 1 - (n(ic)/ns).^2
        w(~ic) = 0;
    case 'par' %parzen
        ic1 = (an>=0 & an<1);
        w(ic1) = 1/4*(4 - 6*an(ic1).^2  + 3*an(ic1).^3);
        ic2 = (an>=1 & an<2);
        w(ic2) = 1/4*(2 - an(ic2)).^3
        ic3 = (~ic1 & ~ic2); %otherwise
        w(ic3) = 0;
    case 'han' %hanning
        alpha = 1/2;
        w(ic) = alpha + (1 - alpha)*cos(pi*n(ic)/ns);
        w(~ic) = 0;
    case 'ham' %hamming
        alpha = 0.54;
        w(ic) = alpha + (1 - alpha)*cos(pi*n(ic)/ns);
        w(~ic) = 0;
    case 'bla' %blackman
        w(ic) = 0.42 + 0.5*cos(pi*n(ic)/ns) ...
            + 0.08*cos(2*pi*n(ic)/ns);
        w(~ic) = 0;
    case 'lan' %lanczos
        w(ic) = sin(pi*n(ic)/ns)./(pi*n(ic)/ns);
        w(~ic) = 0;
    case 'kai' %kaiser
        alpha = 0.01;
        y = alpha*sqrt(1 - (n(ic)/ns).^2);
        w(ic) = besselj(0,y)./besselj(0,alpha);
        w(~ic) = 0;
    case 'gau' %gauss
        sigma = 30;
        w(ic) = exp(-(n(ic)/sigma).^2);
        w(~ic) = 0;
    case 'box' %boxcar
        w = ones(size(n));
    otherwise
        error('Invalid Window')
        %w = ones(ns,1)/ns;
end %switch

%Basic Filter (sinc)
a = fc/fn; %0<a<1
c = sin(pi*n*a)./(pi*n);

%Obtain filter Coefficients
%Multiplication is time domain
%is a convolution in frequency domain
h = w.*c;

ind = find(n==0);
h(ind) = a; 

%pasa alta
if strcmpi(ftype,'high')
    h(2:2:length(h)) = -1*h(2:2:length(h));
end

hh = h;
hh(ind) = 0;

%Filter Frequencies
Fh = 0:df:fn;
 
switch ftype
case {'low','high'}
    %Respuesta en Frecuencia del Filtro
    for k=1:length(Fh);
        Rh(k) = a + sum(hh.*cos(2*pi*n*Fh(k)/(2*fn)));
    end
    %Filtrado por convolucion entre la Serie de Datos
    %y los Coeficientes del Filtro
    xf = conv(x,h); 
    xf = wkeep(xf,N);
    case 'pass'
    %Respuesta en Frecuencia del Filtro
    for k=1:length(Fh);
        Rh(k) = a + sum(hh.*cos(2*pi*n*(Fh(k)-fo)/(2*fn)));
    end
    %Corrimiento de los pesos del filtro
    th = n*dt;
    i = sqrt(-1); %Redundant but instructive
    hpri = h.*exp(2.0*i*pi*fo.*th);
    %Filtrado en tiempo: Convolucion entre la Serie
    %de Datos y los Coeficientes del Filtro
    xfc = conv(x,hpri); 
    xf = 2.0*real(xfc); 
    xf = wkeep(xf,N);
end

xf = xf(:);

if nargout==0
    subplot(3,1,1)
    plot(x,'b')
    hold on
    plot(xf,'r')
    hold off
    legend('Original','Filtered')
    
    subplot(3,2,3)
    plot(h)
%     hold on
%     plot(hh,'r')
    ylabel('Filter Coef.')
    set(gca,'xlim',[0,length(h)])
    
    subplot(3,2,4)
    [psd,f] = spectral(x,dt,'hanning');
    loglog(f,psd)
    hold on
    [psd,f] = spectral(xf,dt,'hanning');
    loglog(f,psd,'r')
    set(gca,'xlim',[f(1),f(end)])
    set(gca,'xticklabel',get(gca,'xtick'))
    hold off
    ylabel('PSD(f)')
    
    subplot(3,1,3)
    semilogx(Fh,Rh)
    hold on
    lim = axis;
    plot([fcc,fcc],[lim(3),lim(4)],'g')
    if exist('fo') & fo>Fh(1)
        plot([fo,fo],[lim(3),lim(4)],'r')
    end 
    set(gca,'xlim',[Fh(1),Fh(end)],'ylim',[-0.1,1.1])
    set(gca,'xticklabel',get(gca,'xtick'))
    hold off
   xlabel('Frequency')
%     xlabel('Period')
    ylabel('Response')
    
end

if nargout>0
    varargout{1} = xf;
end
if nargout>1
    varargout{2} = Rh;
end
if nargout>2
    varargout{3} = Fh;
end

warning on MATLAB:divideByZero

return
