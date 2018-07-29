function [varargout] = ZNLDetect(a,t,varargin);
% [Fmat, f, ts_zc] = ZNLDetect(a, t);
% or
% ZNLDetect(a, t);
%
% Nonlinearity detection scheme based on zeroing the initial time response
% over various intervals and computing the FFT of each, as described in: M.
% S. Allen and R. L. Mayes, "Estimating the Degree of Nonlinearity in 
% Transient Responses with Zeroed Early-Time Fast Fourier Transforms," in 
% International Modal Analysis Conference Orlando, Florida, 2009.
%
% It works by deleting the beginning of the time history up to some zero 
% crossing and then taking the FFT.  In this way one can see when certain 
% features in the frequency domain drop out in time.  This is quite
% different than most time-frequency methods such as wavelets because the
% initial response is zeroed rather than nullified using a window.  ZEFFTs 
% are especially  effective if nonlinear events occur very early and decay
% in only a few cycles, such as macroslip of a joint due to impulsive loading.  
% 
% User inputs
%   a   time history vector (Nt x 1) or (1 x Nt)
%   t   time vector (Nt x 1) or (1 x Nt)
%
% Optional inputs
% [Fmat, f, ts_zc] = ZNLDetect(a, t, [tfirst, tlast], fmax, nz_skip);
%
%   [tfirst, tlast] - the time interval that will be searched for zero
%       crossings.
%   fmax - the maximum frequency that will be retained in the FFTs.
%   nz_skip - number of zero crossings to skip when storing and plotting
%       ZEFFTs.  For example, if nz_skip = 5, every 5th zero crossing will
%       be retained.
% 
% Outputs
%   Fmat - each column is one of the ffts
%   f - frequency vector for Fmat
%   ts_zc - times where zeroing ends for each column of Fmat
%
%   A menu also appears on Figure 102 entitled Fit-Extrap, containing the
%   following options.  All of these work by having the user first select a
%   line of interest on the plot using the plot's arrow tool, then choosing
%   one of the following features.
%       AMI Fit - fit a modal model to the active line using the AMI
%       algorithm.  Select "Finished" on the AMI menu when done to return
%       to the figure.
%       SSI Fit - fit a modal model to the active line using the SSI 
%           algorithm by Van Overschee & De Moor.  Some filtering has been 
%           added to attempt to eliminate spurious modes, but this feature
%           does not always work perfectly.
%       BEND: Extrapolate - extrapolate the curve fit, either backwards or 
%           forwards in time to the time of the selected line.  For
%           example, if you fit the FFT starting at 30 ms, you could select
%           a line at 0 ms, or at 50 ms and use this to see what the zeroed 
%           FFT should have been at those times if the system behaved linearly.
%       Clear Lines - Use this feature to clear all of the lines from
%           the plot except the curve fit and the measurement and any pairs
%           of measured and extrapolated lines.
%       IBEND: Integral Metric - Compute the integral metric IBEND
%           described in the paper.
%       Show Line Info - prints the number and start time of the selected
%       	line to the command window.
%
% A plot of ZEFFTs computed using equally distributed points is also
% generated, but it is not currently used for curve-fitting or
% extrapolation.
%
% Original algorithm by Randy L. Mayes, rlmayes@sandia.gov
% Modified by Matt S. Allen (July 2005-May 2009), msallen@engr.wisc.edu
%

tfirst = []; fmax = [];
if nargin > 3
    fmax = varargin{2};
    if nargin > 2;
        tspan = varargin{1};
        tfirst = tspan(1); tlast = tspan(end);
    end
end
if nargin > 4
    nz_skip = varargin{3};
else
    nz_skip = 1;
end
if nargin > 5
    %
end

if length(a) ~= length(t);
    error('Sizes of a and t are not compatible');
end

% Initial Plot of data & Start and Stop Times
time_sf = 1000;
figure(101); set(gcf,'Name','Time Response');
plot(t*time_sf,a,'.-'); grid on;
xlabel('\bfTime (ms)');
ylabel('\bfResponse');

