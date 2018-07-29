%% Developing custom modulation schemes
% This script shows how MATLAB can be used, together with Agilent instruments, 
% for prototyping custom modulation schemes. It demonstrates MATLAB functionality for data
% acquisition, visualisation and analysis. It finishes by a simple example illustrating the
% first step towards simulate the prototype communications system in Simulink.
% 
% More precisely, this script shows how to:
% 
% * Use MATLAB to prototype a communication system that consists of a random bit generator, 
% bit-to-integer converter, baseband modulator with custom modulation format, 
% channel, demodulator, integer-to-bit converter.
% * Compute the system's bit error rate (BER)
% * Upload generated custom waveform to an Agilent ESG Vector Signal Generator
% * Acquire the signal using Agilent MXA Signal Analyser 
% * Demodulate and analyse the acquired signal.
% * Design a prototype Simulink model simulating a communication system
% using custom modulation scheme
% 
% The demodulation of the acquired signal is based on IS136 demo written by
% Todd Atkins and the functions for creating Agilent logo constellation and 
% uploading the data on Agilent vector signal generator are from Tom Gaudette.


%% I. Prototype the communication system
% Use MATLAB and Communications Toolbox to prototype the communications
% system using custom modulation scheme.

%% Set system parameters
% Set the values of the main parameters 

% size of signal constellation:     32
M = 32; 
% number of bits per symbol:        5
k = log2(M); 
% number of bits to process:        30000
n = 3e4; 
% oversampling factor:              8
nSamp = 8;



%% Create signal source
% Create a binary data stream as a column vector.
% Then plot first 40 bits in a stem plot.

% random binary data stream
x = randint(n,1); 

stem(x(1:40), 'filled');
title('Random bits', 'FontSize', 18);
xlabel('Bit index', 'FontSize', 18); 
ylabel('Binary value', 'FontSize', 18);


