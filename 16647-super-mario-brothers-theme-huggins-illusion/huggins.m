  function OP = huggins(freq, sr, dur, BW, FC, gateDur)
% function OP = huggins(freq, sr, dur, BW, FC, gateDur)
% This function creates binaural Huggins pitches using a 2nd order all pole
% filter to introduce the phase shifts required.  The filters can be
% cascaded in order to make huggins 'chords' or harmonic huggins complexes.
% see the mario_huggins file for a fun little demo.  Filter coefficients
% are as used in the document included in this submission (by Elisabet 
% Molin).  All programming in this file by Nick Clark 28/9/2007. Non-profit
% use only.
%
% OP = stereo signal to be played over headphones.
% freq = array containing frequencies you want in you huggins chord
% sr = sampling rate (16e3 works well)
% dur = duration in seconds
% BW = band-width of optional band pass filter
% FC = centre frequency of optional band-pass filter
% gateDur = optional raised cosine sq volume ramp duration in seconds
%
% Usage example:
% soundsc(huggins([400 600],25e3,3,1000,500,.05),25e3);
% will play a combined huggins pitch at 400 and 600 Hz with a 25kHz sample
% rate, 3 seconds in duration, lp filtered @1kHz, with a 25kHz sample rate
% IMPORTANT: USE (VERY) GOOD HEADPHONES TO HEAR MULTIPLE PITCHES!!!

if nargin<6; gateDur = []; end
if nargin<5; BW = []; FC = []; end

%%%%% Huggins Pitch(es) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make huggins pitch (cascade filters if more than one pitch required)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq = freq(find(freq~=0)); %remove zero elements
if ~isempty(freq)
    c = 0.03; %constant used in pole radius calculation
    r = 1 - ((c*pi*freq)/sr); %Radius of poles from the origin
    b = [(r.^2); -2*r.*cos(2*pi*freq./sr); ones(1,size(freq,2))]; %zeros of all pass filter
    a = flipud(b); %poles are symmetric with corresponding zeros around the unit circle

    OP(:,1) = randn(sr*dur,1);
    OP(:,2) = OP(:,1);
    for n = 1:size(freq,2)
        OP(:,2) = filter(b(:,n),a(:,n),OP(:,2));
        %freqz(b(:,n), a(:,n), 512, sr); hold on %UNCOMMENT TO SEE PHASE SHIFTS
    end
else
    OP = repmat(randn(sr*dur,1),1,2); %just output diotic noise if no frequency specified
end
%%%%% Bandpass filter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add the cosine squared volume ramps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(BW) & ~isempty(FC)
    if BW/2 == FC
        [bBP,aBP] = butter(4,BW*2*(sr^-1));
    else
        [bBP,aBP] = butter(4,[FC-BW/2 FC+BW/2]*2*(sr^-1));
    end
    OP = filter(bBP,aBP,OP);
end

%%%%% Volume envelope %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add the cosine squared volume ramps
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(gateDur)
    vEnv(1:length(OP)) = 1;
    loAngle = linspace(-pi/2,0,min(find((0:1/sr:dur)>gateDur)));
    hiAngle = linspace(0,pi/2,min(find((0:1/sr:dur)>gateDur)));
    loEnv = cos(loAngle).^2; 
    hiEnv = cos(hiAngle).^2;
    vEnv(1:length(loEnv)) = loEnv; 
    vEnv(end-length(hiEnv)+1:end) = hiEnv;
    OP = OP.*repmat(vEnv',1,2);
end