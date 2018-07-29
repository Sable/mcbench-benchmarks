function ring_render(ring_param,x_list,y_list)

%Extract ring parameters:
%------------------------
Ri=ring_param{2}; %inner radius
Ro=ring_param{3}; %outer modulation size
H=ring_param{4}; %height
Rfreq=ring_param{1}; %modulation frequency
face_color=ring_param{5}/255; %color

delta_theta=5; %angle spacing (smaller values will increase render time)
theta=0:delta_theta:360;

%Complete the list of cross-section nodes:
%-----------------------------------------
x=x_list;
y=y_list;
y_new=[x(1:length(x)-1) x(1)];
z_new=[y(1:length(y)-1) y(1)];
x_new=zeros(size(y));
x=x_new;
y=y_new+Ri;
z=z_new;
clear x_new y_new z_new

%Render ring:
%------------
for nt=1:length(theta)-1 %loop through each face angle

    th1=theta(nt);
    th2=theta(nt+1);

    for np=1:length(x)-1 %generate the edges of the face
        
        xtemp=x(np:np+1);
        ytemp=y(np:np+1);
        ztemp=z(np:np+1);

        %apply modulation to outer cross-section coordinates:
        r_temp1=(ytemp>Ri)*Ro*((sind(th1*Rfreq)+1)/2);
        r_temp2=(ytemp>Ri)*Ro*((sind(th2*Rfreq)+1)/2);

        %apply rotation transformation to cross-section coordinate:
        xtemp_rot1=xtemp*cosd(th1)+(ytemp+r_temp1)*sind(th1);
        xtemp_rot2=xtemp*cosd(th2)+(ytemp+r_temp2)*sind(th2);
        ytemp_rot1=xtemp*-sind(th1)+(ytemp+r_temp1)*cosd(th1);
        ytemp_rot2=xtemp*-sind(th2)+(ytemp+r_temp2)*cosd(th2);

        %edge lists:
        xtemp_face=[xtemp_rot1(1) xtemp_rot2(1) xtemp_rot2(2) xtemp_rot1(2) xtemp_rot1(1)];
        ytemp_face=[ytemp_rot1(1) ytemp_rot2(1) ytemp_rot2(2) ytemp_rot1(2) ytemp_rot1(1)];
        ztemp_face=[ztemp(1) ztemp(1) ztemp(2) ztemp(2) ztemp(1)];

        %render face:
        hf=fill3(xtemp_face,ytemp_face,ztemp_face,face_color);
        set(hf,'EdgeAlpha',0,'FaceLighting','phong','BackFaceLighting','lit','SpecularStrength',1,'FaceAlpha',.5)
        material shiny
        hold on
    end
end
axis equal
axis([-1 1 -1 1 -1 1]*(Ri+H))
axis off
set(gcf,'Color','k')
light('Position',[1 1 1]*25,'Style','local')
light('Position',[-1 1 -1]*25,'Style','local')
light('Position',[1 -1 -1]*25,'Style','local')
light('Position',[-1 -1 1]*25,'Style','local')
