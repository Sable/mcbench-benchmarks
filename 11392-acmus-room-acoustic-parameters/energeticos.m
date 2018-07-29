%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% energeticos.m

%This function calculate energy related room acoustic parameters Clarity,
%Definition and Center Time.
%A squared room impulse response should be inputed, with its sampling
%frequency.


function [C50,C80,D50,D80,CT]=energeticos(energia,Fs);

t50 = round(0.05*Fs);
t80 = round(0.08*Fs);

%Clarity = razao entre energia inicial do sinal, e energia remanescente.
C50 = 10*log10(integral(energia(1:t50),Fs)/integral(energia(t50:end),Fs));
C80 = 10*log10(integral(energia(1:t80),Fs)/integral(energia(t80:end),Fs));

%Definition = razao entre energia inicial do sinal, e energia total do sinal.
E = integral(energia,Fs);
D50 = integral(energia(1:t50),Fs)/E*100;
D80 = integral(energia(1:t80),Fs)/E*100;

%Tempo Central, equivalente ao centro de gravidade da curva de energia.
x=(0:length(energia)-1)/Fs;
CT = integral(energia(:).*x(:),Fs)/E;

end

function P = integral(p,Fs)
P = (sum(p)-(p(1)+p(end))/2)/Fs;
end