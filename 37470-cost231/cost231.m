function loss=cost231(d,nf,kw)
%%
% d is the distance from the AP
% nf is the number of the floors encoutered  
% kw is the vector cointaining the number of the type walls met
%  - the first element is for Light wall: plasterboard,particle board or thin
%    (<10 cm), light concrete wall.
%  - the second element is for Heavy wall: thick (>10cm), concrete or brick


% Loss for wall types in dB
Lw=0;
Lwa=[3.4 6.9];
for i=1:length(kw)
    Lw=Lw+kw(i)*Lwa(i);
end


% Loss for the floors in dB
Lfi=18.3;
Lf=20*log10(d)+nf^((nf+2)/(nf+1))*Lfi;


% Free space Path Loss in dB
lambda=0.125;
do=1;
Lo=20*log10((4*pi*do/lambda)^2);


loss=Lw+Lf+Lo;




