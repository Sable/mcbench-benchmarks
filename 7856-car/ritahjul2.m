function f=ritahjul2(x,y,z)
theta=0:2*pi/30:2*pi; R=sqrt(1.1^2+1); theta3=0.7399400734:-0.7399400734/5:0;
X=zeros(31,1);        Z=1.1*cos(theta)'; Y=1.1*sin(theta)';  
X=[X 1.1*ones(31,1)]; Z=[Z cos(theta)']; Y=[Y sin(theta)'];
for i=2:6
    X=[X R*cos(theta3(i))*ones(31,1)];
    Y=[Y R*sin(theta3(i))*sin(theta)'];
    Z=[Z R*sin(theta3(i))*cos(theta)'];
end
Y,
%surf(-(X+x),Y+y,Z+z), hold on
surface(-(X+x),Y+y,Z+z,...
    'EdgeColor','none',...
    'FaceColor',[0.9 0.9 0.9],...
    'FaceLighting','flat',...
    'AmbientStrength',0.3,...
    'DiffuseStrength',0.6,...
    'Clipping','off',...
    'BackFaceLighting','lit',...
    'SpecularStrength',1.1,...
    'SpecularColorReflectance',1,...
    'SpecularExponent',7), hold on;


fi=0:pi/30:pi/2; a=1.1; d=1.5; b=4;

X2=[d*(1-cos(fi(1)))*ones(31,1)];
Y2=[a*sin(theta)'+sin(theta)'*b*sin(fi(1))];
Z2=[a*cos(theta)'+cos(theta)'*b*sin(fi(1))];

for i=2:length(fi)
    X2=[X2 d*(1-cos(fi(i)))*ones(31,1)];
    Y2=[Y2 a*sin(theta)'+sin(theta)'*b*sin(fi(i))];
    Z2=[Z2 a*cos(theta)'+cos(theta)'*b*sin(fi(i))];
end

X3=[]; 
for i=1:15
    n=2*i; 
    X3=[X3; X2(n-1,:); X2(n,:)];
    X3=[X3; zeros(2,16)]; 
end
X3=[X3; X2(31,:)];  
X3=[X3 d*ones(61,1) d*ones(61,1) (d-0.1)*ones(61,1)];

Y3=[Y2(1,:)]; Z3=[Z2(1,:)];
for i=2:31
    Y3=[Y3; Y2(i,:); Y2(i,:)];
    Z3=[Z3; Z2(i,:); Z2(i,:)];
end
Y3=[Y3 Y3(:,16) 1.1*Y3(:,16) 1.1*Y3(:,16)];   % 1.2 * b  = 1.2 * 4 = 4.8
Z3=[Z3 Z3(:,16) 1.1*Z3(:,16) 1.1*Z3(:,16)];

%surf(-(X3+x),Y3+y,Z3+z), hold on
surface(-(X3+x),Y3+y,Z3+z,...
    'EdgeColor','none',...
    'FaceColor',[0.9 0.9 0.9],...
    'FaceLighting','flat',...
    'AmbientStrength',0.3,...
    'DiffuseStrength',0.6,...
    'Clipping','off',...
    'BackFaceLighting','lit',...
    'SpecularStrength',1.1,...
    'SpecularColorReflectance',1,...
    'SpecularExponent',7), hold on;


FI=0.35:-0.35/5:-0.35; r=5; theta2=0:2*pi/120:2*pi; X4=[]; Y4=[]; Z4=[];

for i=1:11
    X4=[X4 -3.25+r*cos(FI(i))*cos(FI(i))*ones(181,1)]; %ändra till 181 då du lagt till en kolumn i Y5 och Z5
end

for i=1:11
    Y4=[Y4 (5.2+r*sin(FI(1)))*sin(theta2)'-r*sin(FI(i))*sin(theta2)'];
    Z4=[Z4 (5.2+r*sin(FI(1)))*cos(theta2)'-r*sin(FI(i))*cos(theta2)'];
end

Y4; Z4; Y5=[]; Z5=[];

for i=1:4:118
    Y5=[Y5; Y4(i,:); Y4(i+1,:); Y4(i+2,:); Y4(i+3,:)];
    Z5=[Z5; Z4(i,:); Z4(i+1,:); Z4(i+2,:); Z4(i+3,:)];
    Y5=[Y5; Y4(i+3,:); Y4(i+4,:)];
    Z5=[Z5; Z4(i+3,:); Z4(i+4,:)];
end

Y5(5,11)=Y5(5,10);     %1:a mönstret på sidan
Y5(6,11)=Y5(6,10);
Z5(5,11)=Z5(5,10);
Z5(6,11)=Z5(6,10);

for i=11:6:184        %resten av hacken i sidan av däcket
    Y5(i,11)=Y5(i,10);
    Y5(i+1,11)=Y5(i+1,10);
    Z5(i,11)=Z5(i,10);
    Z5(i+1,11)=Z5(i+1,10);
end
Y5=[Y5; Y5(1,:)]; 
Z5=[Z5; Z5(1,:)];

X4=[X4 zeros(181,1) zeros(181,1) -0.2*ones(181,1) -0.2*ones(181,1) -1.4*ones(181,1)]; %djupet på däcket och mönster
Y5=[Y5 Y5(:,11) Y5(:,10) Y5(:,10) Y5(:,11) Y5(:,11)]; %kolumn 12,13,14,15,16     
Z5=[Z5 Z5(:,11) Z5(:,10) Z5(:,10) Z5(:,11) Z5(:,11)];


for i=181:-1:2
    temp1=Y5(181,16); 
    Y5(i,16)=Y5(i-1,16);
    Y5(1,16)=temp1;
end

for i=181:-1:2
    temp2=Z5(181,16); 
    Z5(i,16)=Z5(i-1,16);
    Z5(1,16)=temp2;
end

Y5(1,16)=Y5(178,15);   %Ändra extra punkterna så de ligger rätt
Z5(1,16)=Z5(178,15);
Y5(2,16)=Y5(1,15);
Z5(2,16)=Z5(1,15);

for i=5:6:184        %resten av hacken i sidan av däcket
    Y5(i,16)=Y5(i-2,10);
    Y5(i+2,16)=Y5(i-1,15);
    Z5(i,16)=Z5(i-2,10);
    Z5(i+2,16)=Z5(i-1,15);
end

X4=[X4 -2.6*ones(181,1) -2.6*ones(181,1) -3*ones(181,1) -3*ones(181,1)];
Y5=[Y5 Y5(:,15) Y5(:,14) Y5(:,14) Y5(:,15)];
Z5=[Z5 Z5(:,15) Z5(:,14) Z5(:,14) Z5(:,15)]; %kolumn 17,18,19,20

for i=1:11
    X4=[X4 0.4-r*cos(FI(i))*cos(FI(i))*ones(181,1)];
end

for i=11:-1:1   
    Y5=[Y5 Y5(:,i)];
    Z5=[Z5 Z5(:,i)];
end
f=2;
%surf(-(X4+x),Y5+y,Z5+z); hold on
surface(-(X4+x),Y5+y,Z5+z,...
    'EdgeColor','none',...
    'FaceColor',[0.1 0.1 0.1],...
    'FaceLighting','flat',...
    'AmbientStrength',0.3,...
    'DiffuseStrength',1,...
    'Clipping','off',...
    'BackFaceLighting','lit',...
    'SpecularStrength',1.1), hold on;          %'SpecularColorReflectance',1,...
    %'SpecularExponent',7), hold on;