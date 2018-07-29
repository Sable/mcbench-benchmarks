function sonorobot(r,ns,ds,mapoff)
if nargin<4
mapoff=false;
if nargin<3
ds=.1;
if nargin<2
ns=24;
if nargin<1;
r=.37;
end
end
end
end
clf reset
shg
set(gcf,'menubar','none',...%[0    0.2850    0.3985]
    'numbertitle','off','name','Sono Robot');
t_n=uicontrol('style','toggle','position',[35,65,25,25],...
    'string','N');
t_s=uicontrol('style','toggle','position',[35,5,25,25],...
    'string','S');
t_w=uicontrol('style','toggle','position',[5,35,25,25],...
    'string','W');
t_e=uicontrol('style','toggle','position',[65,35,25,25],...
    'string','E');
t_ne=uicontrol('style','toggle','position',[65,65,25,25],...
    'string','NE');
t_se=uicontrol('style','toggle','position',[65,5,25,25],...
    'string','SE');
t_sw=uicontrol('style','toggle','position',[5,5,25,25],...
    'string','SW');
t_nw=uicontrol('style','toggle','position',[5,65,25,25],...
    'string','NW');
t_start=uicontrol('style','toggle','position',[505,35,50,25],...
    'string','Auto');
t_quit=uicontrol('style','toggle','position',[505,5,50,25],...
    'string','Quit');
msg1=uicontrol('style','text','position',[120,5,345,55]);
msg2=uicontrol('style','text','position',[120,65,345,25],...
    'string','Measurement results...','fontsize',11.5,...
    'horizontal','left');
% orderdisp=['1st';'2nd';'3th';'4th';'5th';'6th';'7th';'8th';'9th';'0th'];
drawnow
hold on
axisx=12.5;
axisy=10;
axis([0 axisx 0 axisy]);
axis off

%Note:
%distance from one point to line:
%x=(x0*(x1-x2)^2+(x2*(-y0+y1)+x1*(y0-y2))*(y1-y2))/(x1^2-2*x1*x2+x2^2+(y1-y2)^2);
%y=(x2^2*y1+y0*y1^2+x0*(x1-x2)*(y1-y2)+x1^2*y2-2*y0*y1*y2+y0*y2^2-x1*x2*(y1+y2))/(x1^2-2*x1*x2+x2^2+(y1-y2)^2);

%Input environment & robot position
%Environment
nmax=50;
stpmax=100;
segset=zeros(nmax,4);%line segment set:[Ax,Ay,Bx,By]
areax=1;
areay=.5;
dftarea=[axisx-areax,axisy-areay;axisx-areax,axisy;axisx,axisy;axisx,axisy-areay];
okarea=[axisx-areax,axisy-2*areay;axisx-areax,axisy-areay;axisx,axisy-areay;axisx,axisy-2*areay];
fill(okarea(:,1),okarea(:,2),'k')
fill(dftarea(:,1),dftarea(:,2),'w')
stt=true;%true: on, ready to insert; false: off, waiting for the 2nd point
polygon=false;%%
n=0;%number of segments
%debug%
mdldisp=['A_1';'A_2';'A_3';'B_1';'B_2';'B_3';'B_4';'B_5';'B_6';'C  ';...
    'D_1';'D_2';'D_3';'D_4';'E  ';'nil';'DK '];
%--%
while n<=nmax
    %display current operation
    if n==0
        set(msg1,'string',['Insert the first edge. Or click the white '...
            'area and load default data.'],'fontsize',11.5,'horizontal','left');
    else
        if stt
            set(msg1,'string',['Insert a new line: The ',orderdisp(n+1),...
                ' edge. First end point. Or click the black area to finish.'],...
                'fontsize',11.5,'horizontal','left');
        else
            set(msg1,'string',['Insert a new line: The ',orderdisp(n),...
                ' edge. Second end point.'],'fontsize',11.5,...
                'horizontal','left');
        end
    end
    %ginput
    [x,y]=ginput(1);
    if (x-(axisx-areax))*(x-axisx)<0&&(y-(axisy-2*areay))*(y-(axisy-areay))<0||((x-(axisx-areax))*(x-axisx)<0&&(y-(axisy-areay))*(y-axisy)<0&&n==0)
        break
    end
    plot(x,y,'ro')
    if stt
        n=n+1;
        segset(n,1:2)=[x,y];
    else
        segset(n,3:4)=[x,y];
        plot(segset(n,[1,3]),segset(n,[2,4]),'b');
    end
    stt=~stt;
end
if n~=nmax
    segset=segset(1:n,:);
end

%default map
dftmap=[2,2,2,7;2,7,3,8;3,8,8,8;8,8,8,2;8,2,4,2;4,2,4,6;4,6,6,6;6,6,6,4];
if n==0
    segset=dftmap;
    n=8;
end

%Robot
% display current operation
set(msg1,'string','Set original position of the robot. Or click the white area and load default data.',...
    'fontsize',11.5,'horizontal','left');
[rx,ry]=ginput(1);
if (rx-(axisx-areax))*(rx-axisx)<0&&(ry-(axisy-areay))*(ry-axisy)<0
    rx=5;
    ry=5;
end
plot(rx,ry,'ro')
a=2*pi/ns;

