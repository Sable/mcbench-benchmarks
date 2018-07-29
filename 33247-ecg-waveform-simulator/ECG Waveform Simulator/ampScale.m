function ecgWave2 = ampScale(ecgWave)


%This eliminates the offset that is added to each wave. A new offset can be
%easily set with the 33521A or 33522A
last = size(ecgWave);
offset = ecgWave(last(2));
ecgWave = ecgWave - offset;

%The following code scales the waveform points between 1 and -1
%get max and min array elements
mx = max(ecgWave);
mn = min(ecgWave);
mn = abs(mn);

%Use absolute max value of ecg waveform to scale ecg waveform points
if mx > mn
    ecgWave2 = ecgWave / mx;
else 
    ecgWave2 = ecgWave / mn;
end