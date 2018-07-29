function [pulse, T] = pshape(pulse)
pulse.adv = ceil(pulse.NSS*pulse.samp);

Tc = pulse.Tc;
ts = Tc/pulse.NSS;
% get the pulse shapes
pulse.T = -Tc/2:ts:Tc/2;
%PSHAPE Pulse shapes
switch pulse.type
    case{1}   %rectangular pulse
        T = -Tc/2:ts:Tc/2;
        for i = 1:length(T)
            t = T(i);
            if t >= (-Tc/2) & t <= Tc/2
                pulse.hTx(i) = 1;
            else
                pulse.hTx(i) = 0;
            end
        end

    case {2}   %Half Sine MSK
        T = 0 : ts : Tc;
        for i = 1:length(T)
            t = T(i);
            if t >= 0 & t <= Tc
                pulse.hTx(i) = sqrt(2)*(sin(pi*t/Tc));
            else
                pulse.hTx(i) = 0;
            end
        end

    case  {3}   %Guassian Waveform
        T = -Tc/2:ts:Tc/2;
        for i = 1:length(T)
            t = T(i);
            if t >= (-Tc/2) & t <= Tc/2
                pulse.hTx(i) = sqrt(sqrt(4.5))* exp(- (9*pi*t^2)/(4*Tc^2));
            else
                pulse.hTx(i) = 0;
            end
        end

    case  {4}   %Raised Cos
        T = 0 : ts : Tc;
        for i = 1:length(T)
            t = T(i);
            if t >= 0 & t <= Tc
                pulse.hTx(i) = sqrt(2/3)*(1-(cos(2*pi*t/Tc)));
            else
                pulse.hTx(i) = 0;
            end
        end
    case  {5}   %Blackman Window
        T = 0 : ts : Tc;
        k1 = 0.42; k2 = 0.5; k3 = 0.08;
        c = sqrt(1/(k1^2 + k2^2/2 +k3^2));
        for i = 1:length(T)
            t = T(i);
            if t >= 0 & t <= Tc
                pulse.hTx(i) = c*(k1 - k2*cos(2*pi*t/Tc)+ k3*cos(4*pi*t/Tc));
            else
                pulse.hTx(i) = 0;
            end
        end
        
    otherwise
        disp('Unknown Pulse.')
end
pulse.delay = max([length(pulse.hTx) length(pulse.NSS)])-3;
pulse.hRx = fliplr(conj(pulse.hTx));
pulse.hTx = pulse.hTx/sqrt(sum(pulse.hTx.^2));
pulse.hRx = pulse.hRx/sqrt(sum(pulse.hRx.^2));

