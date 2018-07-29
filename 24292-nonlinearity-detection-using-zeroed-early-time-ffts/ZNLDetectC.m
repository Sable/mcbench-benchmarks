function [varargout] = ZNLDetectC(a,t,varargin);
% [Fmat, f, tcalc] = ZNLDetect(a, t);
% [Fmat, f, tcalc] = ZNLDetect(a, t, [tfirst, tlast],fmax,Nt);
%
% Composite FRF version of ZNLDetect.  Finds Composite ZEFFTs of a matrix 
% of timehistories a = (Nt x No) where Nt is the number of time instants 
% and No the number of measurements.
%
% 
% User inputs
%   a   matrix of time histories (Nt x No)
%   t   time vector (Nt x 1) or (1 x Nt)
% Optional inputs
%   tfirst    the beginning time after which zero crossings are looked for
%   tlast     the time after which no more ffts will be calculated
%   Nt        number of zero crossings to find
%   fmax      maximum frequency to display in plots of the Composite ZEFFTs
% 
% Outputs
%   Fmat    each column is one of the ffts
%   tcalc   a row vector in which each time is the beginning zero crossing for
%           the associated fft column in Fmat (all ordinates before tcalc are zero)
%   indtcalc         the index of time for each tcalc
%   amat      each column is the Response time history zerod out up to ts_zc
%
% By Randy L. Mayes
% Modified by Matt S. Allen (July 2005)
%
% This function is not fully developed and may contain bugs - MSA 2009.
%

tfirst = []; fmax = []; Nt = 20;
if nargin > 4; Nt = varargin{3}; end
if nargin > 3; fmax = varargin{2}; end
if nargin > 2; tspan = varargin{1}; tfirst = tspan(1); tlast = tspan(end); end

if size(a,1) ~= length(t) && size(a,2) == length(t);
    a = a.';
end
if size(a,1) ~= length(t);
    error('Sizes of a and t are not compatible');
end

% Initial Plot of data & Start and Stop Times
figure(101)
plot(t,a(:,1),'.-'); grid on;
xlabel('Time (s)');
ylabel('Response @ 1st sensor');

if isempty(tfirst);
    tfirst = input('Input start time (tfirst) ')
    tlast = input('Input end time (tlast) ')
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

% % Beginning of Algorithm
% %   First find the times for zero crossings
% ts_zc(1)=t(1);    %   The first fft will be for the entire time history
% indts_zc(1)=1;
istart = find(t<=tfirst,1,'last');    % Find the first index to start looking for 0 crossings
if isempty(istart);
    warning(['Time vector starts after tstart = ',num2str(tfirst),' Using tstart = ',num2str(t(1))]);
    istart = 1;
end
ilast = find(t<=tlast,1,'last');      % Find the last index to look for 0 crossings
if isempty(ilast);
    warning(['Time vector starts after tstart = ',num2str(tlast),' Using tstart = ',num2str(t(end))]);
    ilast = length(t);
end
% astart=a(istart);
% %   This finds out whether the data starts out positive or negative
%     flag = sign(astart);
%         % assign 0 a positive sign.
%         if flag == 0; flag = 1; end
% 
% %   This loop finds all the zero crossings
%     ncross = 2;    %  This initializeds the next value index for ts_zc
%     for k = (istart + 1):ilast
%         metric = flag*a(k);
%         if metric < 0  % this is the zero crossing catcher
%             indts_zc(ncross) = k;  % this is the index of t for the zero crossing
%             ts_zc(ncross)=t(k);
%             flag=-flag;
%             ncross=ncross+1;
%         else
%         end
%     end
%     lts_zc=length(ts_zc);   %  This is the number of ffts to do
%     %   Now FFT the entire time signal for column 1 of Fmat
%     Fmat=zeros(length(a),lts_zc);
%     amat=Fmat;
%     amat(:,1)=a;
%     for k=2:lts_zc
%         amat(:,k)=a;
%         amat(1:indts_zc(k),k)=0;
%     end
%     Fmat=fft(amat);
    
%   Alternate Approach - Find FFT for arbitrary start times, evenly spaced
%   between the first and last times found previously
    delta_edistind = round(( ilast - istart )/Nt);
    edistind = istart:delta_edistind:ilast;
    ts_edist = vec(t(edistind));

