function [rt60,drr,cte,cfs] = IR_stats(filename,varargin)
% Calculate RT, DRR, and Cte for impulse response file
% 
%   rt60 = IR_stats(filename)
%   [rt60,drr] = IR_stats(filename)
%   [rt60,drr,cte] = IR_stats(filename)
%   ... = IR_stats(...,graph)
%   ... = IR_stats(...,te)
%   ... = IR_stats(...,spec)
% 
%   rt60 = IR_stats(filename) returns the reverberation time
%   (to -60 dB) using a method based on ISO 3382 (2000). The
%   function uses reverse cumulative trapezoidal integration
%   to estimate the decay curve, and a linear least-square
%   fit to estimate the slope between -5 dB and -35 dB. The
%   RT60 is estimated from the gradient of the slope.
%   Estimates are taken in octave bands and the overall
%   figure is an average of the 500 Hz and 1 kHz bands.
% 
%   The function attempts to identify the direct impulse as
%   the peak of the squared impulse response.
% 
%   filename should be the full path to a wave file or the
%   name of a wave file on the Matlab search path. The file
%   can have any number of channels, estimates (and plots)
%   will be returned for each channel.
% 
%   [rt60,drr] = IR_stats(filename) returns the DRR for the
%   impulse. This is calculated in the following way:
%   
%   DRR = 10 * log10( x(t0-c:t0+c)^2 / x(t0+c+1:end)^2 )
% 
%   where x is the approximated integral of the impulse, t0
%   is the time of the direct impulse, and c=0.25ms.
% 
%   [rt60,drr,cte] = IR_stats(filename) returns the
%   early-to-late index Cte for the impulse. This is
%   calculated in the following way:
%   
%   Cte = 10 * log10( x(t0-c:t0+te)^2 / x(t0+te+1:end)^2 )
% 
%   where x is the approximated integral of the impulse and
%   te is a point 50 ms after the direct impulse.
% 
%   [rt60,drr,cte,cfs] = IR_stats(filename) returns the
%   octave-band centre frequencies used in the calculations.
% 
%   ... = IR_stats(...,graph), by setting graph=true, allows
%   graphs of the impulse response, decay curves, and linear
%   least-square fits, to be plotted for each octave band
%   and channel of the wave file.
% 
%   ... = IR_stats(...,te) allows the early time limit to be
%   specified (in seconds). The default is 0.05.
% 
%   ... = IR_stats(...,spec) determines the RT60 output by
%   the function. With spec='mean' (default) the reported
%   RT60 is the mean of the 500 Hz and 1 kHz bands. With
%   spec='full', the function returns the RT60 as calculated
%   for each octave band returned in cfs.
% 
%   Octave-band filters are calculated according to ANSI
%   S1.1-1986 and IEC standards. Note that the OCTDSGN
%   function recommends centre frequencies fc in the range
%   fs/200 < fc < fs/5.
% 
%   See also OCTDSGN.

% !---
% ==========================================================
% Last changed:     $Date: 2013-07-14 18:11:38 +0100 (Sun, 14 Jul 2013) $
% Last committed:   $Revision: 255 $
% Last changed by:  $Author: ch0022 $
% ==========================================================
% !---

% check file exists
assert(exist(filename,'file')==2,['IR_stats: ' filename ' does not exist'])

graph = find_inputs(@(x)(isscalar(x) & islogical(x)),varargin,...
    'Unknown parameter specified.');

te = find_inputs(@(x)(isscalar(x) & isnumeric(x)),varargin,...
    'Unknown parameter specified.');

spec = find_inputs(@ischar,varargin,...
    'Unknown parameter specified.');

if isempty(graph)
    graph = false;
end

if isempty(spec)
    spec = 'mean';
end

% octave-band center frequencies
cfs = [31.25 62.5 125 250 500 1000 2000 4000 8000 16000];

% octave-band filter order
N = 3;

% read in impulse
[x,fs] = audioread(filename);
assert(fs>=5000,'Sampling frequency is too low. FS must be at least 5000 Hz.')

% set te in samples
if isempty(te)
    te = round(0.05*fs);
else
    te = round(te*fs);
end

% Check sanity of te
assert(te<length(x),'The specified early time limit te is longer than the duration of the impulse!')

% get number of channels
numchans = size(x,2);

% limit centre frequencies so filter coefficients are stable
cfs = cfs(cfs>fs/200 & cfs<fs/5);
cfs = cfs(:);

% calculate filter coefficients
a = zeros(length(cfs),(2*N)+1);
b = zeros(length(cfs),(2*N)+1);
for f = 1:length(cfs)
    [b(f,:),a(f,:)] = octdsgn(cfs(f),fs,N);
end

