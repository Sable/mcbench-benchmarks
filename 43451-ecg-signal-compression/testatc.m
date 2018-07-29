load('Sig100ch1.mat')
N_Sig = awgn(ans,30);

DeN_Sig = sgolayfilt(N_Sig,15,17);
a = atc(DeN_Sig,0.005);

subplot(4,1,1);plot(1:length(ans),ans);
title('Original ECG signal');
subplot(4,1,2);plot(1:length(N_Sig),N_Sig);
title('Noisy ECG signal');
subplot(4,1,3);plot(1:length(DeN_Sig),DeN_Sig);
title('Denoised ECG signal');
subplot(4,1,4);plot(1:length(a),a);
title('Compressed ECG signal');
