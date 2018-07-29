% Simple algorithm to calculate the deflection, bending moment, shear force in a
% cantilever beam.
% load = loading distribution

% Example,
% 1.Uniform loading of 10 N/m: load=repmat(10,1,1001), l=20, dl=0.02
% 2.Point loading with P=400 N, load=[repmat(0,1,999) 10000 10000], l=20, dl=0.02

% length(load)=(l/dl)

function deflection=beam_deflection(load,ei,l,dl)
if length(load)~=(l/dl+1)
    error('Check inputs')
end
y=0:dl:l;
m=sum((y.*load))*dl;
v=sum(load)*dl;
u_4=load/ei;
u_3=v/ei;
for i=2:length(load)
    u_3(i)=u_3(i-1)-u_4(i-1)*dl;
end
u_2=m/ei;
for i=2:length(load)
    u_2(i)=u_2(i-1)-u_3(i-1)*dl;
end
u_1=0;
for i=2:length(load)
    u_1(i)=u_1(i-1)+u_2(i-1)*dl;
end
u=0;
for i=2:length(load)
    u(i)=u(i-1)+u_1(i-1)*dl;
end
deflection=u;
plot(y,u_2*ei)
hold on
plot(y,u_3*ei,'r')
legend('bending moment','shear force')
xlabel('length along the beam')
ylabel(' bending moment and shear force (SI units)')
grid
hold off
figure,plot(y,u,'r')
xlabel('length along the beam')
ylabel('deflection')
grid
title('Deflection')

