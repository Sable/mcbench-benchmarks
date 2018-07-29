function TravelGuide(action)

global fig hand Adj_Mat pt1 pt2 Pt travel loopy;
global count counts lnhd bndhd county countl countp LineCoeff maphd;
clc
%--------------------------------------------------------------------------
if nargin < 1, 
    pt1=[]; pt2=[]; Pt=[];
    travel=0;
    count=0;
    county=0;
    counts=0;
    countl=0;
    countp=0;
    LineCoeff=[];
    Adj_Mat=[];
    loopy=1;
    
    fig=figure('Name','Travel Guide - Game','NumberTitle','off',...
               'units','normalized','Visible','off', 'BackingStore','off');
      
    image(imread('iisc.jpg'));%User can load Image of his/her choice.
    
    %creating default buttons
    uicontrol('units','normalized','string','Intro','interruptible','on',...
              'position',[.85 .75 .08 .05],'callback','TravelGuide(''Intro'')',...
              'BackgroundColor','w');
          
    uicontrol('units','normalized','string','Loop','interruptible','on',...
              'position',[.85 .65 .08 .05],'callback','TravelGuide(''Loop'')',...
              'BackgroundColor','w');
          
    uicontrol('units','normalized','string','Travel','interruptible','on',...
              'position',[.85 .55 .08 .05],'callback','TravelGuide(''Travel'')',...
              'BackgroundColor','w');
          
    uicontrol('units','normalized','string','Map','interruptible','on',...
              'position',[.85 .45 .08 .05],'callback','TravelGuide(''Map'')',...
              'BackgroundColor','w');
          
    uicontrol('units','normalized','string','Clear','interruptible','on',...
              'position',[.85 .35 .08 .05],'callback','TravelGuide(''Clear'')',...
              'BackgroundColor','w'); 
          
    uicontrol('units','normalized','string','Exit','interruptible','on',...
              'position',[.85 .25 .08 .05],'callback','delete(gcf)',...
              'BackgroundColor','w');
    
    figure(fig);
    axis off;
    axis square;
    axis equal;
    
    action='Intro';
end
%--------------------------------------------------------------------------
if strcmp(action,'Intro'),
    msg={'Objective: Shortest Distance Path between 2 Points.                    ',...
         '                                                                       ',...
         'Step 1: Define the Map using any Point on the Map.                     ',...
         'Step 2: Define the 2 Points to get Shortest Distance Path.             ',...
         '                                                                       ',...
         'Note 1: For every click a Straight Line is drawn to its previous Point.',...
         'Note 2: "Loop" is used for a different Route Selection definition.     ',...
         'Note 3: "Travel" is used to Define 2 Points for a defined Map by user. ',...
         'Note 4: "Clear" is used to clear all the defined paths on Map by user. ',...
         'Note 5: "Map" is used to see the all the defined paths on Map by user. ',...
         'Note 6: Use Right click to exit from "ginput" or Map Definition.       ',...
         'Note 7: Background Image is just a reference (no connection with Code).'};
     
    MsgHand=msgbox(msg,'Travel Guide - Game','help');
    scrsz = get(0,'ScreenSize');
    set(MsgHand,'position',[scrsz(3)/5 scrsz(3)/3 scrsz(3)/2.5 scrsz(4)/6.5]);
    ChildHand= get(MsgHand,'children');
    set(findobj(ChildHand,'type','text'),'fontname','courier');
    set(ChildHand(3),'position',[240    7.0000   40.0000   15.0000]);
    
    if ~waitforbuttonpress && loopy, 
        close(MsgHand); 
        action='Loop'; 
    end
