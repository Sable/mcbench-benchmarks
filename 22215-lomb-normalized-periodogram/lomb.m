function [P,f,alpha] = lomb(x,t,varargin)
% LOMB caculates the Lomb normalized periodogram (aka Lomb-Scargle, Gauss-Vanicek or Least-Squares spectrum) of a vector x with coordinates in t. 
%   The coordinates need not be equally spaced. In fact if they are, it is
%   probably preferable to use PWELCH or SPECTRUM. For more details on the
%   Lomb normalized periodogram, see the excellent section 13.8 in [1], pp.
%   569-577.
%
%   This code is a transcription of the Fortran subroutine period in [1]
%   (pp.572-573). The calculation of the Lomb normalized periodogram is in
%   general a slow procedure. Matlab's characteristics have been taken into
%   account in order to make it fast for Matlab but still it is quite slow. 
%   For a faster (but not exact) version see FASTLOMB. 
%
%   If the 'fig' flag is on, the periodogram is created, along with some
%   default statistical significance levels: .001, .005, .01, .05, .1, .5.
%   If the user wants more significance levels, they can give them as input
%   to the function. Those will be red. 
%
% SYNTAX
%   [P,f,alpha] = lomb(x,t,fig,hifac,ofac,a);
%   [P,f,alpha] = lomb(x,t,fig,hifac,ofac);
%   [P,f,alpha] = lomb(x,t,fig,hifac);
%   [P,f,alpha] = lomb(x,t,fig);
%   [P,f,alpha] = lomb(x,t);
%
% INPUTS
%   x:     the vector whose spectrum is wanted.
%   t:     coordinates of x (should have the same length).
%   fig:   if 0 (default), no figure is created.
%   hifac: the maximum frequency returned is 
%               (hifac) x (average Nyquist frequency)
%          See "THE hifac PARAMETER" in the NOTES section below for more
%          details on the hifac parameter. Default is 1 (i.e. max frequency
%          is the Nyquist frequency)
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

[x,t,hifac,ofac,a_usr,f,fig] = init(x,t,varargin{:});
nf = length(f);

mx = mean(x);
x  = x-mx;
vx = var(x);    
if vx==0, error('%s: x has zero variance',upper(mfilename)); end


%% Main

P = zeros(nf,1);
for i=1:nf      
    wt  = 2*pi*f(i)*t;  % \omega t
    swt = sin(wt);
    cwt = cos(wt);

    %% Calculate \omega\tau and related quantities
    % I use some trigonometric identities to reduce the computations
    Ss2wt = 2*cwt.'*swt;            % \sum_t \sin(2\omega\t)
    Sc2wt = (cwt-swt).'*(cwt+swt);  % \sum_t \cos(2\omega\t)
    wtau  = 0.5*atan2(Ss2wt,Sc2wt);  %\omega\tau

    swtau = sin(wtau); 
    cwtau = cos(wtau);

    % I use some trigonometric identities to reduce the computations
    swttau = swt*cwtau - cwt*swtau;  % \sin\omega(t-\tau))
    cwttau = cwt*cwtau + swt*swtau;  % \cos\omega(t-\tau))

    P(i) = ((x.'*cwttau)^2)/(cwttau.'*cwttau) + ((x.'*swttau)^2)/(swttau.'*swttau);
end
P = P/(2*vx);

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
    hold on;
    for i=1:La
        line([f(1),0.87*f(end)],[z(i),z(i)],'Color','k','LineStyle',styles{ceil(i*3/La)});
        text(0.9*f(end),z(i),strcat('\alpha = ',num2str(a(i))),'fontsize',8); 
%         lgd{i}=strcat('\alpha=',num2str(a(i)));
    end
    if ~isempty(a_usr)
        [tmp,ind] = intersect(a_usr,a);
        a_usr(ind)=[];
        La_usr = length(a_usr);
        z_usr  = -log(1-(1-a_usr).^(1/M));
        for i = 1:La_usr
            line([f(1),0.87*f(end)],[z_usr(i),z_usr(i)],'Color','r','LineStyle',styles{ceil(i*3/La_usr)});
            text(0.9*f(end),z_usr(i),strcat('\alpha = ',num2str(a_usr(i))),'fontsize',8); 
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