% empty matrix to fill intergrations
z = zeros([length(cfs) size(x)]);
rt = zeros([length(cfs) numchans]);
t0 = zeros(1,numchans);
drr = zeros(1,numchans);
cte = zeros(1,numchans);

correction = round(0.00025*fs);

% filter and integrate
for n = 1:numchans
    t0(n) = find(x(:,n).^2==max(x(:,n).^2)); % find direct impulse
    if graph
        scrsz = get(0,'ScreenSize');
        figpos = [((n-1)/numchans)*scrsz(3) scrsz(4) scrsz(3)/2 scrsz(4)];
        figure('Name',['Channel ' num2str(n)],'OuterPosition',figpos);
    end
    for f = 1:length(cfs)
        y = filter(b(f,:),a(f,:),x(:,n)); % octave-band filter
        temp = cumtrapz(y(end:-1:1).^2); % energy decay
        z(f,:,n) = temp(end:-1:1);
        [rt(f,n),E,fit] = calc_rt(z(f,t0:end,n),fs); % estimate RT
        if graph % plot
            ty = ((0:length(y)-1)-t0(n))./fs; % time
            tE = (0:length(E)-1)./fs; % time
            subplot(length(cfs),2,(2*f)-1)
            plot(ty,y,'k') % octave-band impulse
            if f==1
                title({'Impulse response'; ''; [num2str(cfs(f)) ' Hz octave band']})
            else
                title([num2str(cfs(f)) ' Hz octave band'])
            end
            if f==length(cfs)
                xlabel('Time [s]')
            else
                set(gca,'xticklabel',[]);
            end
            ylabel('Amplitude')
            set(gca,'position',[1 1 1 1.05].*get(gca,'position'),'xlim',[min(ty) max(ty)]);
            subplot(length(cfs),2,2*f)
            plot(tE,E,'k',tE,fit,'--r') % energy decay and linear least-square fit
            if f==1
                title({'Decay curve'; ''; [num2str(cfs(f)) ' Hz octave band']})
            else
                title([num2str(cfs(f)) ' Hz octave band'])
            end
            if f==length(cfs)
                xlabel('Time [s]')
            else
                set(gca,'xticklabel',[]);
            end
            ylabel('Energy [dB]')
            set(gca,'position',[1 1 1 1.05].*get(gca,'position'),'ylim',[-60 0],'xlim',[0 max(tE)]);
            legend('Energy decay curve','Linear least-square fit','location','northeast')
        end
    end
    if nargout>=2
        drr(n) = 10.*log(...
            trapz(x(max(1,t0(n)-correction):t0(n)+correction,n).^2)/...
            trapz(x(t0(n)+correction+1:end,n).^2)...
            ); % DRR
    end
    if nargout>=3
        if t0(n)+te+1>size(x,1)
            warning(['Early time limit (te) out of range in channel ' num2str(n) '. Try lowering te.'])
            cte(n) = NaN;
        else
            cte(n) = 10.*log(...
                trapz(x(max(1,t0(n)-correction):t0(n)+te).^2)/...
                trapz(x(t0(n)+te+1:end,n).^2)...
                ); % Cte
        end
    end
end

switch lower(spec)
    case 'full'
        rt60 = rt;
    case 'mean'
        rt60 = mean(rt(cfs==500 | cfs==1000,:)); % overall RT60
    otherwise
        error('Unknown spec: must be ''full'' or ''mean''.')
end

% ----------------------------------------------------------
% Local functions:
% ----------------------------------------------------------

% ----------------------------------------------------------
% calc_rt: calculate RT from decay curve
% ----------------------------------------------------------

function [rt,E,fit] = calc_rt(E,fs)

ydb = [-5,-35]; % dB range for calculating RT

E = 10.*log10(E); % put into dB
E = E-max(E); % normalise to max 0
E = E(1:find(isinf(E),1,'first')-1); % remove trailing infinite values
IX = find(E<=ydb(1),1,'first'):find(E<=ydb(2),1,'first'); % find ydb x-range

% calculate fit over ydb
x = reshape(IX,1,length(IX));
y = reshape(E(IX),1,length(IX));
p = polyfit(x,y,1);
fit = polyval(p,1:length(E));
fit2 = fit-max(fit);

diff_y = abs(diff(ydb)); % dB range diff
rt = (60/diff_y)*find(fit2<=-diff_y,1,'first')/fs; % estimate RT

% ----------------------------------------------------------
% find_inputs: validate and provide inputs (if any)
% ----------------------------------------------------------
function varargout = find_inputs(fhandle,input,msg)

indices = cellfun(fhandle,input);

if any(indices) % inputs are specified
    if sum(indices)~=nargout
        error(msg) % return error message
    end
    varargout(1:nargout) = input(indices);
else % unspecified returns empty matrix
    varargout(1:nargout) = {[]};
end

% [EOF]
