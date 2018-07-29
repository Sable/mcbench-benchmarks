function [y]=ReconHANTSData(amp,phi,nb)
nf=max(size(amp));

y=zeros(1,nb);
a_Coef=amp.*cos(phi*pi/180);
b_Coef=amp.*sin(phi*pi/180);
for i=1:nf
    tt=(i-1)*2*pi*[0:nb-1]/nb;
    y=y+a_Coef(i)*cos(tt)+b_Coef(i)*sin(tt);
end
y=y';
end

