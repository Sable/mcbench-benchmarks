%Bob Gess, June 2008, for EE473

%PRN code sequence generators for both I and Q channel
%spreading sequence three shift registers combined to output a 3255 bit  
%psuedo-random two separate prn codes - one for I channel and one for Q
%channel.
%For/next loop severely slows program down.  Uncommenting "n" allows
%verification that your computer is actually alive and running the program.

%To modify bandwidth of PRN sequence, see lines 57 thru 83.

function [seq1,seq2]=a_prnseq(chip_rate)

%N=1e3;		        % Number of data bits(bit rate)
fs=40*2e3;		    % Sampling frequency
Fn=fs/2;            % Nyquist frequency


format compact;
%s=[1 0 0];s0=s';%3-bit shift register - period=7 bits
%g=[1 1 0 0;0 0 1 0;1 0 0 1;1 0 0 0];

q=[1 0 0 0];q0=q';%4-bit shift register - period = 15 bits
h=[1 1 0 0;0 0 1 0;1 0 0 1;1 0 0 0];

r=[1 0 0 0 0 0];r0=r';%6-bit shift register - period = 63 bits
r1=[1 0 0 0 0 1];r2=r1';
i1=[1 1 0 0 0 0;0 0 1 0 0 0;0 0 0 1 0 0;1 0 0 0 1 0;0 0 0 0 0 1;1 0 0 0 0 0];


%Generating long codes runs into problems with only 17 sig digits.  Have to
%use a for loop to generate vector, which slows down the process badly.

%    a(1)=mod(s*s0,2);
    b(1)=mod(q*q0,2);
    c(1)=mod(r*r0,2);c1(1)=mod(r1*r2,2);
%    a(2)=mod(mod(s*g,2)*s0,2);
    b(2)=mod(mod(q*h,2)*q0,2);
    c(2)=mod(mod(r*i1,2)*r0,2);c1(2)=mod(mod(r1*i1,2)*r2,2);
%    g1=g;
    h1=h;
    i3=i1;

    for n=3:945    %LCM of 4-bit,& 6-bit = 945 bits
    for m=1:n-2
%        g1=mod(g*g1,2);
        h1=mod(h*h1,2);
        i3=mod(i1*i3,2);
    end
%    a(n)=mod(mod(s*g1,2)*s0,2);
    b(n)=mod(mod(q*h1,2)*q0,2);
    c(n)=mod(mod(r*i3,2)*r0,2);c1(n)=mod(mod(r1*i3,2)*r2,2);
%    n      %Shows program is actually running when you're trying to debug

end
for m=1:945
    e(m)=-1;
end
d=mod(b+c,2);d1=mod(b+c1,2);
d=2*d;d1=2*d1;
spread1=d+e;
spread2=d1+e;

%This is to set the code vector to the same length as the data vector
o=0;
p=40000/chip_rate;  %generating 2 vectors 40,000 bits long
for m=1:945
    for n=1:p   
        o=o+1;
        sequ1(o)=spread1(m);
        sequ2(o)=spread2(m);
    end
end

seq1=sequ1;
seq2=sequ2;

q=floor(40000/(p*945));
r=((40000/(p*945))-floor(40000/(p*945)))*(p*945);

for n=1:q-1       %set spreader vector to same length as signal vector
        seq1=[seq1 sequ1];
        seq2=[seq2 sequ2];
end

%finish with remainder of 40000/(945*n)
o=0;
for m=1:r     %whatever remainder is
    o=o+1;
    sequa1(o)=sequ1(m);
    sequa2(o)=sequ2(m);
end
seq1=[seq1 sequa1];
seq2=[seq2 sequa2];


end



