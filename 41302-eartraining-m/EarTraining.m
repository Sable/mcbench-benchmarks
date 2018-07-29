function EarTraining()

%Richard Moore
%November 18, 2012

%This program is intended to test/train for perfect pitch.  Currently my
%plan is to:
%-Start with just a couple of pitches, probably C and G.
%-Play the tones in different octaves and have the observer guess the
%pitch.
%-As proficiency is demonstrated within a moving average, add the next note
%in the circle of fifths.  
%-Also, when a mistake is made, notify the user that they have made a
%mistake and let them know what the correct note name is.


%C, G, D, A, E, B, F#, C#, G#, Eb, Bb, F
NoteNames = {'C'; 'G'; 'D'; 'A'; 'E'; 'B'; 'F#'; 'C#'; 'G#'; 'Eb'; 'Bb'; 'F'};
%Row = presented
%Column = responded
ResponseMat = zeros(12,12);
A = 440;
halfStep = 2^(1/12);
baseFreqs = [A*halfStep^3; A*halfStep^(-2); A*halfStep^5; A; A*halfStep^7; A*halfStep^2; A*halfStep^9; A*halfStep^4; A*halfStep^(-1); A*halfStep^6; A*halfStep^1; A*halfStep^8];
%numPitches = 8;
AccThresh = 0.9;
MinNumTrials = 20;

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp('EAR TRAINING FOR PITCH RECOGNITION');
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
disp(' ');
disp('You will hear notes and be asked to identify them.');
disp(['Once you have correctly identified at least ' num2str(AccThresh*100) '% of ' num2str(MinNumTrials) ' trials, another note will be added.']);
numPitches = input('How many pitches would you like to start out with? ');
disp(['Very weel, then.  You will be starting with ' num2str(numPitches) ' different notes.']);
disp([NoteNames{1:numPitches}]);
disp(' ');
pause(3);
disp('May the force be with you.');
pause(1);
clc;
%So, if the probability exceeds a threshold, add another pitch.
trialNum = 0;
testFlag = 1;
sampRate = 44100;
noteLength = 0.5; %In seconds
while testFlag
    %
    trialNum = trialNum + 1;
    %Present the pitch:
    oct = ceil(rand*4)-2;
    currPitch = ceil(rand*numPitches);
    soundsc(sin(2*pi*(2^oct)*baseFreqs(currPitch)*[0:(1/sampRate):noteLength]),sampRate);
    %Take the response:
    resp = input('Name that note: ','s');
    %This won't work quite yet.  The strings are not all the same length.
    switch resp
        case {'c','C'}
            resp2 = 1;
        case {'g','G'}
            resp2 = 2;
        case {'d','D'}
            resp2 = 3;
        case {'a','A'}
            resp2 = 4;
        case {'e','E'}
            resp2 = 5;
        case {'b','B'}
            resp2 = 6;
        case {'f#','F#','gb','Gb'}
            resp2 = 7;
        case {'c#','C#','db','Db'}
            resp2 = 8;
        case {'g#','G#','ab','Ab'}
            resp2 = 9;
        case {'eb','Eb','d#','D#'}
            resp2 = 10;
        case {'bb','Bb','a#','A#'}
            resp2 = 11;
        case {'f','F'}
            resp2 = 12;
        otherwise
            disp('Ummm, I think that you just made up a new note.');
    end
    %Populate the confusion matrix:
    ResponseMat(currPitch,resp2) = ResponseMat(currPitch,resp2) + 1;
    %Notify the user of a mistake, if applicable:
    if currPitch~=resp2
        disp(['Whoopsie-daisies!  That was actually ' NoteNames{currPitch}]);
    end
    %If skill level is mastered, increase numPitches and notify user:
    currNum = sum(sum(ResponseMat.*eye(size(ResponseMat,1))));    
    currDen = sum(ResponseMat(:));
    %Require a minimum score of 90% and a minimum number of 10 trials
    if (currDen>=MinNumTrials)&&((currNum/currDen)>=AccThresh)
        numPitches = numPitches + 1;
        %disp(ResponseMat);
        clc;
        disp('%%%%%%%%%%%%%%%%%%%%');
        disp('Congrats!  You just leveled up!');
        disp(['You now have to identify ' num2str(numPitches) ' different notes: ' NoteNames{1:numPitches}]);
        disp('%%%%%%%%%%%%%%%%%%%%');
        ResponseMat = zeros(12,12);
    end
    if rem(trialNum,10)==0
        %disp(ResponseMat);
        disp(['Since the last level-up your accuracy has been ' num2str(100*currNum/currDen) '%.']);
        testFlag = input('Wanna keep testing? 1=yes, 0=no: ');
    end
end

clc;
disp('Sure, go do something else.');
disp(' ');
pause(1);
disp('I''m sure that Netflix is more important than becoming a ear-training-jedi-master.');
pause(3);
