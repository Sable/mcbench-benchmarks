function symbols = computeSymbolsFromParams(par, sampleRate, iq)

s0 = par(1);
s = par(2);
skew = par(3);
rot = par(4);

%% Adjust the scale

iq = iq * s;

%% Isolate the Symbols
% Because of differences between the rate at which symbols are broadcast,
% the rate at which samples are taken, and the blurring effect of
% transmission, the symbols are uniformly spaced throughout the acquired IQ
% data.  The remainder of the samples are transitions between symbols.  
% From the capture time and the symbol rate, we know how many symbols.  By 
% combining that with the sample rate, we can calculate the symbol spacing 
% in our IQ cloud.  
% By using the value manipulation tools in the editor and Cell mode, we can
% immediately visualize the results of different symbol choices.
% I know the symbol spacing - knows how sig broadcasted and how signature
% is sampling

manualSymbols= iq(round(s0:sampleRate:length(iq)));

%% What's Wrong Now!
% At this point, we have located our symbols in the IQ data.  However, the
% symbols still don't cluster into eight nice neat groupings.  The problem
% is that we need to account for skew in the signal.  If everything is not
% synchronized correctly, the symbols appear to "walk" around between their
% intended locations.  We can correct for that with a linear phase
% correction.

skewCorrection = exp(2*pi*i*linspace(0,skew,length(manualSymbols)));
manualSymbolsDeskewed = manualSymbols.*skewCorrection; %*exp(2*pi*i*0.04) adds global rotation correction

%% Global Rotation
% Now that we have located our symbols and corrected for skew between the
% clocks, if our clusters aren't aligned correctly globally (all shited
% clockwise or counterclockwise) we can apply a global rotation.

symbols = manualSymbolsDeskewed.*exp(2*pi*i*rot); 