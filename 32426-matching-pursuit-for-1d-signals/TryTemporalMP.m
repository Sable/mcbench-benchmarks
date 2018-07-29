%Build a sparse representation of a signal
sig = load('gong.mat'); %included in matlab

%Build a basis of Gabors
rg = (-500:500)';
sigmas = exp(log(2):.3:log(200));
gabors = exp(-.5*(rg.^2)*sigmas.^(-2)).*cos(rg*sigmas.^(-1)*2*pi*2);

%Express signal as a sparse sum of Gabors
[ws,r] = temporalMP(sig.y,gabors,false,5000);

%%
subplot(3,1,1);
plot(gabors);
title('Basis');
subplot(3,1,2);
plot([sig.y,r]);
legend('signal','approximation');
subplot(3,1,3);
%the convolution here is to make the spikes visible
imagesc(conv2(ws,exp(-rg.^2/2/20^2),'same')');
ylabel('increasing time ->');
ylabel('increasing frequency ->');
title(sprintf('weights (%d non-zero weights)',nnz(ws(:))));

%%
%listen to the original sound and its approximation
sound(sig.y,sig.Fs);

%%
sound(r,sig.Fs);

%% Same, but this time only allow positive weights
%Express gong signal as a sparse sum of Gabors
[ws2,r2] = temporalMP(sig.y,gabors,true,5000);
%%
subplot(3,1,1);
plot(gabors);
title('Basis');
subplot(3,1,2);
plot([sig.y,r2]);
legend('signal','approximation');
subplot(3,1,3);
%the convolution here is to make the spikes visible
imagesc(conv2(ws2,exp(-rg.^2/2/20^2),'same')');
ylabel('increasing time ->');
ylabel('increasing frequency ->');
title(sprintf('weights (%d non-zero weights)',nnz(ws(:))));

%%
%listen to the original sound and its approximation
sound(sig.y,sig.Fs);

%%
sound(r2,sig.Fs);

%% Same, but this time add a deadzone of 3 samples around basis functions
[ws2,r2] = temporalMP(sig.y,gabors,true,5000,0,3);
%%
subplot(3,1,1);
plot(gabors);
title('Basis');
subplot(3,1,2);
plot([sig.y,r2]);
legend('signal','approximation');
subplot(3,1,3);
%the convolution here is to make the spikes visible
imagesc(conv2(ws2,exp(-rg.^2/2/20^2),'same')');
ylabel('increasing time ->');
ylabel('increasing frequency ->');
title(sprintf('weights (%d non-zero weights)',nnz(ws(:))));

%%
%Demonstration of deadzone
[t,~] = find(ws2~=0);
min(diff(sort(t)))

%Should be 3

%%
%listen to the original sound and its approximation
sound(sig.y,sig.Fs);

%%
sound(r2,sig.Fs);
