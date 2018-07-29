function sonorobot_keyboard(r,ns,ds,mapoff)
if nargin<4
    mapoff = false;
    if nargin<3
        ds = .1;
        if nargin<2
            ns = 24;
            if nargin<1;
                r = .37;
            end
        end
    end
end
f_h = figure('name','Sono Robot','numbertitle','off','menubar','none');
set(f_h,'keypressfcn',@robot_move_fcn)
uicontrol(f_h,'style','toggle','position',[505,5,50,25],...
    'string','Quit','callback','close');
msg1 = uicontrol(f_h,'style','text','position',[15,5,480,55]);
msg2 = uicontrol(f_h,'style','text','position',[15,65,480,25],...
    'string','Measurement results...','fontsize',11.5,...
    'horizontal','left');
hold on
axisx = 12.5;
axisy = 10;
axis([0 axisx 0 axisy]);
axis off
%Input walls & robot position
%Environment
nmax = 50;
stpmax = 100;
segset = zeros(nmax,4);%line segment set:[Ax,Ay,Bx,By]
areax = 1;
areay = .5;
dftarea = [axisx-areax,axisy-areay;axisx-areax,axisy;axisx,axisy;axisx,axisy-areay];
okarea = [axisx-areax,axisy-2*areay;axisx-areax,axisy-areay;axisx,axisy-areay;axisx,axisy-2*areay];
fill(okarea(:,1),okarea(:,2),'k')
fill(dftarea(:,1),dftarea(:,2),'w')
stt = true;%true: on, ready to insert; false: off, waiting for the 2nd point
polygon = false;%%
n = 0;%number of segments
%debug%
mdldisp = ['A_1';'A_2';'A_3';'B_1';'B_2';'B_3';'B_4';'B_5';'B_6';'C  ';...
    'D_1';'D_2';'D_3';'D_4';'E  ';'nil';'DK '];
%--%
while n <= nmax
    %display current operation
    if n == 0
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
    [x,y] = ginput(1);
    if (x-(axisx-areax))*(x-axisx)<0&&(y-(axisy-2*areay))*(y-(axisy-areay))<0 ||...
           ((x-(axisx-areax))*(x-axisx) < 0&&(y-(axisy-areay))*(y-axisy)<0&&n == 0)
        break
    end
    plot(x,y,'ro')
    if stt
        n = n+1;
        segset(n,1:2) = [x,y];
    else
        segset(n,3:4) = [x,y];
        plot(segset(n,[1,3]),segset(n,[2,4]),'b');
    end
    stt = ~stt;
end
if n ~= nmax
    segset = segset(1:n,:);
end

%default map
dftmap = [2,2,2,7;2,7,3,8;3,8,8,8;8,8,8,2;8,2,4,2;4,2,4,6;4,6,6,6;6,6,6,4];
if n == 0
    segset = dftmap;
    n = 8;
end

%Robot
% display current operation
set(msg1,'string','Set original position of the robot. Or click the white area and load default data.',...
    'fontsize',11.5,'horizontal','left');
[rx,ry] = ginput(1);
if (rx-(axisx-areax))*(rx-axisx)<0&&(ry-(axisy-areay))*(ry-axisy)<0
    rx = 5;
    ry = 5;
end
plot(rx,ry,'ro')
a = 2*pi/ns;

%Probing & Moving
set(msg1,'string','Looking for exit...','fontsize',11.5,'horizontal','left');
rtrack = zeros(stpmax,2);rtrack(1,:) = [rx,ry];
stp = 0;
    function robot_move_fcn( ~,evt)
        switch evt.Key
            case {'w','uparrow'}
                ry = ry+ds;
            case {'s','downarrow'}
                ry = ry-ds;
            case {'a','leftarrow'}
                rx = rx-ds;
            case {'d','rightarrow'}
                rx = rx+ds;
        end
        rxo = rx;
        ryo = ry;
        if approachwall(segset,[rx,ry],2*r)
            set(msg1,'string','Approaching wall...',...
                'fontsize',11.5,'horizontal','left');
        else
            set(msg1,'string','Searching exit...',...
                'fontsize',11.5,'horizontal','left');
        end
        [istouch,~] = approachwall(segset,[rx,ry],r);
        if istouch
            set(msg1,'string','Robot has touched wall... Move back.',...
                'fontsize',11.5,'horizontal','left');
            rx = rxo;
            ry = ryo;
        end
        if ~istouch
            stp = stp+1;
            if stp>stpmax
                rtrack = [rtrack;zeros(stpmax,2)];
                stpmax = 2*stpmax;
            end
            rtrack(stp,:) = [rx,ry];
            %reprobe
            rs = sonomeasure(segset,[rx,ry],polygon,ns);
            [modelpt,mptadd,finished,mdl] = sonomodel(rs,r);%!!
            %redraw
            cla
            % environment
            if ~mapoff
                for k = 1:n
                    plot(segset(k,[1,3]),segset(k,[2,4]),'--r','LineWidth',2)
                end
            end
            % probing data
            for k = 1:ns
                plot(rx+rs(k)*cos(((k-1):.1:k)*a),ry+rs(k)*sin(((k-1):.1:k)*a),'b:')
            end
            plot(rx,ry,'ro');%text(rx-.15,ry-.15,'Robot');
            plot(rx+r*cos((0:.1:2)*pi),ry+r*sin((0:.1:2)*pi),'b','LineWidth',1.45);
            % model report
            mdlrpt = [0 0];
            for k = 1:ns
                if finished(k)
                    plot(rx+modelpt(k,[1,3]),ry+modelpt(k,[2,4]),'k','LineWidth',1.5)
                    switch mdl(k)
                        case {1,2,3}
                            plot(rx+(rs(k)-.2)*cos((k-1:.1:k)*a),ry+(rs(k)-.2)*sin((k-1:.1:k)*a),'c','LineWidth',2.5);
                            mdlrpt(1) = 1;
                        case {4,5,6,7,8,9}
                            plot(rx+(rs(k)-.2)*cos((k-1:.1:k)*a),ry+(rs(k)-.2)*sin((k-1:.1:k)*a),'g','LineWidth',2.5);
                            mdlrpt(2) = 1;
                    end
                end
            end
            for k = 1:size(mptadd,1)
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
            for k = 1:ns
                text(rx+rs(k)*cos((k-.5)*a),ry+rs(k)*sin((k-.5)*a),mdldisp(mdl(k),:))
            end
        end
    end

end
