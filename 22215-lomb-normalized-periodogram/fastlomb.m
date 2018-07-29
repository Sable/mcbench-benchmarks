function [P,f,alpha] = fastlomb(x,t,varargin)
% FASTLOMB caculates the Lomb normalized periodogram (aka Lomb-Scargle, Gauss-Vanicek or Least-Squares spectrum) of a vector x with coordinates in t. 
%   The coordinates need not be equally spaced. In fact if they are, it is
%   probably preferable to use PWELCH or SPECTRUM. For more details on the
%   Lomb normalized periodogram, see the excellent section 13.8 in [1], pp.
%   569-577.
%
%   This code is a transcription of the Fortran subroutine fasper in [1]
%   (pp.575-577), so it is a really fast (albeit not really exact)
%   implementation of the Lomb periodogram. Also Matlab's characteristics
%   have been taken into account in order to make it even faster for
%   Matlab. For an exact calculation of the Lomb periodogram use LOMB,
%   which is however about 100 times slower.
%
%   If the 'fig' flag is on, the periodogram is created, along with some
%   default statistical significance levels: .001, .005, .01, .05, .1, .5.
%   If the user wants more significance levels, they can give them as input
%   to the function. Those will be red. 
%
% SYNTAX
%   [P,f,alpha] = fastlomb(x,t,fig,hifac,ofac,a);
%   [P,f,alpha] = fastlomb(x,t,fig,hifac,ofac);
%   [P,f,alpha] = fastlomb(x,t,fig,hifac);
%   [P,f,alpha] = fastlomb(x,t,fig);
%   [P,f,alpha] = fastlomb(x,t);
%
% INPUTS
%   x:     the vector whose spectrum is wanted.
%   t:     coordinates of x (should have the same length).
%   fig:   if 0 (default), no figure is created.
%   hifac: the maximum frequency returned is 
%               (hifac) x (average Nyquist frequency)
%          See "THE hifac PARAMETER" in the NOTES section below for more
%          details on the hifac parameter. Default is 1 (i.e. max frequency
%          is the Nyquist frequency).
%   ofac:  oversampling factor. Typically it should be 4 or larger. Default
%          is 4. See "INTERPRETATION AND SELECTION OF THE ofac PARAMETER"
%          in the NOTES section below for more details on the choice of
%          ofac parameter. 
%   a:     additional significance levels to be drawn on the figure.
%
% OUTPUTS
%   P:     the Lomb normalized periodogram 
%   f:     respective frequencies 
%   alpha: statistical significance for each value of P 
%
% NOTES
% A. INTERPRETATION AND SELECTION OF THE ofac PARAMETER [1]
%    The lowest independent frequency f to be examined is the inverse of
%    the span of the input data, 
%               1/(tmax-tmin)=1/T. 
%    This is the frequency such that the data can include one complete
%    cycle. In an FFT method, higher independent frequencies would be
%    integer multiples of 1/T . Because we are interested in the
%    statistical significance of ANY peak that may occur, however, we
%    should over-sample more finely than at interval 1/T, so that sample
%    points lie close to the top of ANY peak. This oversampling parameter
%    is the ofac. A value ofac >~4 might be typical in use.
%
% B. THE hifac PARAMETER [1]
%    Let fhi be the highest frequency of interest. One way to choose fhi is
%    to compare it with the Nyquist frequency, fc, which we would obtain, if
%    the N data points were evenly spaced over the same span T, that is 
%               fc = N/(2T). 
%    The input parameter hifac, is defined as fhi/fc. In other words, hifac
%    shows how higher (or lower) that the fc we want to go.
%
% REFERENCES
%   [1] W.H. Press, S.A. Teukolsky, W.T. Vetterling and B.P. Flannery,
%       "Numerical recipes in Fortran 77: the art of scientific computing",
%       2nd ed., vol. 1, Cambridge University Press, NY, USA, 2001. 
%
% C. Saragiotis, Nov 2008


%% Inputs check and initialization 
if nargin < 2, error('%s: there must be at least 2 inputs.',mfilename); end
MACC = 10;   % Number of interpolation points per 1/4 cycle of the highest frequency

[x,t,hifac,ofac,a_usr,f,fig] = init(x,t,varargin{:});
nt = length(t);

mx = mean(x);
x  = x-mx;
vx = var(x);    
if vx==0, error('x has zero variance'); end

nf = length(f);
nfreq  = 2^nextpow2(ofac*hifac*nt*MACC); 
% ndim = 2*nfreq;

tmin = t(1);
tmax = t(end);
T = tmax-tmin;

%% Extirpolation 
fac = 2*nfreq/(T*ofac);
[wk1,wk2] = extirpolate(t-tmin,x,fac,nfreq,MACC);

%% Take the FFT's 
W = fft(wk1);
reft1 = real(W(2:nf+1)); % only positive frequencies, without f=0
imft1 = imag(W(2:nf+1));

W = fft(wk2);
reft2 = real(W(2:nf+1)); 
imft2 = imag(W(2:nf+1)); 