%Probing & Moving
set(msg1,'string','Looking for exit...','fontsize',11.5,'horizontal','left');
rtrack=zeros(stpmax,2);rtrack(1,:)=[rx,ry];
start=false;
stp=0;
istouch=false;
while ~get(t_quit,'value')
    if ~get(t_start,'value')
        v_n=get(t_n,'value');
        v_s=get(t_s,'value');
        v_w=get(t_w,'value');
        v_e=get(t_e,'value');
        v_ne=get(t_ne,'value');
        v_se=get(t_se,'value');
        v_sw=get(t_sw,'value');
        v_nw=get(t_nw,'value');
        if any([v_n,v_s,v_w,v_e,v_ne,v_se,v_sw,v_nw])||~start
            start=true;
            dir=find([v_n,v_s,v_w,v_e,v_ne,v_se,v_sw,v_nw]);
            if dir
            %movement detected
            rxo=rx;
            ryo=ry;
            switch dir(1)
                case 1
                    ry=ry+ds;
                    set(t_n,'value',0)
                case 2
                    ry=ry-ds;
                    set(t_s,'value',0)
                case 3
                    rx=rx-ds;
                    set(t_w,'value',0)
                case 4
                    rx=rx+ds;
                    set(t_e,'value',0)
                case 5
                    rx=rx+ds;
                    ry=ry+ds;
                    set(t_ne,'value',0)
                case 6
                    rx=rx+ds;
                    ry=ry-ds;
                    set(t_se,'value',0)
                case 7
                    rx=rx-ds;
                    ry=ry-ds;
                    set(t_sw,'value',0)
                case 8
                    rx=rx-ds;
                    ry=ry+ds;
                    set(t_nw,'value',0)
            end
            if approachwall(segset,[rx,ry],2*r)
                set(msg1,'string','Approaching wall...',...
                    'fontsize',11.5,'horizontal','left');
            else
                set(msg1,'string','Searching exit...',...
                    'fontsize',11.5,'horizontal','left');
            end
            [istouch,~]=approachwall(segset,[rx,ry],r);
            if istouch
                set(msg1,'string','Robot has touched wall... Move back.',...
                    'fontsize',11.5,'horizontal','left');
                rx=rxo;
                ry=ryo;
            end
            end
            if ~istouch
                stp=stp+1;
                if stp>stpmax
                    rtrack=[rtrack;zeros(stpmax,2)];
                    stpmax=2*stpmax;
                end
%                 %debug%
%                 disp(stp)
%                 %--%
                rtrack(stp,:)=[rx,ry];
                %reprobe
                rs=sonomeasure(segset,[rx,ry],polygon,ns);
                [modelpt,mptadd,finished,mdl]=sonomodel(rs,r);%!!
                %redraw
                cla
                % environment
                if ~mapoff
                    for k=1:n
                        plot(segset(k,[1,3]),segset(k,[2,4]),'--r','LineWidth',2)
                    end
                end
                % probing data
                for k=1:ns
                    plot(rx+rs(k)*cos(((k-1):.1:k)*a),ry+rs(k)*sin(((k-1):.1:k)*a),'b:')
                end
                plot(rx,ry,'ro');%text(rx-.15,ry-.15,'Robot');
                plot(rx+r*cos((0:.1:2)*pi),ry+r*sin((0:.1:2)*pi),'b','LineWidth',1.45);
                % model report
                mdlrpt=[0 0];
                for k=1:ns
                    if finished(k)
                        plot(rx+modelpt(k,[1,3]),ry+modelpt(k,[2,4]),'k','LineWidth',1.5)
                        switch mdl(k)
                            case {1,2,3}
                                plot(rx+(rs(k)-.2)*cos((k-1:.1:k)*a),ry+(rs(k)-.2)*sin((k-1:.1:k)*a),'c','LineWidth',2.5);
                                mdlrpt(1)=1;
                            case {4,5,6,7,8,9}
                                plot(rx+(rs(k)-.2)*cos((k-1:.1:k)*a),ry+(rs(k)-.2)*sin((k-1:.1:k)*a),'g','LineWidth',2.5);
                                mdlrpt(2)=1;
                        end
                    end
                end
                for k=1:size(mptadd,1)
                    plot(rx+mptadd(k,[1,3]),ry+mptadd(k,[2,4]),'k','LineWidth',1.5)
                end
                if mdlrpt(1)&&mdlrpt(1)
                    set(msg2,'string','Faultages found...',...
                        'fontsize',11.5,'horizontal','left');
                elseif mdlrpt(1)
                    set(msg2,'string','Faultages on two sides...',...
                        'fontsize',11.5,'horizontal','left');
                elseif mdlrpt(2)
                    set(msg2,'string','Faultages on one side...',...
                        'fontsize',11.5,'horizontal','left');
                else
                    set(msg2,'string','Measurement results...',...
                        'fontsize',11.5,'horizontal','left');
                end
                % robot track
                plot(rtrack(1:stp,1),rtrack(1:stp,2),'b:')
                %debug%
                % report model
                for k=1:ns
                    text(rx+rs(k)*cos((k-.5)*a),ry+rs(k)*sin((k-.5)*a),mdldisp(mdl(k),:))
                end
            end
        end
    else
%         %test
%         pause(0.5)
%         beep
        %--%
        %Auto Move
        
    end
    pause(0.01);
end
close
end
