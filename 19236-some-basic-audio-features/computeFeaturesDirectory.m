function Features = computeFeaturesDirectory(classNames)

%
% This function computes the audio features (6-D vector) for each .wav
% file in all directories (given in classNames)
%

clc;
fprintf('--------------------------------------------------------------------------\n')
fprintf('Real Time Microphone and Camera acquisition and audio-video processing.\n\n');
fprintf('Theodoros Giannakopoulos\n');
fprintf('http://www.di.uoa.gr/~tyiannak\n');
fprintf('Dep. of Informatics and Telecommunications,\n');
fprintf('University of Athens, Greece\n');
fprintf('--------------------------------------------------------------------------\n')


Dim = 6;

win = 0.050;
step = 0.050;

FeaturesNames = {'Std Energy Entropy','Std/mean ZCR','Std Rolloff','Std Spectral Centroid','Std Spectral Flux','Std/mean Energy'};


%
% STEP A: Feature Calculation:
%

for (c=1:length(classNames)) % for each class (and for respective directory):
    fprintf('Computing features for class %s...\n',classNames{c});
    D = dir([classNames{c} '//*.wav']);
    tempF = zeros(length(D),Dim);
    for (i=1:length(D)) % for each .wav file in the current directory:
        % compute statistics (6-D array)
        F = computeAllStatistics([classNames{c} '//' D(i).name], win, step);        
        % store statistics in the current row:
        tempF(i,:) = F';
    end
    % keep a different cell element for each feature matrix:
    Features{c} = tempF;
end

%
% STEP B:
% calculate and plot histograms:
%

Colors = [0 0 0;
          0 0 1;
          0 1 0;
          0 1 1;
          1 0 0;
          1 0 1;
          1 1 0;
          0 0.25 1;
          0.25 0 1;
          0 1 0.25;
          0.25 1 0];

figure;
for (f=1:Dim)
    subplot(3,2,f);
    hold on;
    for (c=1:length(classNames))
        tempF = Features{c}(:,f);
%        [H,X] = hist(tempF,20);
        [H,X] = myHist(tempF);
        p = plot(X,H);
        set(p,'Color',Colors(c,:));
        % get the 'others':
        tempFOthers = [];
        for (cc=1:length(classNames))
            if (cc~=c)
                tempFOthers = [tempFOthers;Features{cc}(:,f)];
            end
        end
        [E1, E2] = computeHistError(tempF, tempFOthers);
        Errors(f,c) = 100 * (E1+E2) / 2;
        hM(c) = max(H);        
    end
    [EMin,MMin] = min(Errors(f,:));
    [EMax,MMax] = max(Errors(f,:));    
    EMean = mean(Errors(f,:));

    str = ['legend(' '''' classNames{1} ''''];
    for (c=2:length(classNames))
        str = [str ',' '''' classNames{c} ''''];
    end
    str = [str ');'];
    eval(str);
    title(['BEST: ' num2str(EMin) '(' classNames{MMin} ')' ' MEAN: ' num2str(EMean) ' WORST: ' num2str(EMax) '(' classNames{MMax} ')']);
    text(0,max(hM)*0.80,FeaturesNames{f});
end