%% Main 
hypo  = sqrt(reft2.^2+imft2.^2);
hc2wt = 0.5*reft2./hypo; 
hs2wt = 0.5*imft2./hypo;
cwt   = sqrt(0.5+hc2wt);
swt   = (sign(hs2wt)+(hs2wt==0)).*(sqrt(0.5-hc2wt)); 
den   = 0.5*nt + hc2wt.*reft2 + hs2wt.*imft2;
cterm = (cwt.*reft1 + swt.*imft1).^2./den;
sterm = (cwt.*imft1 - swt.*reft1).^2./(nt-den);
P  = (cterm+sterm)/(2*vx);
P  = P(:);

%% Significance 
M = 2*nf/ofac;
alpha = 1 - (1-exp(-P)).^M;              % statistical significance
alpha(alpha<0.1) = M*exp(-P(alpha<0.1)); % (to avoid round-off errors)

%% Figure 
if fig
    figure
    styles = {':','-.','--'};

    a = [0.001 0.005 0.01 0.05 0.1 0.5];
    La = length(a);
    z = -log(1-(1-a).^(1/M));
%     widths = [.5*ones(1,floor(La/3)) 1*ones(1,La-2*floor(La/3)) 2*ones(1,floor(La/3))];
    hold on;
    for i=1:La
        line([f(1),0.87*f(end)],[z(i),z(i)],'Color','k','LineStyle',styles{ceil(i*3/La)});%,'LineWidth',widths(i));
        text(0.9*f(end),z(i),strcat('\alpha = ',num2str(a(i))),'fontsize',8); %,'fontname','symbol');
%         lgd{i}=strcat('\alpha=',num2str(a(i)));
    end
    if ~isempty(a_usr)
        [tmp,ind] = intersect(a_usr,a);
        a_usr(ind)=[];
        La_usr = length(a_usr);
        z_usr  = -log(1-(1-a_usr).^(1/M));
        for i = 1:La_usr
            line([f(1),0.87*f(end)],[z_usr(i),z_usr(i)],'Color','r','LineStyle',styles{ceil(i*3/La_usr)});%,'LineWidth',widths(i));
            text(0.9*f(end),z_usr(i),strcat('\alpha = ',num2str(a_usr(i))),'fontsize',8); %,'fontname','symbol');
    %         lgd{La+i}=strcat('\alpha=',num2str(a_usr(i)));
        end
    z = [z z_usr];
    end
%     legend(lgd);
    plot(f,P,'k');
    title('Lomb-Scargle normalized periodogram')
    xlabel('f (Hz)'); ylabel('P(f)')
    xlim([0 f(end)]); ylim([0,1.2*max([z'; P])]);
    hold off;
end

end


%% #### Local functions

%% init (initialize) 
function [x,t,hifac,ofac,a,f,fig] = init(x,t,varargin)
    if nargin < 6, a = [];    % set default value for a 
    else           a = sort(varargin{4}); 
                   a = a(:)';
    end
    if nargin < 5, ofac = 4;  % set default value for ofac  
    else           ofac = varargin{3};
    end
    if nargin < 4, hifac = 1; % set default value for hifac 
    else           hifac = varargin{2};
    end
    if nargin < 3, fig = 0;   % set default value for hifac 
    else           fig = varargin{1};
    end

    if isempty(ofac),  ofac  = 4; end
    if isempty(hifac), hifac = 1; end
    if isempty(fig),   fig   = 0; end
    
    if ~isvector(x) ||~isvector(t),
        error('%s: inputs x and t must be vectors',mfilename);
    else
        x = x(:); t = t(:);
        nt = length(t);
        if length(x)~=nt
            error('%s: Inputs x and t must have the same length',mfilename);
        end
    end

    [t,ind] = unique(t);    % discard double entries and sort t
    x = x(ind);
    if length(x)~=nt, disp(sprintf('WARNING %s: Double entries have been eliminated',mfilename)); end

    T = t(end) - t(1);
    nf = round(0.5*ofac*hifac*nt);
    f = (1:nf)'/(T*ofac);    
end

%% extirpolation 
function [wk1,wk2] = extirpolate(t,x,fac,nfreq,MACC)
    nt = length(x);
    wk1 = zeros(2*nfreq,1);
    wk2 = zeros(2*nfreq,1);

    for j = 1:nt 
        ck  = 1 + mod(fix(t(j)*fac),2*nfreq);
        ckk = 1 + mod(2*(ck-1),     2*nfreq);
        wk1 = spread(x(j),wk1,ck, MACC);
        wk2 = spread(1   ,wk2,ckk,MACC);
    end
end

%% spread 
function yy = spread(y,yy,x,m)

    nfac = [1 1 2 6 24 120 720 5040 40320 362880];
    n = length(yy);

    if x == round(x)  % Original Fortran 77 code: ix=x
                      %                           if(x.eq.float(ix)) then...
        yy(x) = yy(x) + y;
    else
        % Original Fortran 77 code: i1 = min(  max( int(x-0.5*m+1.0),1 ), n-m+1  )
        i1 = min([  max([ floor(x-0.5*m+1),1 ]),  n-m+1  ]);
        i2 = i1+m-1;
        nden = nfac(m);
        fac = x-i1;

        fac = fac*prod(x - (i1+1:i2));
        yy(i2) = yy(i2) + y*fac/(nden*(x-i2));

        for j = i2-1:-1:i1
            nden = (nden/(j+1-i1))*(j-i2);
            yy(j) = yy(j) + y*fac/(nden*(x-j));
        end

    end
end
