
clear
%Process definition
ar = rc2arset([1 -.4 .2]);
ma = rc2arset([1 .8]);
%End of Process definition
n_obs = 10;

rch = [1 -.6 -.3 -.2];
Lar = length(rch)-1;
arh_set = rc2arset(rch,0:Lar);

%function pe_set = prederrAR(rc,cov)
%PREDERRAR Prediction error of AR models of increasing order
vareps = 1/pgain(ar,ma);
cor = arma2cor(ar,ma,Lar);

r = [cor(end:-1:1) cor(2:end)];
pe(1) = 1;
eo = r; %cor;
fo = r; %cor;
pe_old(1) = 1;
for p = 1:Lar
    carh = [arh_set{p+1} zeros(1,Lar-p)];
    crc = rch(p+1);
    ahahp = convol(fliplr(carh),carh)
    ahah  = convol(carh,carh);
    e = xcorr(ahah,r);  e = e(Lar+1:3*Lar+1);
    f = xcorr(ahahp,r); f = f(2*Lar+1:3*Lar+1);
    %Recursieve berekening van e en f.
    er = NaN*ones(1,Lar+1);
    for q = p:Lar
        er(q+1) = eo(q+1) + 2*crc*fo(q-p+1) + crc^2*eo(2*p-q+1);
    end
    fr = NaN*ones(1,Lar+1);
%     for q = 0:Lar-p
%         fr(q+1) = (1+crc^2)*fo(q+1) + crc*eo(p+q+1); %Klopt alleen voor witte ruis!
%     end
%     e,er
%     f,fr;
    disp(' ')
    pe(p+1) = f(Lar+1) %werkt

    %Preparations for next step
    eo = e;
    fo = f;

    %Old PE
    pe_old(p+1) = (moderr(carh,1,ar,ma,1)+1)*vareps;
end