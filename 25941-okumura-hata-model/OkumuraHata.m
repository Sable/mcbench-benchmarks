function LP=OkumuraHata(fc,hb,hm,d,flag)

%MODELO OKUMURA-HATA para la estimacion de las perdidas de propagacion en
%areas urbanas, suburbanas y abiertas.

%fc-> frecuencia en (MHZ) de 150-1500 MHZ
%hb-> altura efectiva de la antena transmisora en (m) de 30-200 m
%hm-> altura efectiva de la antena receptora en (m) de 1-10 m
%d-> distancia de separacion entre Tx y Rx en (Km) de 1-100 Km
%flag-> tipo de ambiente 1. urbano, 2. suburbano, 3. abierto

%factor de correccion altura de antena efectiva movil


%perdidas por trayectoria en areas urbanas (media) (dB)
Lp=69.55+26.16*log10(fc)-13.82*log10(hb)-a(hm,fc)+(44.9-6.55*log10(hb))*log10(d);

%perdidas por trayectoria en areas suburbanas (media) (dB)
Lps=Lp-2*(log10(fc/28))^2-5.4;

%perdidas por trayectoria en areas abiertas (media) (dB)
Lpo=Lp-4.78*(log10(fc))^2-18.33*log10(fc)-40.98;

%campo electrico (V/m)
%E=69.82-6.16*log10(fc)+13.82*log10(hb)+a(hm,fc)-(44.9-6.55*log10(hb))*log10(d^b);

switch flag
 case 1
    LP=Lp;
  case 2
    LP=Lps;
  case 3
    LP=Lpo;
  otherwise
    disp('error')
end


function Factor= a(hm,fc)

%para ciudades pequeñas y medianas
Factor=(1.1*log10(fc)-0.7)*hm-(1.56*log10(fc)-0.8);

