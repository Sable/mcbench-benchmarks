function imageStack=Kalman_Stack_Filter(imageStack,gain,percentvar)
% function imageStack=Kalman_Stack_Filter(imageStack,percentvar,gain)
%
% Purpose
% Implements a predictive Kalman-like filter in the time domain of the image
% stack. Algorithm taken from Java code by C.P. Mauer.
% http://rsb.info.nih.gov/ij/plugins/kalman.html
%
% Inputs
% imageStack - a 3d matrix comprising of a noisy image sequence. Time is
%              the 3rd dimension. 
% gain - the strength of the filter [0 to 1]. Larger gain values means more
%        aggressive filtering in time so a smoother function with a lower 
%        peak. Gain values above 0.5 will weight the predicted value of the 
%        pixel higher than the observed value.
% percentvar - the initial estimate for the noise [0 to 1]. Doesn't have
%              much of an effect on the algorithm. 
%
% Output
% imageStack - the filtered image stack
%
% Note:
% The time series will look noisy at first then become smoother as the
% filter accumulates evidence. 
% 
% Rob Campbell, August 2009



% Process input arguments
if nargin<2, gain=0.5;          end
if nargin<3, percentvar = 0.05; end


if gain>1.0||gain<0.0
    gain = 0.8;
end

if percentvar>1.0 || percentvar<0.0
    percentvar = 0.05;
end


%Copy the last frame onto the end so that we filter the whole way
%through
imageStack(:,:,end+1)=imageStack(:,:,end);


%Set up variables
width = size(imageStack,1);
height = size(imageStack,2);
stacksize = size(imageStack,3);

tmp=ones(width,height);


%Set up priors
predicted = imageStack(:,:,1); 
predictedvar = tmp*percentvar;
noisevar=predictedvar;


%Now conduct the Kalman-like filtering on the image stack
for i=2:stacksize-1
  stackslice = imageStack(:,:,i+1); 
  observed = stackslice;
  
  Kalman = predictedvar ./ (predictedvar+noisevar);
  corrected = gain*predicted + (1.0-gain)*observed + Kalman.*(observed-predicted);        
  correctedvar = predictedvar.*(tmp - Kalman);
 
  predictedvar = correctedvar;
  predicted = corrected;
  imageStack(:,:,i)=corrected;
end


imageStack(:,:,end)=[];
