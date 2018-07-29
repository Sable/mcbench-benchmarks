function vad_directed_by_noise_classification

clc
clear all
close all
%%  download from http://spib.rice.edu/spib/select.
noise = wavread('white_8000.wav'); % noise signal, it can be changed!

db = 5;  % SNR

sig = wavread('s18.wav'); % clean speech signal
label = wavread('l18.wav'); % vad label
hlab=vadlabel(label);
%%

sig = sig/max(abs(sig));
ls = length(sig);
ln = length(noise);
ran = round((ln-ls-1)*rand(1));
noi = noise(ran:ran+ls-1);
snoi = snrdbadd(sig,noi,db);

sfr = snoi(1:512); sfr = sfr/max(sfr);

% noise classification
predict_label = noise_classification(sfr);

%
switch predict_label
    case 1
        load modelbab
        disp('babble noise')
    case 2
        
        load modelfac
        disp('factory noise')
        
    case 3      
        load modelpink
        disp('pink noise')
    case 4
        
        load modelvol
        disp('volvo noise') 
    case 5
        
        load modelwh
        disp('white noise')
        
end
%% vad directed by noise classification  

 vad = vad_test(snoi,model,coeff);
 
 plot(snoi,'k')
 hold on
 plot(sig,'g')
 
 plot(vad,'r')


 [Pcs Pcf Pf] = hrate(hlab,vad)