end
%--------------------------------------------------------------------------
if strcmp(action,'Loop'),  
    loopy=0;
    for kk=1:count,
        set(hand(kk),'color','r');
    end
    for kk=1:county,
        set(bndhd(kk),'visible','off');
    end
    for kk=1:counts,
        set(lnhd(kk),'visible','off');
    end
    for kk=1:countp,
        set(maphd(kk),'visible','off');
    end
    travel=1;
    pt1=[];
    pt2=[];
    v1=[];
    v2=[];
    Button=1;   
    while Button==1,
          [Xnew Ynew Button] = ginput(1);
          Xnew=floor(Xnew);
          Ynew=floor(Ynew);
          if Button==1,
              clc
              if isempty(pt1),
                 pt1=[Xnew Ynew];             
                 count=count+1;
                 Pt(count,:)=pt1;
                 flag=1;
              else
                 pt2=[Xnew Ynew]; 
                 flag=1;
                 for ii=1:count,
                     a=Xnew; b=Ynew;
                     c=Pt(ii,1); d=Pt(ii,2);
                     if sqrt((a-c)^2+(b-d)^2)<=25, %error circle
                         pt2=Pt(ii,:);
                         p=pt1(1); q=pt1(2); r=pt2(1); s=pt2(2);
                         Adj_Mat(ii,count)=sqrt((p-r)^2+(q-s)^2);
                         Adj_Mat(count,ii)=sqrt((p-r)^2+(q-s)^2);
                         countl=countl+1;
                         LineCoeff(countl,:)=[p q r s];%[s-q p-r p*s-q*r]
                         flag=0;
                     end
                 end
                 p=pt1(1); q=pt1(2); r=pt2(1); s=pt2(2);
                 if flag,
                     count=count+1;
                     Pt(count,:)=pt2;                 
                     Adj_Mat(count-1,count)=sqrt((p-r)^2+(q-s)^2);
                     Adj_Mat(count,count-1)=sqrt((p-r)^2+(q-s)^2);
                     countl=countl+1;
                     LineCoeff(countl,:)=[p q r s];%[s-q p-r p*s-q*r]
                 end
                 county=county+1;
                 bndhd(county)=line([p r],[q s],'color','b','LineWidth',2);
                 pt1=pt2;
              end
                 
               %Checking for Line Intersections for Additional Connectivity
                 if flag,
                     %Point-Line Intersection (NO Additional Point)
                     countem=size(LineCoeff,1);
                     for ii=1:countem,
                         a=LineCoeff(ii,1); b=LineCoeff(ii,2);
                         c=LineCoeff(ii,3); d=LineCoeff(ii,4);
                         if isempty(pt1), 
                             pt=pt2;
                         else
                             pt=pt1;
                         end
                         aa=d-b; bb=a-c; cc=b*c-d*a;
                         PnPt(1)=-(aa*bb*pt(2)-bb*bb*pt(1)+aa*cc)/(aa^2+bb^2);
                         PnPt(2)=-(aa*bb*pt(1)-aa*aa*pt(2)+bb*cc)/(aa^2+bb^2);                         
                         resx=(PnPt(1)-a)*(PnPt(1)-c);
                         resy=(PnPt(2)-b)*(PnPt(2)-d);
%                          res=abs((aa*pt(1)+bb*pt(2)+cc)/sqrt(aa^2+bb^2));
                         res=sqrt((PnPt(1)-pt(1))^2+(PnPt(2)-pt(2))^2);
