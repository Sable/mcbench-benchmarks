%% Creating and Implementing LMS Algorithm to Filter out Cockpit Noise

%% Select whether your voice or a recorded voice signal should be used as
%% the input signal
USE_LIVE_VOICE = 0;
USE_RECORDED_VOICE = 1;
% Load Test Audio Signal to be used as clean input and play this sample
% through the PC sound card
Fs = 8000;
if (USE_RECORDED_VOICE == 1)
  disp('Original Voice')
  load analog_input % loads a file containing a Matlab variable called audioInputSignal
  sound(audioInputSignal, Fs);
  pause(5);
else
  %% Bring in Live Audio data from Data Acquisition Device (Soundcard)

  % Use Data Acquisition Toolbox to bring data in from Soundcard. This
  % example shows how streaming data can be brought into MATLAB from any data
  % acquisition card that is supported by the Data Acquisition Toolbox.

  % Set up Acquisition object with the desired sampling frequency, and add
  % just 1 channel to acquire data from
  ai = analoginput('winsound');
  addchannel(ai,1);
  set(ai, 'SampleRate', Fs);

  % Acquire 5 seconds of data
  set(ai, 'SamplesPerTrigger', 5*Fs);
  set(ai, 'TriggerType', 'immediate');
  disp('start recording');
  start(ai);
  wait(ai,5 + 1)
  audioInputSignal = getdata(ai);
end

%% Create Random noise and filter it with an 'unknown' filtering process
% Observation noise signal corresponding to Engine noise
noise = randn(size(audioInputSignal));

% 'Unknown' FIR system to be identified
b  = fir1(31,0.5);
noise_filtered  = .3*filter(b,1,noise);
mtlb_noisy  = audioInputSignal(1:length(noise_filtered)) + noise_filtered;

%% Plot the noisy spectrogram
subplot(1,2,1), spectrogram(mtlb_noisy,  128,120,256,'yaxis'); title('Noisy Audio')

%Play noisy signal
disp('Voice + Noise');
sound(mtlb_noisy, Fs)
pause(2)

%% Create and Implement LMS Adaptive Filter
% Create simple LMS/nLMS/RLS Filter to identify filtering process and
% remove the filtered noise from desired signal

% Define Adaptive Filter Parameters
filterLength = 32;
weights = zeros(1,filterLength);
step_size = 0.004;

% Initialize Filter's Operational inputs
output = zeros(1, length(mtlb_noisy));
err = zeros(1,length(mtlb_noisy));
input = zeros(1,filterLength);

% For Loop to run through the data and filter out noise
for n = 1: length(mtlb_noisy)

    %Get input vector to filter
    for k= 1:filterLength
        if ((n-k)>0)
            input(k) = noise(n-k+1);
        end
    end

    output(n) = weights * input';  %            <Output of Adaptive Filter
    err(n)  = mtlb_noisy(n) - output(n); %          <Error Computation
    weights = weights + step_size * err(n) * input; %           <Weights  Updation 

    %plot(weights); % Optional command to plot weights to visualize how
    %they change
end

% Plot the Clean Spectrogram
subplot(1,2,2), spectrogram(err, 128,120,256,'yaxis');title('Filtered Audio')

%% Play the filtered audio 

% The cleaned up audio signal is in this case the error signal
disp('After LMS');
sound(err)




