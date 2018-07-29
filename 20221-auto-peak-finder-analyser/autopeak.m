function [output] = autopeak(x,y)

% AUTO PEAK FINDER & ANALYSER
%
% Automatically finds major peaks, their locations, fwhms
% and area in a given signal y versus x. The output is
% a matrix with peaks sorted in rows and following columns:
%
% output = peak No. | peak Y | peak X | peak fwhm | peak area
%
% martin.gorjan@fotona.com; june 2008


% INITIALIZATION

% set detection sensitivity parameters
% the golden ratio seems to work exceptionally fine :)
nfwhms = 1.6180;
nstds = 1.6180;

% put signal to columns if not so yet
shape = size(x);
if shape(2) > 1
    x = x';
end
shape = size(y);
if shape(2) > 1
    y = y';
end

% smooth signal, determine its baseline and detection threshold
y = smooth(y);
base(1) = mean(y);
threshold = nstds * std(y);

% plot the signal
plot(x,y);
hold on;


% PEAK DETECTION RUNDOWN

% hunt the peaks down one by one and measure them
% then eliminate them from signal and repeat until threshold

for i = 1 : length(x)

    % determine peak by global maximum
    [peaki, ipeak] = max(y);
    
    % check if big enough, else stop
    if peaki < threshold
        break
    end
          
    % save the peak and plot it
    peak(i) = peaki;
    loc(i) = x(ipeak);
    plot(loc(i),peak(i),'ro');

    % determine fwhm
    % by shifting signal twice and locating minimas on both sides
    % do it in two steps: using global baseline (j=1) and fwhm-based local baseline (j=2)
    for j = 1 : 2
        
        % compute shifted signal by peak-baseline points
        y_shift = abs(y - (peak(i) + base(j))/2);
        x_shift = abs(x - loc(i));
        y_shift2 = y_shift + x_shift * peak(i)/max(x_shift);

        % determine both fwhm points on shifted signal by sequential elimination 
        [y_temp, ifwhms(1)] = min(y_shift2);
        y_shift2(ifwhms(1)-1:ifwhms(1)+1) = y_shift2(ifwhms(1)-1:ifwhms(1)+1) + peak(i);
        [y_temp, ifwhms(2)] = min(y_shift2);
        
        % compute index fwhm difference and fwhm
        idfwhms = abs(diff(ifwhms));
        indfwhms = floor(nfwhms*idfwhms);
        fwhm(i) = abs(x(ifwhms(2)) - x(ifwhms(1)));
    
        % compute fwhm-based guess for local baseline
        base(j+1) = (y(ipeak-indfwhms) + y(ipeak+indfwhms))/2;
    end
    
    % recompute peak value with local baseline
    peak(i) = y(ipeak) - base(j);

    % calculate total power in peak with local baseline
    y_temp = y - base(j);
    peakint(i) = sum(y_temp(ipeak-idfwhms:ipeak+idfwhms)) * diff(x(1:2));
    
    % plot the area under the peak
    for k = 0:idfwhms
        plot([x(ipeak-k),x(ipeak-k)],[base(j),y(ipeak-k)],'r');
        plot([x(ipeak+k),x(ipeak+k)],[base(j),y(ipeak+k)],'r');
    end
           
    % eliminate the peak from signal for rundown to proceed
    y_temp = zeros(length(y),1);
    y_temp(ipeak-indfwhms:ipeak+indfwhms) = y(ipeak-indfwhms:ipeak+indfwhms);
    y = y - y_temp;    
end

hold off;


% OUTPUT PREPARATION

% create nice output matrix, sort peaks by location order and number them
output(:,2) = peak';
output(:,3) = loc';
output(:,4) = fwhm';
output(:,5) = peakint';
output = sortrows(output,3);
output(:,1) = (1:length(peak))';