%                          aa*PnPt(1)+bb*PnPt(2)+cc,
                         if (resx<0 && resy<0 && abs(res)<=25),                         
                             for jj=1:count,
                                 if sum(abs(Pt(jj,:)-[a b]))==0, v1=jj; end
                                 if sum(abs(Pt(jj,:)-[c d]))==0, v2=jj; end
                             end
                             if ~isempty(v1),
                                 p=a; q=b; r=pt(1); s=pt(2);
                                 countl=countl+1;
                                 LineCoeff(countl,:)=[p q r s];
                                 Adj_Mat(v1,count)=sqrt((p-r)^2+(q-s)^2);
                                 Adj_Mat(count,v1)=sqrt((p-r)^2+(q-s)^2);
                             end
                             if ~isempty(v2),
                                 p=pt(1); q=pt(2); r=c; s=d;
                                 countl=countl+1;
                                 LineCoeff(countl,:)=[p q r s];
                                 Adj_Mat(v2,count)=sqrt((p-r)^2+(q-s)^2);
                                 Adj_Mat(count,v2)=sqrt((p-r)^2+(q-s)^2);
                             end
                         end
                     end 
                 end
                 
              if flag,
                 hand(count)=text(Xnew,Ynew,'.','FontSize',20,...
                                 'HorizontalAlignment','center',...
                                 'VerticalAlignment','baseline',...
                                 'FontWeight','bold','color','r',...
                                 'ButtonDownFcn',{@Callback_Grid,count});
              end
          end
    end
    
    %Line-Line Intersection (creates Additional Point)
    countem=size(LineCoeff,1);
    for ii=1:countem-1,
        for jj=ii+1:countem,
            %Line-1
            a=LineCoeff(ii,1); b=LineCoeff(ii,2);
            c=LineCoeff(ii,3); d=LineCoeff(ii,4);
            aa1=d-b; bb1=a-c; cc1=b*c-d*a;
            %Line-2
            p=LineCoeff(jj,1); q=LineCoeff(jj,2);
            r=LineCoeff(jj,3); s=LineCoeff(jj,4);
            aa2=s-q; bb2=p-r; cc2=r*q-s*p;
            %Intersection
            if (bb1*aa2-bb2*aa1)==0, continue; end
            xp=-(bb1*cc2-cc1*bb2)/(bb1*aa2-bb2*aa1);
            yp=(aa1*cc2-cc1*aa2)/(bb1*aa2-bb2*aa1);
            resx1=(xp-a)*(xp-c);
            resy1=(yp-b)*(yp-d);
            resx2=(xp-p)*(xp-r);
            resy2=(yp-q)*(yp-s);
            if (resx1<0 && resy1<0 && resx2<0 && resy2<0),
                for kk=1:count,
                    if sum(abs(Pt(kk,:)-[a b]))==0, v1=kk; end
                    if sum(abs(Pt(kk,:)-[c d]))==0, v2=kk; end
                    if sum(abs(Pt(kk,:)-[p q]))==0, v3=kk; end
                    if sum(abs(Pt(kk,:)-[r s]))==0, v4=kk; end
                end
                if ~isempty(v1),
                    countl=countl+1;
                    LineCoeff(countl,:)=[a b xp yp];
                    Adj_Mat(v1,count+1)=sqrt((a-xp)^2+(b-yp)^2);
                    Adj_Mat(count+1,v1)=sqrt((a-xp)^2+(b-yp)^2);
                end
                if ~isempty(v2),
                    countl=countl+1;
                    LineCoeff(countl,:)=[xp yp c d];
                    Adj_Mat(v2,count+1)=sqrt((c-xp)^2+(d-yp)^2);
                    Adj_Mat(count+1,v2)=sqrt((c-xp)^2+(d-yp)^2);
                end
                if ~isempty(v3),
                    countl=countl+1;
                    LineCoeff(countl,:)=[p q xp yp];
                    Adj_Mat(v3,count+1)=sqrt((p-xp)^2+(q-yp)^2);
                    Adj_Mat(count+1,v3)=sqrt((p-xp)^2+(q-yp)^2);
                end
                if ~isempty(v4),
                    countl=countl+1;
                    LineCoeff(countl,:)=[xp yp r s];
                    Adj_Mat(v4,count+1)=sqrt((r-xp)^2+(s-yp)^2);
                    Adj_Mat(count+1,v4)=sqrt((r-xp)^2+(s-yp)^2);
                end
                if (~isempty(v1) && ~isempty(v2) && ~isempty(v3) && ~isempty(v4)),
                    count=count+1;
                    Pt(count,:)=[xp yp];
                    hand(count)=text(xp,yp,'.','FontSize',20,...
                                'HorizontalAlignment','center',...
                                'VerticalAlignment','baseline',...
                                'FontWeight','bold','color','r',...
                                'ButtonDownFcn',{@Callback_Grid,count});
                            
                     %Point-Line Intersection (NO Additional Point)
                     countem=size(LineCoeff,1);
                     for kk=1:countem,
                         a=LineCoeff(kk,1); b=LineCoeff(kk,2);
                         c=LineCoeff(kk,3); d=LineCoeff(kk,4);
                         pt=[xp yp];
                         aa=d-b; bb=a-c; cc=b*c-d*a;
                         PnPt(1)=-(aa*bb*pt(2)-bb*bb*pt(1)+aa*cc)/(aa^2+bb^2);
                         PnPt(2)=-(aa*bb*pt(1)-aa*aa*pt(2)+bb*cc)/(aa^2+bb^2);                         
                         resx=(PnPt(1)-a)*(PnPt(1)-c);
                         resy=(PnPt(2)-b)*(PnPt(2)-d);
