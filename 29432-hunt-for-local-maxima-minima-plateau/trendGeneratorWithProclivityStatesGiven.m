function trend = trendGeneratorWithProclivityStatesGiven (statesMapProfile, startValue, stepSize)
stateModes = {'plateau', 'ascent', 'descent'};

% statesMapProfile -> statesMap
% statesMapProfile = [{'plateau'}, {3}, {'ascent'}, {2}, {'descent'}, {3}];
% statesMap = [ ...
%   {'plateau'}, {'plateau'}, {'plateau'}, ...
%   {'ascent'}, {'ascent'}, ...
%   {'descent'}, {'descent'}, {'descent'}];
% isnumeric(cell2mat(statesMapProfile(1))) = 0;
% isnumeric(cell2mat(statesMapProfile(2))) = 1;

% count the number of cells to build statesMap
totalNumberOfCells = 0;

for i = 2:2:length(statesMapProfile)
    totalNumberOfCells = totalNumberOfCells + cell2mat(statesMapProfile(i));
end

% construct states map
statesMap = cell(1, totalNumberOfCells);

count = 1;
for i = 1:2:(length(statesMapProfile)-1)
    for j = 1:cell2mat(statesMapProfile(i+1)) % for each proclivity type, replicate the number of the same tags
        statesMap(count) = statesMapProfile(i);
        count = count + 1;
    end
end

% generate trend signals
trend = zeros(1, length(statesMap)+1); % create a plateau
trend(1) = startValue;

for i = 2:length(statesMap)+1
    switch lower(char(statesMap(i-1)))
        case stateModes(1)
            trend(i) = trend(i-1);
        case stateModes(2)
            trend(i) = trend(i-1) + stepSize;
        case stateModes(3)
            trend(i) = trend(i-1) - stepSize;
        otherwise
            disp('Unknown method.')
    end
end

end