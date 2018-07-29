function [pulse] = getpulse(pulse)
pulse.Ts = 1;
pulse.NSS = 512;        % Number of Samples per Chip If pulse.NSS = 1, no pulse used
pulse = pshape(pulse); % Filter Coeficients
[pulse.m1, pulse.m2, pulse.w1, pulse.w2] = get_param(pulse);

function [pulse] = pshape(pulse)
Tc = pulse.Ts;
ts = Tc/pulse.NSS;
% get the pulse shapes
pulse.T = -Tc/2:ts:Tc/2;
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

function [m1, m2, w1, w2] = get_param(pulse)
Ts = pulse.Ts;
%Pulse Shape

fmin = 0; fmax = 16/Ts; nf = 512;
df = (fmax-fmin)/nf; f = (fmin:df:fmax); H = zeros(1,length(f));

for n = 0:nf,
    fp = n*df;
    H(n+1) = trapz(pulse.T,pulse.hTx.*exp(-2*pi*j*fp*pulse.T));
end
H = real(H);

H = (abs(H)).^2;
H = [fliplr(H(2:end)) H];
ff =  [-fliplr(f(2:end)) f];

nt = 8192;
tt = 0:Ts/nt:Ts;
for n = 0:nt
    h(n+1) = trapz(ff, H.*exp(2*pi*j*ff*tt(n+1)));
end
h = real(h);
h2 = fliplr(real(h));

m1 = trapz(tt , h.*h);
m2 = trapz(tt , h.*h2);
w1 = trapz(tt , ((h.*h) + (h2.*h2)).^2);
w2 = trapz(tt , ((h.*h).*(h2.*h2)));