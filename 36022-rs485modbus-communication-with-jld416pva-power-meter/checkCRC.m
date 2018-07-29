function crcCheck = checkCRC(response)
receivedMsg = response;
challengeMsg = append_crc(response(1:length(response)-2));
if all(challengeMsg==receivedMsg)
    crcCheck = 1;
else
    crcCheck = 0;
end