function noOffset = removeOffset(readings,refFreq)
%this function removes the offset from frequency readings by calculating
%the mean, subtracting the ref freq by the mean, and then adding the diff
%to the array of readings

offset = refFreq - mean(readings);
noOffset = readings + offset;
