%Run only this main program. No need to run the other functions separately
clear; clc;
DEPSK_mrc(1);  %performance of DEPSK by 1 Rx antenna
hold on;
clear; clc;
DEPSK_mrc(2);  %performance of DEPSK by 2 Rx antenna 
hold on;
clear; clc;
BPSK_mrc(1);  %performance of BPSK by 1 Rx antenna
hold on;
clear; clc;
BPSK_mrc(2);  %performance of BPSK by 2 Rx antenna 