%   FFT for evenly distributed indices
    amat_ed = zeros(size(a,1),size(a,2),length(edistind));
    amat_ed(:,:,1)=a;
    for k=2:length(edistind)
        amat_ed(:,:,k)=a;
        amat_ed(1:edistind(k),:,k)=0;
    end
    A_ed_all=fft(amat_ed,[],1);
    
    % Form composite for the following plots
    A_ed = zeros(size(A_ed_all,1),size(A_ed_all,3));
    for k = 1:size(A_ed_all,3);
        A_ed(:,k) = comp_FRF(A_ed_all(:,:,k));
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plotting and Visualization
% Add points to previous figure showing zero crossings & truncation points
% line(t(indts_zc),a(indts_zc),'LineStyle','None','Marker','o','Color','r');
line(t(edistind),a(edistind),'LineStyle','None','Marker','^','Color','g');
legend('Response','Eq. Dist. Pts');

figure(103); clf(gcf);% set(gcf,'Position', [75    26   560   420]);
cols = jet(size(A_ed,2));
for k = 1:size(A_ed,2);
    hl_ed(k) = line(freq,abs(A_ed(1:lfreq,k)),'Color',cols(k,:));
end
set(gca,'YScale','Log'); grid on;
%semilogy(freq,abs(A_ed(1:lfreq,:)))
%eval(['title(jt4_4.accel(',int2str(aval),').title)']);
xlabel('\bfFrequency - Hz'); ylabel('\bfMagnitude');
title('\bfNLDetect:  FFT of Time Response - Truncated at evenly distributed points)');
% Skip entries if legend is very long
    if length(ts_edist) < 7
        ts_edists=num2str(ts_edist);
        legend(ts_edists)
    else
        nskip = round(length(ts_edist)/7);
        ts_edists = num2str(ts_edist(1:nskip:end));
        legend(hl_ed(1:nskip:end),ts_edists);
    end
    
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Integral measures - single number or single curve indicators:
% fbandA_ed = find(freq <= fmax);
% % fbandB_ed = find(F_ed <= fmax);
% IntA_ed = sum(A_ed(fbandA_ed,:).*conj(A_ed(fbandA_ed,:)),1)*(freq(2)-freq(1));
% % IntB_ed =
% % sum(B_ed(fbandB_ed,:).*conj(B_ed(fbandB_ed,:)),1)*(F_ed(2)-F_ed(1));
% 
% figure(300)
% hls = semilogy(ts_edist,IntA_ed/max(IntA_ed)); % ,T_ed,IntB_ed/max(IntB_ed)
% xlabel('Time (s)'); ylabel('Integral');
% title('Normalized Integrals of Spectra vs. Start time');
% legend('FFT Eq. Dist'); % ,'WFFT Eq. Dist'
% set(hls,'Marker','.');
% 
% % Second Integral measure: Area under curve on a log plot
% IntA_ed2 = ( sum(log10(A_ed(fbandA_ed,:).*conj(A_ed(fbandA_ed,:))),1)*(freq(2)-freq(1)) ).';
% % IntB_ed2 = ( sum(log10(B_ed(fbandB_ed,:).*conj(B_ed(fbandB_ed,:))),1)*(F_ed(2)-F_ed(1)) ).';
%     
%     % Derivative
%     IntA_ed2d = diff(IntA_ed2).*ts_edist(1:end-1);
% %     IntB_ed2d = diff(IntB_ed2).*T_ed(1:end-1);
% 
% figure(301)
% % subplot(2,1,1)
% hls = plot(ts_edist,IntA_ed2/max(IntA_ed2)); %,T_ed,IntB_ed2/max(IntB_ed2)
% xlabel('Time (s)'); ylabel('Integral');
% title('Area under Log Magnitude curves vs. Start time');
% legend('FFT Eq. Dist'); % ,'WFFT Eq. Dist'
% set(hls,'Marker','.');
% % subplot(2,1,2)
% % hls = plot(ts_edist(1:end-1),IntA_ed2d,T_ed(1:end-1),IntB_ed2d);
% % xlabel('Time (s)'); ylabel('d/dtstart(Integral)');
% % title('Area under Log Magnitude curves vs. Start time');
% % legend('FFT Eq. Dist','WFFT Eq. Dist');
% % set(hls,'Marker','.');
% 

if nargout > 0
    varargout = {A_ed, freq, ts_edist};
end