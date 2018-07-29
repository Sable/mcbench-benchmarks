function eyemap(SigVector,WindowLength,Xresolution,Yresolution)
% EYEMAP Displays the eye diagram of a signal as an image of intensities
% similarly to a digital oscilloscope
%
% USAGE
%   eyemap(SigVector,WindowLength) displays an image containing the eye
%   diagram of the SigVector as an intensity map with an observation window
%   of length WindowLength. 
%
%   SigVector must be a 1xN or Nx1 vector with real terms and WindowLength
%   must be a nonnegative scalar, which is a submultiple of the length of
%   SigVector. 
%
%   For a complex signal (e. g. optical signals), EYEMAP will use
%   abs(SigVector).^2 to plot the eye diagram. 
%
%   If WindowLength is not a submultiple of the length of SigVector, EYEMAP
%   will truncate SigVector in order to have WindowLength = length(SigVector)/n. 
%
%   The generated image will have a default resolution of 256x256.
%
%
%   eyemap(SigVector,WindowLength,Xresolution,Yresolution) displays the eye
%   diagram with a resolution given by Xresolution x Yresolution, with
%   Xresolution and Yresolution as nonnegative integers
%
%
%
% Example for EYEMAP
%
% %Generate random binary sequence
%
% n_simb = 1024; %Number of symbols
% ak=round(rand(1,n_simb)); %create random binary sequence
%
% %Generate binary signal using sequence
% n_pt=128; %Number of samples per symbol
% signal=zeros(1,length(ak)*n_pt); %initialize signal variable
% for k=1:length(ak) %Generate polar signal from digital sequence
%     signal((k-1)*n_pt+1:k*n_pt) = 2*(ak(k)-0.5); 
% end;
%
% %Filter signal using a gaussian filter
% signal=real(ifft(fft(signal).*exp(-(1:length(signal)).^2/n_simb^2)));
%
% %Generate random gaussian noise
% noise=randn(size(signal))*0.1;
%
% %Visualize eye diagram of signal and noise
% figure
% eyemap(signal+noise,n_pt*2);
%
%
%
% 2007 Ruben S. Luís


%Verify format of input arguments
switch nargin
    case 0
        %No input arguments, run example
        example;
        return
    case {1,3}
        error('EYEMAP: Not enough input arguments');
    case 2
        %Only 2 input args, use default resolution and contrast
        Xresolution = 256;
        Yresolution = 256;
end;

if nargin>4
    error('EYEMAP: Too many input arguments');
end;
%Remaining option with 5 arguments, we have user defined resolution and
%contrast





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check validity of input arguments %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check if SigVector is real
if ~isreal(SigVector)
    %SigVector is complex, 
    SigVector = abs(SigVector).^2;
end;

%Check size of SigVector
if isempty(SigVector)
    %Empty input signal
    error('EYEMAP: empty input signal');
elseif ~isvector(SigVector)|~isnumeric(SigVector)
    %Input signal not a numeric vector
    error('EYEMAP: a numeric vector input signal is required');
end;

%Check if SigVector is a row or column vector
SigVectorSize = size(SigVector);
if SigVectorSize(1) > SigVectorSize(2)
    %SigVector is a column vector. Rotate to have a row vector
    SigVector = SigVector';
    SigVectorSize = SigVectorSize(end:-1:1);
end;

%Check validity of WindowLength
WindowLength = double(WindowLength);
if ~isscalar(WindowLength)|~isnumeric(WindowLength)|WindowLength<1
    error('EYEMAP: Window Length must be a nonzero integer');
end;

%Check length of SigVector with respect to WindowLength
if rem(SigVectorSize(2),WindowLength)
    %WindowLength is not a sub-multiple of the length of SigVector
    SigVector = SigVector(1:end-rem(SigVectorSize(2),WindowLength));
end;

%Check validity of Xresolution
Xresolution = double(Xresolution);
if ~isscalar(Xresolution)|~isnumeric(Xresolution)|Xresolution<1
    error('EYEMAP: Xresolution must be a nonzero integer');
end;

