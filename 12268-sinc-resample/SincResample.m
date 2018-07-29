function [y, Fout]=SincResample(xin, npoints, Fin, shift, mode)
% SincResample resamples signals to arbitrary lengths/frequencies and can
% timeshift them.
%
% SincResample can be faster than INTERP or RESAMPLE when X contains many
% relatively short data columns.
%
%
% Example:
% [Y, FOUT]=SincResample(X, NPOINTS, FIN, SHIFT, MODE)
%
% X is a vector or M x N  matrix where each column represents a signal.
% NPOINTS is the number of points required in each column after
% resampling.
% FIN (if supplied) is the sampling rate in X (default 1 samples/sec).
% SHIFT (if supplied) is the time (in seconds) to shift the points at which
% interpolation will be done (default 0). SHIFT should be between ą(1/Fin).
% SHIFT can be used to synchronize signals separated by up to ą(1/Fin)
% in time.
% MODE (if supplied) is a string:
%           'sinc' to use a hamming-windowed sinc function (default)
%           'lanczos' for a 3-lobed Lanczos function
%
% Y is the resulting M x NPOINTS matrix formed by resampling. The time
% of the first sample in each column of Y is shifted by SHIFT seconds
% relative to those in X.
% FOUT is the effective sample rate for output Y (normalised to FIN=1 if
% FIN is not supplied on input).
%
% If X is a bandlimited (filtered) signal containing components at
% DC - 0.5Fs where Fs is the sample rate, SincResample will return
% the signal that would have been seen with a higher sampling rate
% (and the same filter settings). The algorithm depends on the fact that
% the bandlimited signal is completely defined when sampling at Fs.
%
% SincResample returns the data convolved with a set of  time-shifted
% windowed sinc functions, one for each of the samples [1..size(x,1)]
% in the input signal. End-effects are reduced by adding a reflected 
% and mirrored copy of the data at the beginning and end of each column
% before resampling.
%
% Note that points at the end of Y (and/or beginning if SHIFT is negative)
% will be extrapolated beyond the boundaries of X.
%
% SincResample is a generalization of the method used in Blanche &
% Swindale (2006).
%
% See also e.g. interp & resample (in the Signal Processing Toolbox) and 
% the sinc online documentation.
%
% References:
% T.Blanche & N.V.Swindale (2006)
% Nyquist interpolation improves neuron yield in multiunit recordings
% Journal of Neuroscience Methods 155, 81-91 <a href="http://dx.doi.org/doi:10.1016/j.jneumeth.2005.12.031">LinkOut</a>
%
% also
%
% K. Turkowski, Filters for common resampling tasks <a href="http://www.worldserver.com/turk/computergraphics/ResamplingFilters.pdf">LinkOut</a>
%
% Toolboxes required: None
%
% Author: Malcolm Lidierth 07/06
% Copyright Š Kings College London 2006-8
%
% Acknowledgements: Steve Alty for comments
%
% Revisions: 10.07  Argument checks tidied (ML)
%            02.08  End-effect minimization now relects and mirrors data
%                   instead of simply reflecting it. This improves the 
%                   slopes at the end and reduces the behaviour described at
%                   <a href="http://www.dsprelated.com/showmessage/79676/2.php">http://www.dsprelated.com/showmessage/79676/2.php</a>
%                   (ML)
%            02.08  Mode option added (ML)

% Argument checks
if nargin<2
    y=[];
    Fout=0;
    return
end

if nargin<=2
    % Default
    Fin=1;
end

if nargin<=3
    % Zero shift default
    shift=0;
end

if nargin<=4
    % Set sinc as default
    mode='sinc';
end

if Fin==0
    error('SincResample: Fin specified as zero');
end

if abs(shift)>=1/Fin
    error('SincResample: shift must be less than 1/Fin');
end

if rem(npoints,1)~=0
    error('SincResample: npoints must be a whole number');
end

