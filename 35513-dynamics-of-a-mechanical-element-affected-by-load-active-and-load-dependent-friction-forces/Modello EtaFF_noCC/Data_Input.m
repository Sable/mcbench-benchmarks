function [Com] = Data_Input(Time,ComandoC,ComandoC0,startCC,ComandoR,ComandoR0,startCR,ComandoS,FreqS,ComandoS0,FreqS0,startCS)

if(Time < startCC)
    ComC=ComandoC0;
else
    ComC=ComandoC;
end
if(Time < startCR)
    ComR=ComandoR0;
    startR=0;
    K=0;
else
    ComR=ComandoR;
    startR=startCR;
    K=ComandoR0*startCR;
end
if(Time < startCS)
    ComS=ComandoS0;
    Freq=FreqS0;
    T=0;
else
    ComS=ComandoS;
    Freq=FreqS;
    T=startCS;
end
Com=ComC+K+ComR*(Time-startR)+ComS*sin(Freq*(Time-T));
end