function gain=noise_sup(gain,G_n) 
% Ïîäàâëåíèå øóìîâ
% ÂÕÎÄÍÛÅ ÏÅĞÅÌÅÍÍÛÅ:
%   gain - çíà÷åíèå óñèëåíèÿ
%   G_n  - óğîâåíü øóìà
% ÂÛÕÎÄÍÛÅ ÏÀĞÀÌÅÒĞÛ:
%   G_n  - óğîâåíü øóìà

max_noise=20; 
max_atten=6; 
if G_n>max_noise; 
    G_n=max_noise; 
end 
gain_lev=gain-G_n-3; 
if gain_lev>0.001 
    suppress=-10*log10(1-10^(-0.1*gain_lev)); 
    if suppress>max_atten 
        suppress=max_atten; 
    end
else
    suppress=max_atten;
end 
gain=gain-suppress;