%% Map bits to symbols
% Convert the bits in x into k-bit symbols.  7500 symbols (30000/4) ranging
% from 0 to 31
xsym = bi2de(reshape(x, k, length(x)/k).', 'left-msb');

% plot first 10 symbols in a stem plot.
figure; 
stem(xsym(1:10));
title('Random symbols', 'FontSize', 18);
xlabel('Symbol index', 'FontSize', 18);
ylabel('Integer value', 'FontSize', 18);

%% Create desired constellation
% MATLAB provides a lot of flexibility in generating the modulation
% schemes. Let's create a custom constellation, for example in shape of
% Agilent logo.

% constellation is represented by 32 complex numbers
constellation = agilentlogo();

f = figure;
plot(constellation, '.', 'MarkerSize', 16);

% or create more customised plot...
s = repmat([2^8 2^7 2^6  2^2], [1,8]);
scatter(imag(constellation), real(constellation), s, 'filled');
axis off
set(f, 'Color', 'w')

%% Modulate the signal 
% Modulate with 32 general QAM. 

% complex signal, 6000 symbols.
ytx = genqammod(xsym, constellation);


%% Perform the pulse shaping
% Modulation is often followed by pulse shaping, and demodulation is often
% preceded by a filtering or an integrate-and-dump operation. This section presents
% an example involving rectangular pulse shaping. 
% Rectangular pulse shaping repeats each output from the modulator a fixed number of times
% to create an up-sampled signal. Rectangular pulse shaping can be a first step
% or an exploratory step in algorithm development, though it is less realistic
% than other kinds of pulse shaping (e.g. using Raised Cosine Filter). 
[ytxs] = rectpulse(ytx, nSamp);  

%% Apply channel model
% Send signal over an AWGN channel.
EbNo = 10; % In dB
snr = EbNo + 10*log10(k) - 10*log10(nSamp);  % 16.021 db
yrxs = awgn(ytxs, snr, 'measured');

%% Downsample the signal
% If the transmitter up-samples the modulated signal, then the receiver 
% should down-sample the received signal before demodulating. 
% The "integrate and dump" operation is one way to down-sample the received signal.

yrx = intdump(yrxs, nSamp);

%% View constellation with a scatter plot
% Create scatter plot of noisy signal and transmitted
% signal on the same axes.  plotting 5000 symbols

h = scatterplot(yrx(1:5e3), 1, 0, 'b.');
hold on;
scatterplot(ytx(1:5e3), 1, 0, 'r.', h); 
title('Received Signal');
legend('Received signal', 'Signal constellation');
% set axis ranges.
axis([-1.2, 1.2, -1.2, 1.2]); 
hold off;

%% Demodulate the signal
% Demodulate the signal using the same Modem object as for the modulation

zsym = genqamdemod(yrx, constellation);

%% Map symbols to bits
% Undo the bit-to-symbol mapping performed earlier.

% convert integers to bits.
z = de2bi(zsym, 'left-msb'); 
% convert z from a matrix to a vector.
z = reshape(z.', numel(z), 1);

%% Computate BER 
% Compare x and z to obtain the number of errors and
% the bit error rate.
[number_of_errors, bit_error_rate] = biterr(x, z)

%% II. Test the system on real data using instruments
% We have seen above how to use MATLAB and Communications Toolbox to prototype 
% and test a communication system using custom modulation. In order to test
% the behaviour of the system on real data, we can replace the simulated channel
% by instruments, such as arbitrary waveform generator and signal analyser.
% In order to control the instruments and acquire the data we are going to
% use the Instrument Control Toolbox.

%% Upload data to ESG Vector Signal Generator
% Upload the simulated signal to a Vector Signal Generator. In this example we have used 
% AGILENT E4438C Vector Signal Generator. We uploaded the function using Agilent Waveform Download Assistant. 

% define the instrument host name
esgIp = 'E4438C_A16616';

% define the instrument sample rate
esgSampleRate = 22.5e6; 

% upload the waveform and play it with sampleRate 22.5 MHz
% ESG_DL(ytxs, esgSampleClock, esgIp, 'SOURce:FREQuency 2E9', 'POWer -20')

% Here is the description of function ESG_DL
help('ESG_DL')

%% Receive data from MXA Signal Analyser
% Acquire the IQ data. In this example we have used Agilent MXA Signal
% Analyser and MATLAB Instrument Driver for this instrument from MATLAB
% Central. To acquire the signal to MATLAB, you can use TMTOOL or one of the 
% Agilent MXA examples from www.agilent.com/find/sa_programming.
% In this example the data was acquired from MXA Signal Analyzer in 
% IQ analyzer mode with bandwith 25MHz and time span 2ms. 
% The resulting MXA sample time was 22.221e-9s. This
% means that for each uploaded sample we acquired around 2 samples.

% define the instrument IP address
mxaIp = '172.16.27.192';

% Acquire IQ vector
% iq = acquireIqVector(mxaIp);
% Here is the description of function acquireIqVector
help('acquireIqVector')

% compute the rate ration between the instruments
mxaSampleTime = 22.221e-9;
mxaSampleRate = 1/mxaSampleTime;
nInstrSamp = mxaSampleRate/esgSampleRate




%% Save the IQ vector
% Save the IQ vector to file acquiredIQ.mat.

% save acquiredIQ iq

%% Analyse the acquired signal
% Use MATLAB algorithm development environment to locate the symbols in the
% acquired IQ vector.

%% Load IQ data
% If you do not have hardware, you can perform the following analysis on
% the data saved in MAT file.

load acquiredIQ;

figure
plot(iq, 'r.')
title('Acquired IQ vector')
xlabel('In-Phase')
ylabel('Quadrature')

%% Rescale the data
% Rescale the acquired data so that IQ values are within [-1, 1] range.
% The scaling is required only for the optional automatic step at the end.
iq = (iq.');
maxVal = max( [ real( iq(:) ); imag( iq(:) ) ] );
iq = iq /(maxVal);

%% Isolate the Symbols
% Because of differences between the rate at which symbols are broadcast,
% the rate at which samples are taken, and the blurring effect of
% transmission, the symbols are uniformly spaced throughout the acquired IQ
% data.  The remainder of the samples are transitions between symbols. 
% We know the symbol spacing from how signal is broadcasted and how it
% was acquired. 
% By using the value manipulation tools in the editor and Cell mode, we can
% immediately visualize the results of different symbol choices.
% 
% In this step we allow also manual scaling of the signal, so that the
% symbol clusters most distant from the center lie on the unit circle.

% manipulate the values below in Cell mode in order to separate the symbols
scale = 1.2;
s0 = 2;
ds = round(nSamp*nInstrSamp);

% subsample and scale the signal. 
plot(iq(s0:ds:end)*scale, 'r.')
title('Subsampled IQ vector')
xlabel('In-Phase')
ylabel('Quadrature')



%% Extract symbols
% Extract the symbols for the further processing
manualSymbols= iq(s0:ds:end)*scale;

%% Perform phase correction 
% At this point, we have located our symbols in the IQ data.  However, the
% symbols still don't cluster into eight nice neat groupings.  The problem
% is that we need to account for skew in the signal.  If everything is not
% synchronized correctly, the symbols appear to "walk" around between their
% intended locations.  We can correct for that with a linear phase
% correction.

% modify this with cell mode (by .1 or less).  
phaseValue = -0.15; 

% create vector of complex numbers representing the increasing rotation
skewCorrection = exp(2*pi*i*linspace(0,phaseValue,length(manualSymbols)));
% multiply the original signal 
manualSymbolsDeskewed = manualSymbols.*skewCorrection; 

plot(manualSymbolsDeskewed, 'r.');
title('Subsampled IQ vector after phase correction')
xlabel('In-Phase')
ylabel('Quadrature')



%% Perform global rotation
% Now that we have located our symbols and corrected for skew between the
% clocks, if our clusters aren't aligned correctly globally (all shifted
% clockwise or counter clockwise) we can apply a global rotation.

% modify this with cell mode (by .1 or less).  
rotation = -0.025; 

% add global rotation
symbols = manualSymbolsDeskewed.*exp(2*pi*i*rotation); 
plot(symbols,'r*');
title('Subsampled IQ vector after rotation correction')
xlabel('In-Phase')
ylabel('Quadrature')

%% III. Use pattern search to separate the symbols
% At this point we have obtained the symbol separation using Cell mode, a part of MATLAB
% algorithm development environment. There are ways of finding the values
% allowing for the symbol separation automatically, using optimization
% methods. The cost function, corresponding to the distance of the
% separated symbols from the ideal points on the constellation contains a
% lot of local minima and in order to use classic optimisation methods we
% would need to know the approximate solutions. We can try to use global 
% optimization methods, such as pattern search from Genetic Algorithm and Direct Search
% Toolbox in order to find the parameter values automatically without need
% of accurate starting point.


%% Initiate pattern search
% Define starting point and explore the corresponding solution

% define the starting point
% [firstSymbol, scaling, phase, rotation]
x0 = [2, 1, 0, 0];

% sample rate should be known from transmition/acquisition sample rates so
% no need to optimize
sampleRate = round(nSamp*nInstrSamp); 

% different parameters to be optimised have quite different values,
% which can influence the optimisation. Let's scale them in order to work
% with parameters with similar orders of magnitude
s = [1 1 100 100]; 

% show the current solution
showSolutionDemod(x0, sampleRate, iq);

% show the initial value of the cost function
cost = costSymbolSeparation(x0.*s, sampleRate, iq)

%% Run pattern search
% Use fundtion PATTERNSEARCH to separate symbols

% define paramterews for pattern search
os = psoptimset('CompletePoll', 'on', 'CompleteSearch', 'on', 'SearchMethod', 'MADSPositiveBasis2N');

% set parameters bounds
lb = [1 0.5 -2*pi*100 -pi/2*100];
ub = [15,1.5,2*pi*100,pi/2*100];
% perform search
[xn, fval] = patternsearch(@(x)costSymbolSeparation(x, sampleRate, iq), ...
    x0.*s, [], [], [], [], lb, ub, [], os);

% de-scale the solution
x = xn./s

% show the current value of the cost function
fval

figure
showSolutionDemod(x, sampleRate, iq);

%% IV. Simulate the communication system
% We have seen above how to use MATLAB functionality to prototype and explore the properties of a
% communications system. We have seen also how to use instruments to test
% this system on real data. As a next step, we could simulate the behaviour
% of this system over time using Simulink. Here is a simple model
% simulating the system developed on the beginning of this script. It
% generates random bit sequences, transmits them and verifies the bit error
% rate. 

% todo colors, channel
custommodulationagilentlogoSL

%% Elaborate the model
% The model above is fairly simple and does not take into account issues
% such as symbol timing recovery or phase recovery, which are necessary for processing life data.
% If it was to be implemented as a part of a real system, consideration would also have to be given to 
% optimisation of the code for the performance, solving fixed points settings and 
% partitioning of the system into components. For this particular problem, 
% we have not developed models taking taking into consideration these real-world 
% implementation issues, but we could give examples on how to tackle these 
% problems using existing GPS or FM models as examples.

% see the logo for the last time...
f = figure;
constellation = agilentlogo();
s = repmat([2^8 2^7 2^6  2^2], [1,8]);
scatter(imag(constellation), real(constellation), s, 'filled');
axis off
set(f, 'Color', 'w')

