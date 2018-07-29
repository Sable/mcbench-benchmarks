%Voice Based Biometric System
%By Ambavi K. Patel.


function f1 = mel2freq (mel1)
f1 = 700*((10.^(mel1 ./2595)) -1);   % compute frequency from mel value