if isempty(tfirst);
    tfirst = input('Input time to start looking for zero crossings (tfirst) ')
    tlast = input('Input time to stop looking for zero crossings (tlast) ')
end
%title('PICK RANGE FOR ANALYSIS!');
%[tpicks,apicks] = ginput(2);
%    Calculate the frequency vector for fft displays

% Frequencies to Compute
    delf=1/((t(2)-t(1))*length(t));
    disp(['Nyquist Frequency = ',num2str(delf*length(t)/2)]);
    if isempty(fmax);
        fmax=input('Input highest frequency to plot ');
    end
    freq=0:delf:fmax;freq=freq';
    lfreq=length(freq);

% Beginning of Algorithm
%   First find the times for zero crossings
ts_zc(1)=t(1);    %   The first fft will be for the entire time history
indts_zc(1)=1;
istart = max(find(t<=tfirst));    % Find the first index to start looking for 0 crossings
ilast = max(find(t<=tlast));      % Find the last index to look for 0 crossings
astart=a(istart);
%   This finds out whether the data starts out positive or negative
    flag = sign(astart);
        % assign 0 a positive sign.
        if flag == 0; flag = 1; end
%   This loop finds all the zero crossings
    ncross = 2;    %  This initializeds the next value index for ts_zc
    for k = (istart + 1):ilast
        metric = flag*a(k);
        if metric < 0  % this is the zero crossing catcher
            indts_zc(ncross) = k;  % this is the index of t for the zero crossing
            ts_zc(ncross)=t(k);
            flag=-flag;
            ncross=ncross+1;
        else
        end
    end
    % Discard some of the zero crossings if desired
    length(ts_zc)
        ts_zc = ts_zc(1:nz_skip:end);
        indts_zc = indts_zc(1:nz_skip:end);
        if isempty(ts_zc);
            error('No Crossings:  Number of zero crossings to skip too large, or time interval to search too small');
        end
    lts_zc=length(ts_zc);   %  This is the number of ffts to do
%   Alternate Approach - Find FFT for arbitrary start times, evenly spaced
%   between the first and last times found previously
    delta_edistind = round((indts_zc(end)-indts_zc(1))/length(indts_zc));
    edistind = indts_zc(2):delta_edistind:indts_zc(end);
    ts_edist = t(edistind); ts_edist = ts_edist(:);
%   Now FFT the entire time signal for column 1 of Fmat
    Fmat=zeros(length(a),lts_zc);
    amat=Fmat;
    amat(:,1)=a;
    for k=2:lts_zc
        amat(:,k)=a;
        amat(1:indts_zc(k),k)=0;
    end
    Fmat=fft(amat);
%   Repeat for evenly distributed indices
    Fmat_ed=zeros(length(a),length(edistind));
    amat_ed=Fmat_ed;
    amat_ed(:,1)=a;
    for k=2:length(edistind)
        amat_ed(:,k)=a;
        amat_ed(1:edistind(k),k)=0;
    end
    Fmat_ed=fft(amat_ed);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting and Visualization
% Add points to previous figure showing zero crossings & truncation points
line(t(indts_zc)*time_sf,a(indts_zc),'LineStyle','None','Marker','o','Color','r');
% line(t(edistind)*time_sf,a(edistind),'LineStyle','None','Marker','^','Color','g');
legend('Response','Zero Pts');%,'Eq. Dist. Pts');

% Check that the response is close to zero at these crossing points
if any(abs(a(indts_zc)) > 0.2*max(abs(a)));
    warning('RESPONSE HAS LARGE AMPLITUDE NEAR SOME ZERO CROSSINGS');
end

figure(102); clf(gcf);  set(gcf,'Name','TFFT Zeros');
set(gcf,'Units', 'normalized', 'Position', [0.166,0.15,0.691,0.762])
cols = jet(size(Fmat,2));
for k = 1:size(Fmat,2);
    hl(k) = line(freq,abs(Fmat(1:lfreq,k)),'Color',cols(k,:),'UserData',k);
