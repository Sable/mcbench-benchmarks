clear; clf;
        % Numarul de puncte considerate
N=512;
b=1:N;
        % Perioada de esantionare [s]
Ts=1/128;
        % Frecventa de esantionare [Hz]
fs=1/Ts;
        % Frecventele si intervalele de esantionare
f=(b-1)/N*fs;
ts=Ts*(b-1);
        % Amplitudinele si frecventele componentelor
a1=7; a2=3;
f1=16; f2=48;
        % Cele doua semnale care se insumeaza
x1=a1*sin(2*pi*f1*ts);
x2=a2*sin(2*pi*f2*ts);
x=x1+x2;
        % Prima reprezentare grafica
        % (o portiune din semnalul analizat)
figure(1)
plot(ts,x,'r','LineWidth',1.5)
axis([0,0.5,-10,10])
xlabel('t [s]')
ylabel('x')
        % Efectuarea transformarii Fourier
y=fft(x);
        % Extragerea modulului si fazei componentelor
val_abs=abs(y);
faza=180/pi*unwrap(angle(y));
        % A doua reprezentare grafica: caracteristicile
        % amplitudine-frecventa si faza-frecventa
figure(2)
[HAX,HF1,HF2]=plotyy(f,val_abs,f,faza);
set(get(HAX(1),'Ylabel'),'String','Amplitudine [-]')
set(get(HAX(2),'Ylabel'),'String','Faza [°]')
xlabel('Frecventa [Hz]')
set(HF1,'LineWidth',1.5)
set(HF2,'LineWidth',1.5)
