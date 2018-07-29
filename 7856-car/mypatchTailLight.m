function f=mypatch(p,kb,kc)
%ska ta emot en vektor av fyra startpunkter och två vektorer med lutningar
%ska återge ett rutnät av bezier-kurvor och rita det

t=(0:0.1:1)'; n=10; rr=[];
rrx=[]; rry=[]; rrz=[];
F=[(1-t).^3 3*t.*(1-t).^2 3*(1-t).*t.^2 t.^3];
for i=1:length(p)-1
    b=p(i,:)+kb(i,:);
    c=p(i+1,:)+kc(i,:);
    r=F*[p(i,:); b; c; p(i+1,:)];
    rr=[rr; r];
    rrx=[rrx r(:,1)];
    rry=[rry r(:,2)];
    rrz=[rrz r(:,3)];
end

diff1=kc(3,:)-kb(1,:);
diff2=kb(3,:)-kc(1,:);
diff1n=diff1/n;
diff2n=diff2/n;

rikt1=[];  rikt2=[];

for i=1:n-1
    rikt1=[rikt1; kb(1,:)+i*diff1n];
end

for i=1:n-1
    rikt2=[rikt2; kc(1,:)+i*diff2n];
end

r4=[]; r44x=[]; r44y=[]; r44z=[];
N=(n+1)*4;
for j=2:2
for i=1:n-1
    pb=rr(n*(j-1)+j+i,:);
    ps=rr(N-n*(j-1)+(n-i),:);
    b=pb+rikt2(i,:);
    c=ps+rikt1(i,:);
    r4=F*[pb;b;c;ps];
    %plot3(r4(:,1),r4(:,2),r4(:,3)), hold on
    r44x=[r44x r4(:,1)];
    r44y=[r44y r4(:,2)];
    r44z=[r44z r4(:,3)];
end
end

r44x=[rrx(11:-1:1,1) r44x rrx(1:11,3)];    %Om n=5 och t=0:0.2:1; sätt 11 till 6
r44y=[rry(11:-1:1,1) r44y rry(1:11,3)];    %Om n=10 och t=0:0.1:1; sätt 6 till 11
r44z=[rrz(11:-1:1,1) r44z rrz(1:11,3)];
r44x;

%for i=2:5
%    plot3(r44x(i,:),r44y(i,:),r44z(i,:)), hold on
%end
%mesh(r44x,r44y,r44z);
surface(r44x,r44y,r44z,...
    'EdgeColor','none',...
    'FaceColor',[1 0.1 0.1],...
    'FaceLighting','phong',...
    'AmbientStrength',0.3,...
    'DiffuseStrength',0.6,...
    'Clipping','off',...
    'BackFaceLighting','reverselit',...
    'SpecularStrength',1.1,...
    'SpecularColorReflectance',1,...
    'SpecularExponent',7), hold on;


f=[r44x r44y r44z];

%plot3(rr(:,1),rr(:,2),rr(:,3)), hold on, axis equal