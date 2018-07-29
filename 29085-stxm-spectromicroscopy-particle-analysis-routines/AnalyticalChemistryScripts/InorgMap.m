function [Aout]=InorgMap(S,Mask)
%% Calculates the % sp2 of a stack (S.spectr) region specified by linidxin
%% S.spectr is the stack data aligned and converted to OD
%% linidxin is the linear index defining the region over which to determine
%% the % sp2
%% 081201 Ryan C. Moffet 

Spectr=S.spectr;
energy=S.eVenergy;


%% Approximate Inorganic by linear extrapolation of pre-edge
x1temp=[energy(1),282];
x2temp=[282,283];

x1idx=find(energy<x1temp(2));
x2idx=find(energy>=x2temp(1) & energy<=x2temp(2));
x1=mean(energy(x1idx));
x2=mean(energy(x2idx));
y1=mean(Spectr(:,:,x1idx),3);
y2=mean(Spectr(:,:,x2idx),3);
m=(y2-y1)/(x2-x1);
m(m<0)=0;

for i=1:length(energy)
    y(:,:,i)=m.*energy(i)-m*x1+y1;
end

%% Calculate Areas
Ain=medfilt2(trapz(energy,y,3));
Atot=medfilt2(trapz(energy,Spectr,3));
Acarb=medfilt2(Atot-Ain);
Aout=abs(medfilt2(Ain./Acarb));
Aout=Aout.*Mask;
% Aout(Aout<1)=0;

