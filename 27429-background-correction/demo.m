% DEMO  Demo for using pogram BACKCOR for background (or baseline) correction.
% 12-November-2012.
% Comments and questions to: vincent.mazet@unistra.fr.


clear all;
close all;

%% First, let's start with a simulated spectrum
%  The simulated spectrum is the sum of Gaussian peaks, a background and Gaussian noise.

% Wavelength
N = 512;                                % Signal length
n = (rand(N,1)*500+400);                % Non-uniform & non-sorted wavelengths
m = (n-min(n))/(max(n)-min(n));         % Normalized wavelengths (between -1 and 1)

% Peaks
sigx = 1;                               % Peak amplitude deviation
sigw = 0.01;                            % Peak width deviation
K = ceil(abs(randn(1)*10));             % Peak number
c = rand(K,1);                          % Peak positions
a = abs(randn(K,1) * sigx);             % Peak amplitudes
w = abs(randn(K,1) * sigw);             % Peak widths
nn = repmat(m',K,1);
cc = repmat(c,1,N);
aa = repmat(a,1,N);
ww = repmat(w,1,N);
peaks = aa.*exp(-(nn-cc).^2/2./ww.^2);  % Gaussian peaks

% Background
o = floor(rand(1)*2) + 4;               % Polynomial order for the simulated background
a = randn(o+1,1);                       % Polynomial coefficients
p = (0:o)';
mm = repmat(m',o+1,1);
aa = repmat(a,1,N);
pp = repmat(p,1,N);
z = aa .* mm.^pp;                       % Polynomial background
z = sum(z,1)' + sin(m);                 % Add a sine to the polynomial
background = z / max(z) * sigx;         % Rescale background

% Noise
sign = 0.05;
noise = randn(N,1) * sign;

% Final Spectrum
y = sum(peaks,1)' + background + noise;


%% Then, use BACKCOR to estimate the spectrum background
%  Either you know which cost-function to use as well as the polynomial order and the threshold value or not.

% If you know the parameter, use this syntax:
% ord = 5; s = 0.1; fct = 'atq'; [z,a,it,ord,s,fct] = backcor(n,y,ord,s,fct);

% Otherwise, use this syntax to run the GUI:
[z,a,it,ord,s,fct] = backcor(n,y);


%% Finally, plot the estimation if it exists
%  If the GUI was run, you may have click on the Cancel button, so no estimation was returned.

if ~isempty(z),
    
    % Sort the data
    [n,i] = sort(n);
    y = y(i);
    background = background(i);
    z = z(i);
    
    % Plot the results
    figure;
    subplot(2,1,1);
    plot(n,y,'b',n,background,'r:',n,z,'r');
    xlabel('n');
    legend('Simulated spectrum','Simulated Background (ground thruth)','Background estimation');
    title(['Estimation with function ''' fct ''', order = ' num2str(ord) ' and threshold = ' num2str(s)]);
    subplot(2,1,2);
    plot(n,y-background,'b',n,y-z,'r');
    xlabel('n');
    legend('Real corrected spectrum','Estimated corrected spectrum');
    
        figure; 
        p = 0:length(a)-1;
        T = repmat(n,1,ord+1) .^ repmat(p,N,1);
        plot(n,y,'b',n,background,'r:',n,z,'r',n,T*a,'g');
end;