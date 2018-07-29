function [Ap]=padTCscope(A,channels)
%padTCscope   function to reformat data read by rdTCscope, so that the time
%             steps of all channels will be the same.
%             Measurement data from TwinCAT Scope View sometimes use
%             different sample times in each channel. In that case it is not 
%             possible to perform arithmetic operations between channels,
%             e.g. CH1 + CH2. 
%
%   [Ap]=padTCscop(A,channels);
%
%   A        = matrix of data containing time time and measured values read
%              by function rdTCscope
%   channels = structure containing names of each channel
%   Ap       = matrix of data containing time time and measured values so 
%              that the time steps of all channels are the same.
%
%

%==========================================================================
% HOCHSCHULE AUGSBURG
% Fakultät für Maschinenbau und Verfahrenstechnik
% Prof. Dr.-Ing. Michael Glöckler
% © 2012
% michael.gloeckler@hs-augsburg.de
%==========================================================================

%--------------------------------------------------------------------------
% init constants
%--------------------------------------------------------------------------
timebase = 1e-6;    % 1e-6 s = 1 us

%==========================================================================
% find start and stop time of all channels
%==========================================================================
t0 = zeros(length(A(1,:))/2,1);     % init start time
dt = zeros(length(A(1,:))/2,1);     % init sample time
tE = zeros(length(A(1,:))/2,1);     % init stop time

for i=1:2:length(A(1,:))    % odd channel numbers 
    idx = (i+1)/2;
    t0(idx) = A(1,i);                                           % starting time of each channel
    tE(idx) = A(length(A(:,1)),i);                              % stop time of each channel
    dt(idx) = round(mean(diff(A(:,i)))/timebase)*timebase;      % mean value of the sample time 
    dt_min(idx) = round(min(diff(A(:,i)))/timebase)*timebase;   % min value of the sample time
    dt_max(idx) = round(max(diff(A(:,i)))/timebase)*timebase;   % max value of the sample time
end;

t0_all = min(t0);   % smallest starting time of all channels
tE_all = max(tE);   % biggest stop time of all channels

% promt the results
clc;
    disp('( start time | stop time )  of all channels:');
    disp( num2str([t0 tE]) );
    disp(' ');
    disp('( sample time: min | mean | max )  of all channels:');
    disp( num2str([min(dt_min) mean(dt) max(dt_max)]) );
    disp(' ');

    Ts_sugg = round(max([min(mean(dt)-dt_min),max(dt_max)-mean(dt)])/timebase)*timebase;
    if Ts_sugg <= timebase
        Ts_sugg = mean(dt);
    end;
    disp(['suggested sample time [s] : ' num2str(Ts_sugg) ]);
    
    % input new common sample time for all channels
    Ts = input('please enter new sample time [s] :');

    % basic error handling
    if Ts<=0 || Ts>=(tE_all-t0_all), error('invalid sample time'), end;
    
%==========================================================================
% create new time vector
%==========================================================================
time  = (t0_all:Ts:tE_all);

%--------------------------------------------------------------------------
% upsampling all channels
%--------------------------------------------------------------------------
Ap = zeros(length(time),length(A(1,:)));

for i=2:2:length(channels)
	disp(['channels ' num2str(i-1) ' , ' num2str(i) ]);
    % use linear interpolation ans extrapolation
	Ap(:,i) = interp1(A(:,i-1),A(:,i),time, 'linear','extrap');
	Ap(:,i-1) = time;
end;

return;