function raPsd2d(img,res)
% function raPsd2d(img,res)
%
% Computes and plots radially averaged power spectral density (power
% spectrum) of image IMG with spatial resolution RES.
%
% (C) E. Ruzanski, RCG, 2009

%% Process image size information
[N M] = size(img);

%% Compute power spectrum
imgf = fftshift(fft2(img));
imgfp = (abs(imgf)/(N*M)).^2;                                               % Normalize

%% Adjust PSD size
dimDiff = abs(N-M);
dimMax = max(N,M);
% Make square
if N > M                                                                    % More rows than columns
    if ~mod(dimDiff,2)                                                      % Even difference
        imgfp = [NaN(N,dimDiff/2) imgfp NaN(N,dimDiff/2)];                  % Pad columns to match dimensions
    else                                                                    % Odd difference
        imgfp = [NaN(N,floor(dimDiff/2)) imgfp NaN(N,floor(dimDiff/2)+1)];
    end
elseif N < M                                                                % More columns than rows
    if ~mod(dimDiff,2)                                                      % Even difference
        imgfp = [NaN(dimDiff/2,M); imgfp; NaN(dimDiff/2,M)];                % Pad rows to match dimensions
    else
        imgfp = [NaN(floor(dimDiff/2),M); imgfp; NaN(floor(dimDiff/2)+1,M)];% Pad rows to match dimensions
    end
end

halfDim = floor(dimMax/2) + 1;                                              % Only consider one half of spectrum (due to symmetry)

%% Compute radially average power spectrum
[X Y] = meshgrid(-dimMax/2:dimMax/2-1, -dimMax/2:dimMax/2-1);               % Make Cartesian grid
[theta rho] = cart2pol(X, Y);                                               % Convert to polar coordinate axes
rho = round(rho);
i = cell(floor(dimMax/2) + 1, 1);
for r = 0:floor(dimMax/2)
    i{r + 1} = find(rho == r);
end
Pf = zeros(1, floor(dimMax/2)+1);
for r = 0:floor(dimMax/2)
    Pf(1, r + 1) = nanmean( imgfp( i{r+1} ) );
end

%% Setup plot
fontSize = 14;
maxX = 10^(ceil(log10(halfDim)));
f1 = linspace(1,maxX,length(Pf));                                           % Set abscissa

% Find axes boundaries
xMin = 0;                                                                   % No negative image dimension
xMax = ceil(log10(halfDim));
xRange = (xMin:xMax);
yMin = floor(log10(min(Pf)));
yMax = ceil(log10(max(Pf)));
yRange = (yMin:yMax);

% Create plot axis labels
xCell = cell(1:length(xRange));
for i = 1:length(xRange)
    xRangeS = num2str(10^(xRange(i))*res);
    xCell(i) = cellstr(xRangeS);
end
yCell = cell(1:length(yRange));
for i = 1:length(yRange)
    yRangeS = num2str(yRange(i));
    yCell(i) = strcat('10e',cellstr(yRangeS));
end

%% Generate plot
figure
loglog(1./f1,Pf,'k-','LineWidth',2.0)
set(gcf,'color','white')
set(gca,'FontSize',fontSize,'FontWeight','bold','YTickLabel',yCell,'YMinorTick','off',...
    'XTickLabel',xCell,'XGrid','on','YAxisLocation','right','XDir','reverse');
xlabel('Wavelength (km)','FontSize',fontSize,'FontWeight','Bold');
ylabel('Power','FontSize',fontSize,'FontWeight','Bold');
title('Radially averaged power spectrum','FontSize',fontSize,'FontWeight','Bold')