function fileTimeStamped = timeStampedFile( file, numberOfFileExtensions, secondsMode )
%TIMESTAMPEDFILE 
% secondsMode = sec_ON, msec_ON, sec_OFF

% timeStamp
[year month dayOfMonth hour min sec] = datevec(now);
timeStamp = [month dayOfMonth hour min sec];

timeStampStr = cell(1, length(timeStamp)+1); % + year
timeStampStr(1) = {num2str(year)};

for i = 1:length(timeStamp)
    if (length(num2str(timeStamp(i))) == 1)
        timeStampStr(i+1) = {strcat('0', num2str(timeStamp(i)))};
    else
        timeStampStr(i+1) = {num2str(timeStamp(i))};
    end    
end

[sec msec] = strtok(timeStampStr(end), '.');

if (length(char(sec)) == 1)
    secStr = strcat('0', sec);
else
    secStr = sec;
end

if (strcmp(secondsMode, 'msec_ON'))
    timeStampStrFormatted = strcat(timeStampStr(1),'-', ...
        timeStampStr(2),'.', timeStampStr(3),'_',timeStampStr(4),timeStampStr(5),'hr', secStr, msec, 'sec');    
elseif(strcmp(secondsMode, 'sec_ON')) % sec is to be stated
    timeStampStrFormatted = strcat(timeStampStr(1),'-', ...
        timeStampStr(2),'.', timeStampStr(3),'_',timeStampStr(4),timeStampStr(5),'hr', secStr,'sec');
else % exclude secs and msecs [sec_OFF]    
    timeStampStrFormatted = strcat(timeStampStr(1),'-', ...
        timeStampStr(2),'.', timeStampStr(3),'_',timeStampStr(4),timeStampStr(5),'hr');
end

positionsOfDotsInStr = strfind(file, '.');
% for .tar.gz, it is 'end-1', else it is 'end'
offset = numberOfFileExtensions - 1;
if (length(positionsOfDotsInStr) ~= 0)
    fileName = file(1:(positionsOfDotsInStr(end-offset)-1));
    fileType = file((positionsOfDotsInStr(end-offset)+1):end);
end

fileTimeStamped = strcat(fileName, '_', timeStampStrFormatted,'.', fileType);

end

