function music(i_say,g_aci,i_frek,lamda,or_say)
close all;
clc;
 sayac=0;
e_bosluk=lamda/2;
kp=2*pi/lamda;
d=e_bosluk;
disp(' ')
SNR=input(' SNR degerini giriniz (Maksimum gürültü için "0",minimum gürültü için "100"):');
disp(' ')
disp(' Eger girilen anten sayýsý minimum anten sayýsýnýn altýndaysa minimum deger alýnýr.')
disp(' ')
x=input(' Anten sayýsýný giriniz(minimum anten sayýsýný belirlemek için "0" girin):');
if x==0;
e_say=i_say+1;
else
e_say=x;
end
say=0;

tic;

while 0<e_say
sayac=sayac+1
%------------------------------
%isaratlerin üretilmesi
%------------------------------
Toplam_sinyal=zeros(i_say,or_say);
k=1 :or_say;
for i=1 : i_say;
Toplam_sinyal(i,:)=sqrt(2)*sin(2*i_frek(i)*pi*k);
end
figure(1);
plot(k,Toplam_sinyal(1,:));
grid on
hold on
xlabel('Örnek sayýlarý');
ylabel('Genlik');
title('Gelen isaret');
%-------------------------------------------------------------------

%Her bir elemana eklenen gürültü
%-------------------------------------------------------------------

   
    
gurultu=zeros(e_say,or_say);
gurultu_sbt=1/(10^(SNR/10));
for i=1 : e_say;
gurultu(i,:)=sqrt(gurultu_sbt)*randn(1,or_say);
end
%-------------------------------------------------------------
%Her bir sinyal için dizi yayýlma vektörünün üretilmesi
%-------------------------------------------------------------
yay_matris=zeros(e_say,i_say);
for i=1 : i_say;
k=0 : e_say-1;
yayilma=exp(j.*k*kp*d*sin(g_aci(i)*pi/180));
yay_matris(:,i)=yayilma.';
end
%-----------------------------------
% Elemanlardan alýnan dalga sekli
%-----------------------------------
U=zeros(e_say,or_say);
for i=1 : or_say;
U(:,i)=yay_matris*Toplam_sinyal(:,i)+gurultu(:,i);
end
%---------------------------------------
% Giris kovaryans matrisinin kestirimi
%---------------------------------------
Kov_matris=zeros(e_say,e_say);
for i=1:or_say;
kovaryans=U(:,i)*(U(:,i)');
Kov_matris=Kov_matris+kovaryans;
end
Kov_matris=Kov_matris/or_say;
%-----------------------------------------------------------
% Öz degerler ve iliskili öz vektörlerin bulunmasý
%-----------------------------------------------------------
[oz_matris,oz_deger]=eig(Kov_matris,'nobalance');
%-------------------------------------------
% Gelen isaret sayýsýnýn kestirilmesi
%-------------------------------------------
for i=1:e_say
deger(i)=oz_deger(i,i);
end
Sirali_deger=sort(deger);
artir=0;
for i=1: e_say
if Sirali_deger(i)<1.5*gurultu_sbt
artir=artir+1;
end
end
V_matris=zeros(e_say,artir);
Sirali_matris=zeros(e_say,e_say);
for i=1:e_say
for k=1:e_say
if Sirali_deger(i)== deger(k)
Sirali_matris(:,i)=oz_matris(:,k);
end
end
end
for i=1: artir
V_matris(:,artir-i+1)=Sirali_matris(:,i);
end
say=0;
for i=1: e_say
if abs((fliplr(Sirali_deger(i)))) > gurultu_sbt*[ones(1,i)]*15;
say=say+1;
end
end
if say==i_say;
break
end
e_say=e_say+1;
end
disp(' ')
gst=[' Anten sayýsý=' int2str(e_say)];
disp(gst)
figure(2);
plot([1:e_say],abs((fliplr(Sirali_deger))),'-+');
grid on
hold on
plot([1:e_say],gurultu_sbt*[ones(1,e_say)],'-o');
legend('öz deger','gürültü')
xlabel('Antenler');
ylabel('Öz degerler');
title('Alýnan isaretlerinin iliski matrisinin büyüklükleri');
q1=(g_aci(1)-10);
q2=(g_aci(i_say)+10);
q3=q2-q1;
f=zeros(1,10001);
i=1;
for adim= q1:q3/10000:q2
k=0:e_say-1;
yayilma=exp(j.*k*kp*d*sin(adim*pi/180));
a=yayilma.';
f(i)=(a'*a)/(a'*V_matris*V_matris'*a);
i=i+1;
end
adim= q1:q3/10000:q2;
f=abs(f)./max(abs(f));
figure(3)
plot(adim,20*log10(f));
grid on
xlabel('AÇI');
ylabel('Büyüklük(dB)');
title('MUSIC algoritmasýyla açý kestirimi');
toc;