%                          res=abs((aa*pt(1)+bb*pt(2)+cc)/sqrt(aa^2+bb^2));
                         res=sqrt((PnPt(1)-pt(1))^2+(PnPt(2)-pt(2))^2);
%                          aa*PnPt(1)+bb*PnPt(2)+cc,
                         if (resx<0 && resy<0 && abs(res)<=25),                         
                             for ll=1:count,
                                 if sum(abs(Pt(ll,:)-[a b]))==0, v1=ll; end
                                 if sum(abs(Pt(ll,:)-[c d]))==0, v2=ll; end
                             end
                             if ~isempty(v1),
                                 p=a; q=b; r=pt(1); s=pt(2);
                                 countl=countl+1;
                                 LineCoeff(countl,:)=[p q r s];
                                 Adj_Mat(v1,count)=sqrt((p-r)^2+(q-s)^2);
                                 Adj_Mat(count,v1)=sqrt((p-r)^2+(q-s)^2);
                             end
                             if ~isempty(v2),
                                 p=pt(1); q=pt(2); r=c; s=d;
                                 countl=countl+1;
                                 LineCoeff(countl,:)=[p q r s];
                                 Adj_Mat(v2,count)=sqrt((p-r)^2+(q-s)^2);
                                 Adj_Mat(count,v2)=sqrt((p-r)^2+(q-s)^2);
                             end
                         end
                     end
                     
                end
            end
        end
    end
    
    for ii=1:size(Adj_Mat,1),
        for jj=1:size(Adj_Mat,2),
            if Adj_Mat(ii,jj)==0, Adj_Mat(ii,jj)=1e5; end
            if ii==jj, Adj_Mat(ii,jj)=0; end
        end
    end
end
%--------------------------------------------------------------------------
if strcmp(action,'Travel'),
   if sum(sum(Adj_Mat))~=0,        
        for kk=1:count,
            set(hand(kk),'color','r');
        end
        for kk=1:county,
            set(bndhd(kk),'visible','off');
        end
        for kk=1:counts,
            set(lnhd(kk),'visible','off');
        end
        for kk=1:countp,
            set(maphd(kk),'visible','off');
        end
        travel=1;
        pt1=[];
        msg={'Select 2 Points on the Defined Map.'};     
        msghand=msgbox(msg,'Source to Destination','help');
        pause(1);
        close(msghand);
    else
        msg={'Define the Map first in-order to Travel between 2 Points...'};     
        msghand=msgbox(msg,'Error!!!','error');
        pause(2);
        close(msghand);
   end
%    Adj_Mat
%    LineCoeff
end
%--------------------------------------------------------------------------
if strcmp(action,'Map'),
    for kk=1:count,
        set(hand(kk),'color','r');
    end
    for kk=1:county,
        set(bndhd(kk),'visible','off');
    end
    for kk=1:counts,
        set(lnhd(kk),'visible','off');
    end
    for kk=1:countp,
        countp=countp+1;
        a=LineCoeff(kk,1); b=LineCoeff(kk,2);
        c=LineCoeff(kk,3); d=LineCoeff(kk,4);
        maphd(kk)=line([a c],[b d],'color','b','LineWidth',2);
    end
end
%--------------------------------------------------------------------------
if strcmp(action,'Clear'),
    for kk=1:county,
        set(bndhd(kk),'visible','off');
    end
    for kk=1:count,
        set(hand(kk),'visible','off');
    end
    for kk=1:counts,
        set(lnhd(kk),'visible','off');
    end    
    for kk=1:countp,
        set(maphd(kk),'visible','off');
    end
    pt1=[]; pt2=[]; Pt=[];
    travel=0;
    count=0;
    county=0;
    counts=0;
    countl=0;
    LineCoeff=[];
    Adj_Mat=[];
end
%--------------------------------------------------------------------------