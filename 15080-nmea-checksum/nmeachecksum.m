%function checksum = CreateNMEAChecksum(NMEA_String)
function checksum = nmeachecksum(NMEA_String)

checksum = 0; %vynulování proměnné

% see if string contains the * which starts the checksum and keep string
% upto * for generating checksum
NMEA_String = strtok(NMEA_String,'*');

NMEA_String_d = double(NMEA_String);    % convert characters in string to double values
for count = 2:length(NMEA_String)       % checksum calculation ignores $ at start
    checksum = bitxor(checksum,NMEA_String_d(count));  % checksum calculation
    checksum = uint16(checksum);        % make sure that checksum is unsigned int16
end

% convert checksum to hex value
checksum = double(checksum);
checksum = dec2hex(checksum);

% add leading zero to checksum if it is a single digit, e.g. 4 has a 0
% added so that the checksum is 04
if length(checksum) == 1
    checksum = strcat('0',checksum);
end