end
set(gca,'YScale','Log'); grid on;
%semilogy(freq,abs(Fmat(1:lfreq,:)))
xlabel('\bfFrequency (Hz)'); ylabel('\bfMagnitude');
title('\bfNLDetect: FFT of Time Response - Truncated at zero points');
% Skip entries if legend is very long
    if length(ts_zc) < 7
        ts_zcs=num2str(ts_zc'*1e3,4);
        legend(ts_zcs)
    else
        nskip = round(length(ts_zc)/7);
        ts_zcs = num2str(ts_zc(1:nskip:end).'*1e3,4);
        legend(hl(1:nskip:end),ts_zcs);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Create global variables so curve fitting and backwards extrapolating
    % functions can use this data.
    global ZNLD
    ZNLD.ws = freq*2*pi;
    ZNLD.ts_zc = ts_zc;
    ZNLD.Hmat = Fmat(1:lfreq,:);
    for k = 1:size(ZNLD.Hmat,2); % Remove phase delay so this can be curve fit.
        ZNLD.Hmat(:,k) = ZNLD.Hmat(:,k).*exp(i*ZNLD.ws*ZNLD.ts_zc(k));
    end
    % Add time records for SSI
    ZNLD.a = a;
    ZNLD.t = t;

    % Create Menu to fit and extrapolate
        hf = gcf;
        huimenu(1) = uimenu(hf,'Label','Fit-Extrap','enable','on');
        huimenu(2) = uimenu(huimenu(1),'Label','AMI Fit','Callback', ...
            ['ZNLD_CF;']);
        huimenu(3) = uimenu(huimenu(1),'Label','SSI Fit','Callback', ...
            ['ZNLD_SSICF;']);
        huimenu(4) = uimenu(huimenu(1),'Label','BEND: Extrapolate','Callback', ...
            ['ZNLD_BE;']); 
        huimenu(5) = uimenu(huimenu(1),'Label','Clear Lines','Callback', ...
            ['ZNLD_ClearLines;']);
        huimenu(6) = uimenu(huimenu(1),'Label','IBEND: Integral Metric','Callback', ...
            ['ZNLD_Metric;']);
        huimenu(7) = uimenu(huimenu(1),'Label','Show Line Info','separator','on',...
            'Callback', ['ZNLD_LineInfo;']);
        
        % Misc. Settings:
        format short g
        format compact
    
figure(103); clf(gcf); set(gcf,'Name','TFFT Eq. Dist');
% set(gcf,'Position', [75    26   560   420]);
cols = jet(size(Fmat_ed,2));
for k = 1:size(Fmat_ed,2);
    hl_ed(k) = line(freq,abs(Fmat_ed(1:lfreq,k)),'Color',cols(k,:));
end
set(gca,'YScale','Log'); grid on;
%semilogy(freq,abs(Fmat_ed(1:lfreq,:)))
%eval(['title(jt4_4.accel(',int2str(aval),').title)']);
xlabel('\bfFrequency (Hz)'); ylabel('\bfMagnitude');
title('\bfNLDetect:  FFT of Time Response - Truncated at evenly distributed points)');
% Skip entries if legend is very long
    if length(ts_edist) < 7
        ts_edists=num2str(ts_edist*1e3,4);
        legend(ts_edists)
    else
        nskip = round(length(ts_edist)/7);
        ts_edists = num2str(ts_edist(1:nskip:end)*1e3,4);
        legend(hl_ed(1:nskip:end),ts_edists);
    end

figure(102); % make this one current.
    
if nargout > 0
    % Correct phases on "Fmat" so that it can be curve fit if desired
    Fmat = Fmat(1:lfreq,:);
    for k = 1:size(Fmat,2);
        Fmat(:,k) = Fmat(:,k).*exp(i*freq*2*pi*ts_zc(k));
    end
    varargout = {Fmat, freq, ts_zc};
end