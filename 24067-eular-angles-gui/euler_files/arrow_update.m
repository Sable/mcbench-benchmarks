function arrow_update(har,x,y,z,vx,vy,vz,th,lr)
% update 3d arrow (redraw arrow in new place)
% arrow_update(har,x,y,z,vx,vy,vz,th,lr)
% har - cell array of handles to objects
% (x,y,z) - point of arrow begin
% (vx,vy,vz) - vector for arrow
% th - tip height
% lr - line radiuse




% xyz=[x;y;z];
v=[vx;vy;vz];
vl=sqrt(v'*v); % lenght of arrow, each size will be normalazed to vl
if vl~=0
    %warning('length of arrow equal to 0');


    n=20; % discretization for circle in tip (tip is cone)
    dfi=2*pi/n;
    r=0.3*th; % radius in tip
    h=th; % height of tip
    v0=v*((vl-h))/vl; % rest part vector



    % draw tip of arrow


    % find some vector-perpendicular to v:
    if (vx==0)&&(vy==0)
        vp=[0;vz;-vy];
    else
        vp=[vy;-vx;0];
    end
    vp=r*vp/sqrt(vp'*vp);

    vpa=vp; % vectors for draw circle

    for fi=dfi:dfi:2*pi
        vcr=cross(v,vp);
        vcrn=vcr/sqrt(vcr'*vcr);
        vp=vp*cos(dfi)+r*sin(dfi)*vcrn;
        vpa=[vpa,vp];
    end

    X=x+v0(1)+vpa(1,:);
    Y=y+v0(2)+vpa(2,:);
    Z=z+v0(3)+vpa(3,:);


    % hold off
    % plot3(X,Y,Z);

    % add vertex of tip:
    X=[X;(x+vx)*ones(size(X))];
    Y=[Y;(y+vy)*ones(size(Y))];
    Z=[Z;(z+vz)*ones(size(Z))];

    % hs=surf(X,Y,Z);
    % har{1}=hs;
    % set(hs,'FaceColor',c,'EdgeColor','none');
    set(har{1},'XData',X,'YData',Y,'ZData',Z);
    % har{2}=fill3(X(1,:),Y(1,:),Z(1,:),c);
    set(har{2},'XData',X(1,:),'YData',Y(1,:),'ZData',Z(1,:),'EdgeColor',[0 0 0]);

    % draw line:
    vpal=lr*vpa/r;
    Xl=x+vpal(1,:);
    Yl=y+vpal(2,:);
    Zl=z+vpal(3,:);

    Xl=[Xl;x+v0(1)+vpal(1,:)];
    Yl=[Yl;y+v0(2)+vpal(2,:)];
    Zl=[Zl;z+v0(3)+vpal(3,:)];

    % hs=surf(Xl,Yl,Zl);
    % har{3}=hs;
    % set(hs,'FaceColor',c,'EdgeColor','none');
        set(har{3},'XData',Xl,'YData',Yl,'ZData',Zl);
    % har{4}=fill3(Xl(1,:),Yl(1,:),Zl(1,:),c);
    set(har{4},'XData',Xl(1,:),'YData',Yl(1,:),'ZData',Zl(1,:),'EdgeColor',[0 0 0]);
    % har{5}=fill3(Xl(2,:),Yl(2,:),Zl(2,:),c);
    set(har{5},'XData',Xl(2,:),'YData',Yl(2,:),'ZData',Zl(2,:),'EdgeColor',[0 0 0]);
    
else
    
    n=20; % discretization for circle in tip (tip is cone)
    dfi=2*pi/n;
    r=0.3*th; % radius in tip
    h=th; % height of tip

    % instead of tip of arrow:
    % har{1}=spherei(x,y,z,r,c,1,hpar);
    c=get(har{1},'FaceColor');
    hpar=get(har{1},'parent');
    XYZ=sphereic(x,y,z,r,c,1,hpar);
    set(har{1},'XData',XYZ{1},'YData',XYZ{2},'ZData',XYZ{3});
    crc=circle(0,0,r);
    %har{2}=fill3(x+crc(:,1),y+crc(:,2),z+zeros(length(crc(:,1))),c,'parent',hpar,'EdgeColor','none');
    set(har{2},'XData',x+crc(:,1),'YData',y+crc(:,2),'ZData',z+zeros(length(crc(:,1))),'EdgeColor','none');
    
    % insrtead of line:
    %har{3}=spherei(x,y,z,r,c,1,hpar);
    set(har{3},'XData',XYZ{1},'YData',XYZ{2},'ZData',XYZ{3});
    %har{4}=fill3(x+crc(:,1),y+crc(:,2),z+zeros(length(crc(:,1))),c,'parent',hpar,'EdgeColor','none');
    set(har{4},'XData',x+crc(:,1),'YData',y+crc(:,2),'ZData',z+zeros(length(crc(:,1))),'EdgeColor','none');
    %har{5}=fill3(x+crc(:,1),y+crc(:,2),z+zeros(length(crc(:,1))),c,'parent',hpar,'EdgeColor','none');
    set(har{5},'XData',x+crc(:,1),'YData',y+crc(:,2),'ZData',z+zeros(length(crc(:,1))),'EdgeColor','none');
    
end
