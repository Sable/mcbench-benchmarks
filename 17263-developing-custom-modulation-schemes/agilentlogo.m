function res=agilentlogo()
% Creates a reasonable Agilent logo in the complex plane for
% demoing custom modulation/demodulation schemes
foo=ones(1,32);
j=1;
for k=0:pi/4:15/8*pi
    foo(j)=     .25*(cos(k)+i*sin(k));
    foo(j+1)=   .5*(cos(k)+i*sin(k));
    foo(j+2)=   .75*(cos(k)+i*sin(k));
    foo(j+3)=   cos(k)+i*sin(k);
    j=j+4;
end

%%
res=foo';
end