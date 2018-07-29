% mario_huggins.m - Nick Clark 28/9/2007
%
% USE HEADPHONES
% WAIT A FEW SECONDS FOR PROCESSING
% LISTEN CAREFULLY AND ENJOY!
%
% Just run this script with the huggins.m in the same directory or in your
% path.  This is a cool litle demo to show how huggins binaural pitch can
% be made into chords. Thanks to James Humes on matlabcentral for inspiring
% me to do this to the mario theme song . . man - this is probably the most
% tragic way I have ever spent a Friday night.
%
% This demo only uses the alto and tenor parts as Huggins pitch is a
% pretty weak percept at the best of times.  You'll need a pretty good set
% of headphones to hear this too - it will not work properly over
% loudspeakers.

t = 0.15; %single beat duration
base_pitch = 440; %tuning parameter 440Hz default
introONLY = 0; %set to one if you only want top hear the intro
sr = 16e3;

%%%%% Notes and timing %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The transcription here was originally done by Stewart Bozarth and the
% painstaking programming of the score into MATLAB code was taken from
% James Humes' fileexchange submission
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if introONLY
    keysT = [ 56 56 0 56 0 52 56 0 59 0 0 47 0 0 ];
    keysA=  [ 46 46 0 46 0 46 46 0 51 0 0 47 0 0 ];
    durA =  [ t t t t t t t t t t 2*t t t 2*t];
else %whole song
    keysT = [  56 56 0 56 0 52 56 0 59 0 0 47 0 0 52 0 47 0 44 0 0 49 0 51 0 50 49 0 47 0 56 0 59 0 61 0 57 59 0 56 0 52 54 51 0 52 0 47 0 44 0 0 49 0 51 0 50 49 0 47 0 56 0 59 0 61 0 57 59 0 56 0 52 54 51 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 59 58 57 55 0 56 0 64 0 64 64 0 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 55 0 0 54 0 52 0 0 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 59 58 57 55 0 56 0 64 0 64 64 0 0 0 59 58 57 55 0 56 0 48 49 52 0 49 52 54 0 55 0 0 54 0 52 0 0 0 52 52 0 52 0 52 54 0 56 52 0 49 47 0 0 52 52 0 52 0 52 54 56 0 0 52 52 0 52 0 52 54 0 56 52 0 49 47 0 0 56 56 0 56 0 52 56 0 59 0 0 47 0 0 56 52 0 47 0 48 0 49 57 0 57 49 0 0 51 0 61 0 61 0 61 0 59 0 57 0 56 52 0 49 47 0 0 56 52 0 47 0 48 0 49 57 0 57 49 0 0 47 57 0 57 57 0 56 0 54 0 52 0 0 0 52 0 47 0 44 0 49 51 49 48 50 48 47];
    keysA = [  46 46 0 46 0 46 46 0 51 0 0 47 0 0 44 0 40 0 35 0 0 40 0 42 0 41 40 0 40 0 47 0 51 0 52 0 49 51 0 49 0 56 45 42 0 44 0 40 0 35 0 0 40 0 42 0 41 40 0 40 0 47 0 51 0 52 0 49 51 0 49 0 56 45 42 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 56 55 54 51 0 52 0 59 0 59 59 0 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 48 0 0 45 0 44 0 0 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 56 55 54 51 0 52 0 59 0 59 59 0 0 0 56 55 54 51 0 52 0 44 45 47 0 40 44 45 0 48 0 0 45 0 44 0 0 0 48 48 0 48 0 48 50 0 47 44 0 44 40 0 0 48 48 0 48 0 48 50 47 0 0 48 48 0 48 0 48 50 0 47 44 0 44 40 0 0 46 46 0 46 0 46 46 0 51 0 0 47 0 0 52 49 0 44 0 44 0 45 52 0 52 45 0 0 47 0 57 0 57 0 57 0 56 0 54 0 52 49 0 45 44 0 0 52 49 0 44 0 44 0 45 52 0 52 45 0 0 47 54 0 54 54 0 52 0 51 0 47 44 0 44 40 0 0 44 0 40 49 51 49 48 50 48 47];
    durA =  [  t t t t t t t t t t 2*t t t 2*t t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t t 2*t t 2*t t t t t t t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t 2*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t t t 2*t 2*t t t t t t t t t t t t t t t 2*t t t t t 2*t t t 2*t 4*t t t t t t t t t t t t t t t 2*t t t t t t t t t 4*t 4*t t t t t t t t t t t t t t t 2*t t t t t t t t t t t 2*t t t 2*t t t t t 2*t t t t t t t t t 2*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t t t t t 2*t t t t t t t t t 2*t t t t t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t (2/3)*t t t t t t t 2*t t 2*t t 2*t t t 4*t 4*t t 6*t];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert key values and make song (may take some time - please wait)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freqA = base_pitch*2.^((keysA-49)/12);
freqT = base_pitch*2.^((keysT-49)/12);

song = [0 0];
for n = 1:length(keysT)
    song = [song; huggins([freqA(n) freqT(n)],sr,durA(n))];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Add a 2.5kHz low-pass filter to make things a little less painful
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[b,a] = butter(4,2500*(sr^-1),'low');
song = filter(b,a,song);

soundsc(song, sr)