% Main routine
% Prepend and append a reflected and mirrored copy of the data
% to minimize end transients:
% Change 22.02.08: note change from reflected only

if isvector(xin)
    % Force column vector if row input
    xin=xin(:);
end

x=zeros(size(xin,1)*3, size(xin,2));
for k=1:size(xin,2)
    x(2:end-1,k)=[2*xin(1,k)-xin(end:-1:2,k);...
        xin(:,k);...
        2*xin(end,k)-xin(end-1:-1:1,k)];
    x(1,k)=2*x(1,k)-x(2,k);
    x(end,k)=2*x(end,k)-x(end-1,k);
end
clear('xin');
np=npoints*3;

% A column vector of sample times for x  - assume unit spacing and zero
% base
len=size(x,1);
t=(0:len-1)';

% times at which to interpolate data - based on spacing in t.
% ts will be a [npoints by size(x,1)] matrix
ts=(0:(max(t)+1)/np:(np-1)/(np/len))';
ts=(ts(:,ones(size(t)))-t(:,ones(size(ts)))');

% Hamming window
N=size(ts,2);
if N==1 || strcmp(mode, 'lanczos');
    w=1;
else
    th=ts+N-1;
    w=0.54-0.46*cos((2*pi*th/max(th(:)))) ;
end

% Add shift in multiples of a sampling interval i.e. shift/(1/Fin)
ts=ts+(shift*Fin);

switch mode
    case 'lanczos'
        % Generate Lanczos functions and calculate output
        y=lanczos(ts)*x;
    case 'sinc'
        % Generate sinc functions, apply Hamming window if w~=1 and
        % calculate output.
        y=sinc(ts).*w*x;
    otherwise
        error('mode should be ''sinc'' or ''lanczos''');
end

% Throw away what is not needed
y=y(size(y,1)/3+1:(size(y,1)/3)+(size(y,1)/3),:);
Fout=Fin*npoints/(len/3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEBUG Display the data - UNCOMMENT text below to display results
% x=x(size(x,1)/3+1:(size(x,1)/3)+(size(x,1)/3),:);
% debugdisplay(x, y, Fin, Fout, shift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=sinc(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
i=find(x==0);
x(i)=1;
y=sin(pi*x)./(pi*x);
y(i)=1;
return
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function y=lanczos(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=3;
y=sinc(x).*sinc(x/n);
y(abs(x)>=n)=0;
return
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function debugdisplay(x, y, Fin, Fout, shift) %#ok<DEFNU>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Interp requires the Signal Processing Toolbox. The output of interp will
% be shown if Fout is an integer multiple of Fin.
% Note that shift is not applied to interp
% Sample times in seconds
t1= 0 : 1/Fin : (size(x,1)-1)/Fin;
t2= 0 : 1/Fout : (size(y,1)-1)/Fout;
if rem(Fout,Fin)==0
    y3=interp(x(:,1),Fout/Fin);
    t3=linspace(0,max(t2),size(y3,1));
end
t2=t2+shift;
handle=gca(figure);
xlabel(handle,'Time (seconds)');
for i=1:size(x,2)
    if ~ishandle(handle)
        break;
    end
    if rem(Fout,Fin)==0
        y3=interp(x(:,i),Fout/Fin);
        plot(handle,t1,x(:,i),'-bo',t2,y(:,i),'r-x',t3,y3,'g:s');
        xlim([min([0;min(t2)]) max([max(t3);max(t2);max(t1)])]);
    else
        plot(handle,t1,x(:,i),'-bo',t2,y(:,i),'r-x');
        xlim([min([0;min(t2)]) max([max(t2);max(t1)])]);
    end
    xlabel(handle,'Time (seconds)');
    title('Close the figure window to exit this loop');
    if rem(Fout,Fin)==0
        legend('Original','SincResample','MATLAB Interp (no shift)');
    else
        legend('Original','SincResample');
    end
    drawnow();
    pause(.1);
end
return
end
