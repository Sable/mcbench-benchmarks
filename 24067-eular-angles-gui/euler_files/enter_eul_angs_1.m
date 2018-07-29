function enter_eul_angs
% update because euler angles were changed
global ts rhs lr rhs1 lr1 xs xst ys yst zs zst ks phi theta psi rad deg x y z gamma delta alpha  vna vnat N Nt sxyz sav sN arcR arcth arctxtR phia1 phia2 phiat sa thetaa1 thetaa2 thetaat psia1 psia2 psiat

naner=false;

phin=str2num(get(phi,'String'));
if length(phin)==0
    naner=true;
end

thetan=str2num(get(theta,'String'));
if length(thetan)==0
    naner=true;
end

psin=str2num(get(psi,'String'));
if length(psin)==0
    naner=true;
end

if naner
    nan_error;
else

    if get(deg,'Value')
        phin=pi*phin/180;
        thetan=pi*thetan/180;
        psin=pi*psin/180;
    end
    
    an=ea_bounding(phin,thetan,psin); % correct angles
    if an(1)
        phin=an(2);
        thetan=an(3);
        psin=an(4);
        if get(deg,'Value')
            set(phi,'String',num2str(180*phin/pi));
            set(theta,'String',num2str(180*thetan/pi));
            set(psi,'String',num2str(180*psin/pi));
        else
            set(phi,'String',num2str(phin));
            set(theta,'String',num2str(thetan));
            set(psi,'String',num2str(psin));
        end
    end

    Ms=matrices(phin,thetan,psin);
    M=Ms{1}*Ms{2}*Ms{3};

    als=0.5; % transparensy of xyz
    lcs=[0.4 0.4 0.4]; %labels color
    
    if get(sxyz,'value')
        % x
        xsv=M*[1;0;0];
        xsv1=ks*xsv;
        %xs=arrowa(0,0,0,xsv1(1),xsv1(2),xsv1(3),rhs1*0.8,lr1*0.8,[1 0 0],als,hpar);
        arrow_update(xs,0,0,0,xsv1(1),xsv1(2),xsv1(3),rhs1*0.8,lr1*0.8);
        %xst=text('parent',hpar,'position',xsv1+ts*xsv,'string','x','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(xst,'position',xsv1+ts*xsv);

        % y
        ysv=M*[0;1;0];
        ysv1=ks*ysv;
        %ys=arrowa(0,0,0,ysv1(1),ysv1(2),ysv1(3),rhs1*0.8,lr1*0.8,[0 1 0],als,hpar);
        arrow_update(ys,0,0,0,ysv1(1),ysv1(2),ysv1(3),rhs1*0.8,lr1*0.8);
        %yst=text('parent',hpar,'position',ysv1+ts*ysv,'string','y','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(yst,'position',ysv1+ts*ysv);

        % z
        zsv=M*[0;0;1];
        zsv1=ks*zsv;
        %zs=arrowa(0,0,0,zsv1(1),zsv1(2),zsv1(3),rhs1*0.8,lr1*0.8,[0 0 1],als,hpar);
        arrow_update(zs,0,0,0,zsv1(1),zsv1(2),zsv1(3),rhs1*0.8,lr1*0.8);
        %zst=text('parent',hpar,'position',zsv1+ts*zsv,'string','z','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(zst,'position',zsv1+ts*zsv);
        
        arrow_visible_off_on(xs,true);
        set(xst,'visible','on');

        arrow_visible_off_on(ys,true);
        set(yst,'visible','on');

        arrow_visible_off_on(zs,true);
        set(zst,'visible','on');
        
    else
        
        arrow_visible_off_on(xs,false);
        set(xst,'visible','off');

        arrow_visible_off_on(ys,false);
        set(yst,'visible','off');

        arrow_visible_off_on(zs,false);
        set(zst,'visible','off');
        
    end
 
    
   % this part already in enter_ax_an_angs: 
    
%     % axis v
%     axan=euler2axan(phin,thetan,psin,M);
%     % {{gamma,delta,alpha},v}
%     gda=axan{1};
%     gamman=gda{1};
%     deltan=gda{2};
%     alphan=gda{3};
%     vn=axan{2};
%     if get(deg,'Value')
%         set(gamma,'string',num2str(180*gamman/pi));
%         set(delta,'string',num2str(180*deltan/pi));
%         set(alpha,'string',num2str(180*alphan/pi));
%     else
%         set(gamma,'string',num2str(gamman));
%         set(delta,'string',num2str(deltan));
%         set(alpha,'string',num2str(alphan));
%     end
% 
%     set(x,'string',num2str(vn(1)));
%     set(y,'string',num2str(vn(2)));
%     set(z,'string',num2str(vn(3)));
    
    vn(1,1)=str2num(get(x,'string'));
    vn(2,1)=str2num(get(y,'string'));
    vn(3,1)=str2num(get(z,'string'));
    

    
    if get(sav,'value')
        vn1=ks*vn;
        %vna=arrow(0,0,0,vn(1),vn(2),vn(3),rhs1*0.8,lr1*0.8,[0.9 0.2 1],hpar);
        arrow_update(vna,0,0,0,vn(1),vn(2),vn(3),rhs1*0.8,lr1*0.8);
        %vnat=text('parent',hpar,'position',vn+ts*vn1,'string','v','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(vnat,'position',vn+ts*vn1);
        
        arrow_visible_off_on(vna,true);
        set(vnat,'visible','on');
    else
        arrow_visible_off_on(vna,false);
        set(vnat,'visible','off');
    end
    
    % line of nodes
    if get(sN,'value')
        Nv=Ms{1}*[1;0;0];
        Nv1=ks*Nv;
        %N=arrow(0,0,0,Nv(1),Nv(2),Nv(3),rhs1*0.8,lr1*0.8,[0.4 0.4 4],hpar);
        arrow_update(N,-Nv(1),-Nv(2),-Nv(3),2*Nv(1),2*Nv(2),2*Nv(3),rhs1*0.8,lr1*0.8);
        %Nt=text('parent',hpar,'position',Nv+ts*Nv1,'string','N','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(Nt,'position',Nv+ts*Nv1);
        
        arrow_visible_off_on(N,true);
        set(Nt,'visible','on');
        
    else
        
        arrow_visible_off_on(N,false);
        set(Nt,'visible','off');
        
    end
    
    
    
    
    % angles:
    if get(sa,'value')
        % phi:
        an=arc_data(phin,arcR,arcth,arctxtR);
        Ml=an{1};
        Mt=an{2};
        txv=an{3};
        %phia1=plot3(Ml(1,:),Ml(2,:),zeros(1,length(Ml(1,:))),'-k','parent',hpar);
        set(phia1,'XData',Ml(1,:),'YData',Ml(2,:),'ZData',zeros(1,length(Ml(1,:))));
        %phia2=plot3(Mt(1,:),Mt(2,:),zeros(1,length(Mt(1,:))),'-k','parent',hpar);
        set(phia2,'XData',Mt(1,:),'YData',Mt(2,:),'ZData',zeros(1,length(Mt(1,:))));
        %phiat=text('parent',hpar,'position',[txv 0],'string','\phi','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(phiat,'position',[txv 0]);
        
        set(phia1,'visible','on');
        set(phia2,'visible','on');
        set(phiat,'visible','on');
        
        % theta:
        an=arc_data(thetan,arcR,arcth,arctxtR);
        Ml1=an{1};
        Ml=Ms{1}*[zeros(1,length(Ml1(1,:))); -Ml1(2,:); Ml1(1,:)];
        Mt1=an{2};
        Mt=Ms{1}*[zeros(1,length(Mt1(1,:))); -Mt1(2,:); Mt1(1,:)];
        txv1=an{3};
        txv=Ms{1}*[0; -txv1(2); txv1(1)];
        %thetaa1=plot3(Ml(1,:),Ml(2,:),Ml(3,:),'-k','parent',hpar);
        set(thetaa1,'XData',Ml(1,:),'YData',Ml(2,:),'ZData',Ml(3,:));
        %thetaa2=plot3(Mt(1,:),Mt(2,:),Mt(3,:),'-k','parent',hpar);
        set(thetaa2,'XData',Mt(1,:),'YData',Mt(2,:),'ZData',Mt(3,:));
        %thetaat=text('parent',hpar,'position',txv,'string','\theta','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(thetaat,'position',txv);
        
        set(thetaa1,'visible','on');
        set(thetaa2,'visible','on');
        set(thetaat,'visible','on');
        
        
        % psi:
        an=arc_data(psin,arcR,arcth,arctxtR);
        Ml1=an{1};
        Ml=Ms{1}*Ms{2}*[Ml1(1,:); Ml1(2,:); zeros(1,length(Ml1(1,:)))];
        Mt1=an{2};
        Mt=Ms{1}*Ms{2}*[Mt1(1,:); Mt1(2,:); zeros(1,length(Mt1(1,:)))];
        txv1=an{3};
        txv=Ms{1}*Ms{2}*[txv1(1); txv1(2); 0];
        %psia1=plot3(Ml(1,:),Ml(2,:),Ml(3,:),'-k','parent',hpar);
        set(psia1,'XData',Ml(1,:),'YData',Ml(2,:),'ZData',Ml(3,:));
        %psia2=plot3(Mt(1,:),Mt(2,:),Mt(3,:),'-k','parent',hpar);
        set(psia2,'XData',Mt(1,:),'YData',Mt(2,:),'ZData',Mt(3,:));
        %psiat=text('parent',hpar,'position',txv,'string','\psi','HorizontalAlignment','center','VerticalAlignment','middle','color',lcs);
        set(psiat,'position',txv);
        
        set(psia1,'visible','on');
        set(psia2,'visible','on');
        set(psiat,'visible','on');
        
    else
        set(phia1,'visible','off');
        set(phia2,'visible','off');
        set(phiat,'visible','off');
        
        set(thetaa1,'visible','off');
        set(thetaa2,'visible','off');
        set(thetaat,'visible','off');
        
        set(psia1,'visible','off');
        set(psia2,'visible','off');
        set(psiat,'visible','off');
    end
end