%Check validity of Yresolution
Yresolution=double(Yresolution);
if ~isscalar(Yresolution)|~isnumeric(Yresolution)|Yresolution<1
    error('EYEMAP: Yresolution must be a nonzero integer');
end;
 




%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Intensity Map %
%%%%%%%%%%%%%%%%%%%%%%%%%

NWindow = length(SigVector)/WindowLength; %Number of observation windows

%Interpolate input signal to the resolution of the X axis
relationX = WindowLength/Xresolution; %relation between windowlength and Xresolution
X = linspace(0,length(SigVector),length(SigVector)/relationX); %new unwindowed X-axis
Y = interp1(SigVector,X,'linear'); %new interpolated signal

%Define grid for quantization of input signal
DY = max(Y)-min(Y); %dynamic range of the signal
Y_grid_ini = linspace(min(Y)-(max(Y)-min(Y))/20,...
    max(Y)+(max(Y)-min(Y))/20,Yresolution); %define grid with +- 5% tolerance
dY = Y_grid_ini(2)-Y_grid_ini(1); %width of the grid

%Quantize the input signal with 16 bit
posY = int16(round((Y-Y_grid_ini(1))/dY)); %Quantized vector of the input signal
Y_grid = int16(0:Yresolution-1); %redefine grid with 16 bit integers

IntensityMap = zeros(Yresolution,Xresolution); %Initialize intensity map

%Intensity map will be calculated by incrementing the values of the cells
%in that map that are crossed by the quantized signal.

counter = 1;
MeanIntensityMap = 0;
for cx = 1:Xresolution %Set a counter for the x-axis of the map
    aux_pos = (0:NWindow-1)*Xresolution+cx; %determine the corresponding position in the signal vector
    auxY = posY(aux_pos); %retain the values of the signal that correspond to that position
    for cy = 1:Yresolution %Set a counter for the y-axis of the map
        aux = sum(auxY==Y_grid(cy)); %find if the signal crosses the cell IntensityMap(cy,cx)
        if aux
            IntensityMap(cy,cx) = aux; %Store the result in the map
            %Compute mean of the intensity map for the contrast
            MeanIntensityMap = MeanIntensityMap+IntensityMap(cy,cx);
            counter = counter + 1;
        end;
    end;
end;
%Normalize Map
MeanIntensityMap=64*MeanIntensityMap/(counter)/max(max(IntensityMap));
IntensityMap=64*IntensityMap/max(max(IntensityMap));




%%%%%%%%%%%%%%%%%%%%%%
% Plot intensity map %
%%%%%%%%%%%%%%%%%%%%%%
%Display image
image((0:Xresolution)/Xresolution,Y_grid_ini,IntensityMap)
set(gca,'Ydir','normal');

%Mean of the map
Ntone=round(2*MeanIntensityMap); %define number of tones in the picture
Ntone=Ntone*(Ntone<=64)+64*(Ntone>64);
Cmap=[linspace(0,1,Ntone) ones(1,64-Ntone-1)]'*ones(1,3); %create inverse colomap
colormap(1-Cmap); %Set color map

return





%%%%%%%%%%%
% EXAMPLE %
%%%%%%%%%%%
function example

%
% Example for EYEMAP
%
%   Generate noisy signal and visualize eye diagram using EYEMAP

%Generate random binary sequence
n_simb = 1024; %Number of symbols
ak=round(rand(1,n_simb)); %create random binary sequence

%Generate binary signal using sequence
n_pt=128; %Number of samples per symbol
signal=zeros(1,length(ak)*n_pt); %initialize signal variable
for k=1:length(ak) %Generate polar signal from digital sequence
    signal((k-1)*n_pt+1:k*n_pt) = 2*(ak(k)-0.5); 
end;

%Filter signal using a gaussian filter
signal=real(ifft(fft(signal).*exp(-(1:length(signal)).^2/n_simb^2)));

%Generate random gaussian noise
noise=randn(size(signal))*0.1;

%Visualize eye diagram of signal and noise
figure
eyemap(signal+noise,n_pt*2)
return

