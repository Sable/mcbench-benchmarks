function animation(varargin)
% - input of q and qd so that tire forces and alphas and kappas can be
%    calculated
% - parameter fit on fjr1300
% - measurement vector implementation in this file
% - validation of model on roundabout, slalom, and j-turn
% improve plotcom function



fh = initialize_plot;
zoom(3)
camproj('perspective')
% test if it should draw a kinematic model, or an animation
% if kinematic, draw gui elements
% else, initialize force elements
p=parameters('dummy');

if nargin<1
    q  = coordinates('dummy');
    % text, no user interface
    uicontrol('style','text','String','qx: x-position' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,540,110,20]);
    uicontrol('style','text','String','qy: y-position' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,500,110,20]);
    uicontrol('style','text','String','qz: z-position' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,460,110,20]);
    uicontrol('style','text','String','q0: rear yaw'   ,'FontSize',12,'HorizontalAlignment','left','Position',[10,420,110,20]);
    uicontrol('style','text','String','q1: rear roll'  ,'FontSize',12,'HorizontalAlignment','left','Position',[10,380,110,20]);
    uicontrol('style','text','String','q2: rear pitch' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,340,110,20]);
    uicontrol('style','text','String','q3: steering'   ,'FontSize',12,'HorizontalAlignment','left','Position',[10,300,110,20]);
    uicontrol('style','text','String','q4: front yaw'  ,'FontSize',12,'HorizontalAlignment','left','Position',[10,260,110,20]);
    uicontrol('style','text','String','q5: front roll' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,220,110,20]);
    uicontrol('style','text','String','q6: front pitch','FontSize',12,'HorizontalAlignment','left','Position',[10,180,110,20]);
    uicontrol('style','text','String','q7: swingarm'   ,'FontSize',12,'HorizontalAlignment','left','Position',[10,140,110,20]);
    uicontrol('style','text','String','qf: front fork' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,100,110,20]);
    uicontrol('style','text','String','q8: rear wheel' ,'FontSize',12,'HorizontalAlignment','left','Position',[10,60,110,20]);
    uicontrol('style','text','String','q9: front wheel','FontSize',12,'HorizontalAlignment','left','Position',[10,20,110,20]);

    % sliders
    qx_s = uicontrol('style','slider','Min',-2,'Max',2,'Value',q.qx,'Position',[120,540,100,20],'Callback',{@update_qx_edit});
    qy_s = uicontrol('style','slider','Min',-2,'Max',2,'Value',q.qy,'Position',[120,500,100,20],'Callback',{@update_qy_edit});
    qz_s = uicontrol('style','slider','Min',0,'Max',2,'Value',q.qz,'Position',[120,460,100,20],'Callback',{@update_qz_edit});
    q0_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q0,'Position',[120,420,100,20],'Callback',{@update_q0_edit});
    q1_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q1,'Position',[120,380,100,20],'Callback',{@update_q1_edit});
    q2_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q2,'Position',[120,340,100,20],'Callback',{@update_q2_edit});
    q3_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q3,'Position',[120,300,100,20],'Callback',{@update_q3_edit});
    q4_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q4,'Position',[120,260,100,20],'Callback',{@update_q4_edit});
    q5_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q5,'Position',[120,220,100,20],'Callback',{@update_q5_edit});
    q6_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q6,'Position',[120,180,100,20],'Callback',{@update_q6_edit});
    q7_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q7,'Position',[120,140,100,20],'Callback',{@update_q7_edit});
    qf_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.qf,'Position',[120,100,100,20],'Callback',{@update_qf_edit});
    q8_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q8,'Position',[120,060,100,20],'Callback',{@update_q8_edit});
    q9_s = uicontrol('style','slider','Min',-pi,'Max',pi,'Value',q.q9,'Position',[120,020,100,20],'Callback',{@update_q9_edit});

    % edit boxes
    qx_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.qx,'Position',[220,540,72,20],'Callback',{@update_qx_slider});
    qy_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.qy,'Position',[220,500,72,20],'Callback',{@update_qy_slider});
    qz_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.qz,'Position',[220,460,72,20],'Callback',{@update_qz_slider});
    q0_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q0,'Position',[220,420,72,20],'Callback',{@update_q0_slider});
    q1_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q1,'Position',[220,380,72,20],'Callback',{@update_q1_slider});
    q2_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q2,'Position',[220,340,72,20],'Callback',{@update_q2_slider});
    q3_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q3,'Position',[220,300,72,20],'Callback',{@update_q3_slider});
    q4_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q4,'Position',[220,260,72,20],'Callback',{@update_q4_slider});
    q5_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q5,'Position',[220,220,72,20],'Callback',{@update_q5_slider});
    q6_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q6,'Position',[220,180,72,20],'Callback',{@update_q6_slider});
    q7_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q7,'Position',[220,140,72,20],'Callback',{@update_q7_slider});
    qf_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.qf,'Position',[220,100,72,20],'Callback',{@update_qf_slider});
    q8_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q8,'Position',[220,060,72,20],'Callback',{@update_q8_slider});
    q9_e = uicontrol('Style','edit','backgroundColor','w','FontSize',12,'String',q.q9,'Position',[220,020,72,20],'Callback',{@update_q9_slider});

    %buttons
    uicontrol('style','pushbutton','String','write current configuration to command window' ,'FontSize',10,'HorizontalAlignment','left','Position',[10,580,282,20],'Callback',{@write_q});
    updateplot(q);
    set(fh.f,'Visible','on');
    assignin('base','fh',fh)
else
    fhf=initialize_force_elements;
    qt=varargin{1};
    if nargin >1
    qdt=varargin{2};
    else
        qdt=0*qt;
    end
    tic
    for i=1:length(qt)
        q.qx=qt(i,1);q.qy=qt(i,2);q.qz=qt(i,3);
        q.q0=qt(i,4);q.q1=qt(i,5);q.q2=qt(i,6);
        q.q4=qt(i,7);q.q5=qt(i,8);q.q6=qt(i,9);
        q.q7=qt(i,10);q.qf=qt(i,11);q.q8=qt(i,12);q.q9=qt(i,13);
        qd.qxd=qdt(i,1);qd.qyd=qdt(i,2);qd.qzd=qdt(i,3);
        qd.q0d=qdt(i,4);qd.q1d=qdt(i,5);qd.q2d=qdt(i,6);
        qd.q4d=qdt(i,7);qd.q5d=qdt(i,8);qd.q6d=qdt(i,9);
        qd.q7d=qdt(i,10);qd.qfd=qdt(i,11);qd.q8d=qdt(i,12);qd.q9d=qdt(i,13);
  
        updateplot(q,qd)
        set(fh.f,'Visible','on');
    end
end
% update state vector;
% update force vector if it exist
% update plot;
% goto update state vector


% implement correct parameters;
% implement planar slip and normal force visualization.


% update edit boxes
    function update_qx_edit(varargin); 		q.qx = get(qx_s,'value');	set(qx_e,'string',q.qx,'userdata',q.qx);    updateplot;    end
    function update_qy_edit(varargin);		q.qy = get(qy_s,'value');	set(qy_e,'string',q.qy,'userdata',q.qy);    updateplot;    end
    function update_qz_edit(varargin);		q.qz = get(qz_s,'value');	set(qz_e,'string',q.qz,'userdata',q.qz);    updateplot;    end
    function update_q0_edit(varargin);		q.q0 = get(q0_s,'value');	set(q0_e,'string',q.q0,'userdata',q.q0);    update_qf;     end
    function update_q1_edit(varargin);		q.q1 = get(q1_s,'value');	set(q1_e,'string',q.q1,'userdata',q.q1);    update_qf;     end
    function update_q2_edit(varargin);		q.q2 = get(q2_s,'value');	set(q2_e,'string',q.q2,'userdata',q.q2);    update_qf;     end
    function update_q3_edit(varargin);		q.q3 = get(q3_s,'value');	set(q3_e,'string',q.q3,'userdata',q.q3);    update_qf;     end
    function update_q4_edit(varargin);		q.q4 = get(q4_s,'value');	set(q4_e,'string',q.q4,'userdata',q.q4);    update_qr;     end
    function update_q5_edit(varargin);		q.q5 = get(q5_s,'value');	set(q5_e,'string',q.q5,'userdata',q.q5);    update_qr;     end
    function update_q6_edit(varargin);		q.q6 = get(q6_s,'value');	set(q6_e,'string',q.q6,'userdata',q.q6);    update_qr;     end
    function update_q7_edit(varargin);		q.q7 = get(q7_s,'value');	set(q7_e,'string',q.q7,'userdata',q.q7);    updateplot;    end
    function update_qf_edit(varargin);		q.qf = get(qf_s,'value');	set(qf_e,'string',q.qf,'userdata',q.qf);    updateplot;    end
    function update_q8_edit(varargin);		q.q8 = get(q8_s,'value');	set(q8_e,'string',q.q8,'userdata',q.q8);    updateplot;    end
    function update_q9_edit(varargin);		q.q9 = get(q9_s,'value');	set(q9_e,'string',q.q9,'userdata',q.q9);    updateplot;    end

% update sliders
    function update_qx_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.qx = str2double(val);    updateplot;    end
    function update_qy_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.qy = str2double(val);    updateplot;    end
    function update_qz_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.qz = str2double(val);    updateplot;    end
    function update_q0_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q0 = str2double(val);    update_qf;    end
    function update_q1_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q1 = str2double(val);    update_qf;    end
    function update_q2_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q2 = str2double(val);    update_qf;    end
    function update_q3_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q3 = str2double(val);    update_qf;    end
    function update_q4_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q4 = str2double(val);    update_qr;    end
    function update_q5_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q5 = str2double(val);    update_qr;    end
    function update_q6_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q6 = str2double(val);    update_qr;    end
    function update_q7_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q7 = str2double(val);    updateplot;    end
    function update_qf_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.qf = str2double(val);    updateplot;    end
    function update_q8_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q8 = str2double(val);    updateplot;    end
    function update_q9_slider(varargin);	val = get(qx_e,'string');	if isnan(str2double(val)) || str2double(val) < get(qx_s,'min') || str2double(val) > get(qx_s,'max');	set(editHandle,'string',get(editHandle,'userdata'));	return;    end;		set(qx_s,'value',str2double(val));	set(qx_e,'userdata',val);   q.q9 = str2double(val);    updateplot;    end

    function write_q(varargin)
        assignin('base','ans',q);
    end
% q8 = q0+atan((s3*c2)/(c1*c3-s1*s2*s3))  ; % kinematic steering angle in Cossalter
% q4 = -atan((-s3*tan(q1)+s2*c3)/c2)      ; % front wheel camber angle
% q5 = -asin(c1*s2*s3+s1*c3)              ; % front fork angle (measuered in front wheel plane)


    function update_qf
        q.q4 = q.q0+atan((sin(q.q3)*cos(q.q2))/(cos(q.q1)*cos(q.q3)-sin(q.q1)*sin(q.q2)*sin(q.q3)));
        q.q5 = asin(cos(q.q1)*sin(q.q2)*sin(q.q3)+sin(q.q1)*cos(q.q3))     ;
        q.q6 = atan((-sin(q.q3)*tan(q.q1)+sin(q.q2)*cos(q.q3))/cos(q.q2))  ;
        set(q4_s,'value',q.q4,'userdata',q.q4);
        set(q5_s,'value',q.q5,'userdata',q.q5);
        set(q6_s,'value',q.q6,'userdata',q.q6);
        set(q4_e,'string',q.q4,'userdata',q.q4);
        set(q5_e,'string',q.q5,'userdata',q.q5);
        set(q6_e,'string',q.q6,'userdata',q.q6);
        updateplot
    end

    function update_qr
        q.q3=-q.q3;
        q.q0 = q.q4+atan((sin(q.q3)*cos(q.q6))/(cos(q.q5)*cos(q.q3)-sin(q.q5)*sin(q.q6)*sin(q.q3)));
        q.q1 = asin(cos(q.q5)*sin(q.q6)*sin(q.q3)+sin(q.q5)*cos(q.q3))     ;
        q.q2 = atan((-sin(q.q3)*tan(q.q5)+sin(q.q6)*cos(q.q3))/cos(q.q6))  ;
        q.q3=-q.q3;
        set(q0_s,'value',q.q0,'userdata',q.q0);
        set(q1_s,'value',q.q1,'userdata',q.q1);
        set(q2_s,'value',q.q2,'userdata',q.q2);
        set(q0_e,'string',q.q0,'userdata',q.q0);
        set(q1_e,'string',q.q1,'userdata',q.q1);
        set(q2_e,'string',q.q2,'userdata',q.q2);
        updateplot
    end

% update plot
    function updateplot(varargin)
        % create frequently used expressions
        a1 = p.a1  ; l2 = p.l2  ; l3 = p.l3 ; m5 = p.m5  ; a6 = p.a6 ;
        b1 = p.b1  ; m2 = p.m2  ; m3 = p.m3 ; x5 = p.x5  ; b6 = p.b6 ;
        m1 = p.m1  ; x2 = p.x2  ; x3 = p.x3 ; z5 = p.z5  ; m6 = p.m6 ;
        i1 = p.i1  ; i2 = p.i2  ; z3 = p.z3 ; i5 = p.i5  ; i6 = p.i6 ;
        j1 = p.j1  ; t2 = p.t2  ; i3 = p.i3 ; t5 = p.t5  ; j6 = p.j6 ;
        f1 = p.f1  ; b2 = p.b2  ; k3 = p.k3 ; b5 = p.b5  ; f6 = p.f6 ;
        e1 = p.e1  ; p2 = p.p2  ; d3 = p.d3 ; p5 = p.p5  ; e6 = p.e6 ;
        k1 = p.k1  ; d2 = p.d2  ; l4 = p.l4 ; d5 = p.d5  ; k6 = p.k6 ;
        d1 = p.d1  ; e2 = p.e2  ; m4 = p.m4 ; e5 = p.e5  ; d6 = p.d6 ;
        t1 = p.t1  ; k2 = p.k2  ; x4 = p.x4 ; k5 = p.k5  ; t6 = p.t6 ;
                     n2 = p.n2  ; z4 = p.z4 ; n5 = p.n5  ; 
                     f2 = p.f2  ; i4 = p.i4 ; f5 = p.f5  ; 

        qx=q.qx;qy=q.qy;qz=q.qz;
        q0=q.q0;q1=q.q1;q2=q.q2;
        q4=q.q4;q5=q.q5;q6=q.q6;
        q7=q.q7;qf=q.qf;q8=q.q8;q9=q.q9;
        
        s0 =sin(q.q0);    c0=cos(q.q0);     s1 =sin(q.q1);    c1=cos(q.q1);
        s2 =sin(q.q2);    c2=cos(q.q2);
        s4 =sin(q.q4);    c4=cos(q.q4);     s5 =sin(q.q5);    c5=cos(q.q5);
        s6 =sin(q.q6);    c6=cos(q.q6);     s7 =sin(q.q7);    c7=cos(q.q7);
        s8 =sin(q.q8);    c8=cos(q.q8);     s9 =sin(q.q9);    c9=cos(q.q9);
        %         sb =sin(qb);    cb=cos(qb);     st =sin(qt);    ct=cos(qt);

        % create basic rotation matrices and their derivative
        R0 = [c0 -s0 0;s0 c0 0;0 0 1]; R0q = [-s0 -c0 0;c0 -s0 0;0 0 0]; % rear yaw (rate)
        R1 = [1 0 0;0 c1 -s1;0 s1 c1]; R1q = [0 0 0;0 -s1 -c1;0 c1 -s1]; % rear roll (rate)
        R2 = [c2 0 s2;0 1 0;-s2 0 c2]; R2q = [-s2 0 c2;0 0 0;-c2 0 -s2]; % rear pitch (rate)
        R4 = [c4 -s4 0;s4 c4 0;0 0 1]; R4q = [-s4 -c4 0;c4 -s4 0;0 0 0]; % front yaw (rate)
        R5 = [1 0 0;0 c5 -s5;0 s5 c5]; R5q = [0 0 0;0 -s5 -c5;0 c5 -s5]; % front roll (rate)
        R6 = [c6 0 s6;0 1 0;-s6 0 c6]; R6q = [-s6 0 c6;0 0 0;-c6 0 -s6]; % front pitch (rate)
        R7 = [c7 0 s7;0 1 0;-s7 0 c7]; R7q = [-s7 0 c7;0 0 0;-c7 0 -s7]; % swingarm angle/angular velocity
        R8 = [c8 0 s8;0 1 0;-s8 0 c8]; R8q = [-s8 0 c8;0 0 0;-c8 0 -s8]; % rear wheel angle/angular velocity
        R9 = [c9 0 s9;0 1 0;-s9 0 c9]; R9q = [-s9 0 c9;0 0 0;-c9 0 -s9]; % front wheel angle/angular velocity

        % body orientations
        Rm1 = R0*R1*R8; % rear wheel
        Rm2 = R0*R1*R7; % swingarm
        Rm3 = R0*R1*R2; % frame
        Rm4 = R4*R5*R6; % steering head
        Rm5 = R4*R5*R6; % front fork
        Rm6 = R4*R5*R9; % front wheel

        R8 = eye(3); % rear wheel angle
        R9 = eye(3); % front wheel angle

        % joint positions
        r4 = [q.qx q.qy q.qz].'                                                     ; % steering joint position
        r3 = r4+R0*(R1*(R2*[-p.l3;0;0]))                                            ; % swingarm joint position
        r2 = r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2;0;0]))                             ; % rear wheel hub position
        r1 = r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2;0;0]+R8*[0;0;-p.b1]))              ; % rear tire torus centerline lowest point
        r0 = r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2;0;0]+R8*[0;0;-p.b1])+[0;0;-p.a1])  ; % rear wheel lowest point
        r5 = r4+R4*(R5*(R6*[p.l4;0;-q.qf]))                                         ; % front wheel hub position
        r6 = r4+R4*(R5*(R6*[p.l4;0;-q.qf]+R9*[0;0;-p.b6]))                          ; % front tyre torus centerline
        r7 = r4+R4*(R5*(R6*[p.l4;0;-q.qf]+R9*[0;0;-p.b6])+[0;0;-p.a6])              ; % front tyre outer surface

        R8 = [c8 0 s8;0 1 0;-s8 0 c8]; % rear wheel angle
        R9 = [c9 0 s9;0 1 0;-s9 0 c9]; % front wheel angle

        % body positions
        rm1=r2;% rear wheel
        rm2=r4+R0*(R1*(R2*[-p.l3;0;0]+R7*[-p.l2+p.x2;0;0])   );% swingarm
        rm3=r4+R0*(R1*(R2*[-p.l3+p.x3;0;p.z3])   );% frame
        rm4=r4+R4*(R5*(R6*[ p.x4;0;p.z4])   );% steering head
        rm5=r4+R4*(R5*(R6*[ p.l4+p.x5;0;-q.qf+p.z5]));% front fork
        rm6=r5;% front wheel
        
        % forces
        if nargin>1
        qxd=qd.qxd;qyd=qd.qyd;qzd=qd.qzd;
        q0d=qd.q0d;q1d=qd.q1d;q2d=qd.q2d;
        q4d=qd.q4d;q5d=qd.q5d;q6d=qd.q6d;
        q7d=qd.q7d;qfd=qd.qfd;q8d=qd.q8d;q9d=qd.q9d;

        g=9.81;     q70=-.4;      qf0=0.6;

        r0d =[qxd+(-s0*(-c2*l3-c7*l2)-c0*(-c1*s1*a1-s1*(s2*l3+s7*l2-b1-c1*a1)))*q0d+s0*c1*(s2*l3+s7*l2-b1-c1*a1)*q1d+(c0*s2*l3+s0*s1*c2*l3)*q2d+(c0*s7*l2+s0*s1*c7*l2)*q7d+c0*(-b1-c1*a1)*q8d
              qyd+(c0*(-c2*l3-c7*l2)-s0*(-c1*s1*a1-s1*(s2*l3+s7*l2-b1-c1*a1)))*q0d-c0*c1*(s2*l3+s7*l2-b1-c1*a1)*q1d+(s0*s2*l3-c0*s1*c2*l3)*q2d+(s0*s7*l2-c0*s1*c7*l2)*q7d+s0*(-b1-c1*a1)*q8d
              qzd-s1*(s2*l3+s7*l2-b1-c1*a1)*q1d+c1*c2*l3*q2d+c1*c7*l2*q7d];
        r7d =[qxd+(-s4*(c6*l4-s6*qf)-c4*(-c5*s5*a6-s5*(-s6*l4-c6*qf-b6-c5*a6)))*q4d+s4*c5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+(c4*(-s6*l4-c6*qf)+s4*s5*(-c6*l4+s6*qf))*q6d+(-c4*s6-sin(q4)*s5*c6)*qfd+c4*(-b6-c5*a6)*q9d
              qyd+(c4*(c6*l4-s6*qf)-s4*(-c5*s5*a6-s5*(-s6*l4-c6*qf-b6-c5*a6)))*q4d-c4*c5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+(s4*(-s6*l4-c6*qf)-c4*s5*(-c6*l4+s6*qf))*q6d+(-s4*s6+c4*s5*c6)*qfd+s4*(-b6-c5*a6)*q9d
              qzd-s5*(-s6*l4-c6*qf-b6-c5*a6)*q5d+c5*(-c6*l4+s6*qf)*q6d-c5*c6*qfd];

        r0  = [0;0;qz+c1*(s2*l3+s7*l2-b1)-a1];
        r7  = [0;0;qz-c5*(s6*l4+c6*qf+b6)-a6];
        vtr =-s0*r0d(1)+c0*r0d(2);
        vlr = c0*r0d(1)+s0*r0d(2)+.01;
        vtf =-s4*r7d(1)+c4*r7d(2);
        vlf = c4*r7d(1)+s4*r7d(2)+.01;
        v1  = [c0*s2+s0*s1*c2;s0*s2-c0*s1*c2;c1*c2];
        v2  = [c4*s6+s4*s5*c6;s4*s6-c4*s5*c6;c5*c6];

        Rm3 = R0*R1*R2; % frame
        Rm4 = R4*R5*R6; % steering head

        % 2. rotate one frame to get the z-axes colinear
            % first, find the axis about to rotate and the angle
        %     v1 = Rm3(:,3);
        %     v2 = Rm4(:,3);
            w  = cross(v1,v2)/norm(cross(v1,v2))   ;     % axis
        %     qqq  = acos((dot(v1,v2))) ;   % angle
            % second, use Rodrigues rotation formula to get the new x and y vectors
            x_old = Rm3(:,1);
            y_old = Rm3(:,2);
            z_old = Rm3(:,3);
            x_new = x_old*dot(v1,v2)+cross(w,x_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,x_old)*(1-dot(v1,v2));
            y_new = y_old*dot(v1,v2)+cross(w,y_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,y_old)*(1-dot(v1,v2));
%             z_new = z_old*dot(v1,v2)+cross(w,z_old)*sqrt(1-dot(v1,v2)^2)+w*dot(w,z_old)*(1-dot(v1,v2));
        % 3. calculate angle between the vectors
%         q3x = real(acos(complex(dot(x_new,Rm4(:,1)))));
        q3y = real(acos(complex(dot(y_new,Rm4(:,2)))));
%         q3=q3y;
%         T3  = u*(v1+v2)/norm(v1+v2);

        % forces/torques
%         Frs = k2*(q2-q7-q70)+b2*(q2d-q7d);
%         Ffs = k1*(qf-qf0)+d1*qfd;

        Fzr = max((-k1*r0(3)-d1*r0d(3))*(r0(3)<0),0) ;
%         Ftr = t1*Fzr*atan(-vtr/vlr);
%         Flr = Fzr*min(max(f1*((b1+a1*cos(q1))*q8d/vlr-1),-1),1);

        Fzf = max((-k1*r7(3)-d1*r7d(3))*(r7(3)<0),0) ;
%         Ftf = t6*Fzf*atan(-vtf/vlf);
%         Flf = Fzf*min(max(f6*((b6+a6*cos(q5))*q9d/vlf-1),-1),1);
% 
%         T1  =  k3*(pi/2-dot(v1,v2))*cross(v1,v2);

        %% experiment
        sr    =  r0d(1:2);
        Fr    =  -1*Fzr*(sr./((sr.'*sr)^4+1)^(1/8)+sr./((sr.'*sr)^2+1));
        Flr =  c0*Fr(1)+s0*Fr(2);
        Ftr = -s0*Fr(1)+c0*Fr(2);

        ss    =  r7d(1:2);
        Ff    =  -1*Fzf*(ss./((ss.'*ss)^4+1)^(1/8)+ss./((ss.'*ss)^2+1));
        Flf =  c4*Ff(1)+s4*Ff(2);
        Ftf = -s4*Ff(1)+c4*Ff(2);
        
        % update force elements
        assignin('base','fhf',fhf)
        set(fhf.l3,'YData',Fzr)
        set(fhf.l4,'YData',Fzf)
        l1=compass(fhf.h_ax1,[2000 Ftr],[0 Flr]);
        l2=compass(fhf.h_ax2,[2000 Ftf],[0 Flf]);
        set(l1,'linewidth',3);
        set(l2,'linewidth',3);
        set(l1(1),'visible','off');
        set(l2(1),'visible','off');
        set(l1(2),'visible','on');
        set(l2(2),'visible','on');

        end
        
        % visualisation

        % joint positions
        updateframe(fh.r01,r0,eye(3))   ; % rear wheel lowest point
        updateframe(fh.r02,r0,R0)       ; % rear wheel lowest point
        updateframe(fh.r03,r1,R0)       ; % rear tire torus centerline lowest point
        updateframe(fh.r04,r1,R0*R1)    ; % rear tire torus centerline lowest point
        updateframe(fh.r05,r2,R0*R1)    ; % rear wheel hub
        updateframe(fh.r06,r2,R0*R1*R7) ; % rear wheel hub
        updateframe(fh.r07,r3,R0*R1*R7) ; % swingarm joint
        updateframe(fh.r08,r3,R0*R1*R2) ; % swingarm joint
        updateframe(fh.r09,r4,R0*R1*R2) ; % steering joint
        updateframe(fh.r10,r4,R4*R5*R6) ; % steering joint
        updateframe(fh.r11,r5,R4*R5*R6) ; % front wheel hub
        updateframe(fh.r12,r5,R4*R5)    ; % front wheel hub
        updateframe(fh.r13,r6,R4*R5)    ; % front tire torus centerline lowest point
        updateframe(fh.r14,r6,R4)       ; % front tire torus centerline lowest point
        updateframe(fh.r15,r7,R4)       ; % front wheel lowest point
        updateframe(fh.r16,r7,eye(3))   ; % front wheel lowest point

        % update center of masses
        updatecom(fh.c1,rm1,Rm1);
        updatecom(fh.c2,rm2,Rm2);
        updatecom(fh.c3,rm3,Rm3);
        updatecom(fh.c4,rm4,Rm4);
        updatecom(fh.c5,rm5,Rm5);
        updatecom(fh.c6,rm6,Rm6);
       
        % update bodies
        updatewheel(fh.rwl,r2,Rm1,p.b1,p.a1);
        updatewheel(fh.fwl,r5,Rm6,p.b6,p.a6);
        updateswingarm(fh.swa,r2,Rm2)
        updatesteeringhead(fh.sth,r4,Rm4,p.l4)
        updatefrontfork(fh.ffo,r5,Rm5)

        axis(fh.ax1,[q.qx-2 q.qx+2 q.qy-2 q.qy+2 0 2])
        set(fh.ax1,'DataAspectRatio',[1 1 1])
        
        drawnow
        title(toc)
        tic
    end

end

function updateframe(h,O,R)
        p=R*[1 0 0;0 0 0;0 1 0;0 0 0;0 0 1;0 0 0].'/5;
        p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];
        set(h,'Faces',1:6,'Vertices',p.');
end
function updatecom(h,p,R)
a = .44433292853227944784221559874174;
v = [ 0 0 1;sin(pi/8) 0 cos(pi/8);0 sin(pi/8) cos(pi/8);
    sin(pi/4) 0 sin(pi/4);a a sqrt(1-2*a^2);0 sin(pi/4) sin(pi/4);
    cos(pi/8) 0 sin(pi/8);sqrt(1-2*a^2) a a;a sqrt(1-2*a^2) a;0 cos(pi/8) sin(pi/8);
    1 0 0;cos(pi/8) sin(pi/8) 0;sin(pi/4) sin(pi/4) 0;sin(pi/8) cos(pi/8) 0;0 1 0]./20;
v1= [-v(:,1) -v(:,2) v(:,3)];
v2= [v(:,1) -v(:,2) -v(:,3)];
v3= [-v(:,1) v(:,2) -v(:,3)];
v4= R*[v;v1;v2;v3].';
v5= -v4;
v4= [v4(1,:)+p(1);v4(2,:)+p(2);v4(3,:)+p(3)];
v5= [v5(1,:)+p(1);v5(2,:)+p(2);v5(3,:)+p(3)];
set(h.h1,'Vertices',v4');
set(h.h2,'Vertices',v5');
end
function updatewheel(h,O,R,r2,r1)
n=64;
t=linspace(-pi,pi,n);
[u v] = meshgrid(t,linspace(-pi/2,pi/2,16));
x = reshape((r2+r1*cos(v)).*cos(u),1,16*n);
y = reshape(    r1*sin(v),1,16*n);
z = reshape((r2+r1*cos(v)).*sin(u),1,16*n);
p  = R*[x;y;z];

p1 = reshape(p(1,:)+O(1),16,n);
p2 = reshape(p(2,:)+O(2),16,n);
p3 = reshape(p(3,:)+O(3),16,n);

set(h.h1,'XData',p1,'YData',p2,'ZData',p3);


% rim
f  =reshape([1:n;[(n+2):(2*n) n+1]],2*n,1);
f1 =[f circshift(f,-1) circshift(f,-2)];

x1 = [r2*sin(t) (r2-.02)*sin(t-pi/n) (r2-.02)*sin(t-2*pi/n) r2* sin(t-3*pi/n)];
y1 = [r1*ones(1,n) (r1-.01)*ones(1,n) -(r1-.01)*ones(1,n) -r1*ones(1,n)];
z1 = [r2*cos(t) (r2-.02)*cos(t-pi/n) (r2-.02)*cos(t-2*pi/n) r2* cos(t-3*pi/n)];

p  = R*[x1;y1;z1];
p  = [p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h2,'vertices',p.','faces',[f1;f1+n;f1+n*2],'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');

% spokes
d1 = .01;
x2 = (r2-.02)* sin(2*pi*[-d1 d1 1-d1 1+d1 2-d1 2+d1]/3);
z2 = (r2-.02)* cos(2*pi*[-d1 d1 1-d1 1+d1 2-d1 2+d1]/3);
d2 = .5;
x3 = 0.03* sin(2*pi*[-d2 d2 1-d2 1+d2 2-d2 2+d2]/3);
z3 = 0.03* cos(2*pi*[-d2 d2 1-d2 1+d2 2-d2 2+d2]/3);
y2 = [.015*ones(1,6) .04*ones(1,6)];

p1 = R*[[x2 x3 x2 x3];[y2 -y2];[z2 z3 z2 z3]];
p1 = [p1(1,:)+O(1);p1(2,:)+O(2);p1(3,:)+O(3)];
f3 = [1 2 8 7;3 4 10 9;5 6 12 11;13 14 20 19;15 16 22 21;17 18 24 23;1 13 19 7;2 14 20 8;3 15 21 9;4 16 22 10;5 17 23 11;6 18 24 12 ];
set(h.h3,'vertices',p1');

% hub
x5 = .04*[sin(t-pi/n) sin(t-2*pi/n)];
y5 = .09*[ones(1,n) -ones(1,n)];
z5 = .04*[cos(t-pi/n) cos(t-2*pi/n)];
p5 = R*[x5;y5;z5];
p5 = [p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

set(h.h4,'vertices',p5.');
set(h.h5,'vertices',p5.');

end
function updateswingarm(h,O,R)
l=0.5;% swingarm length
w=0.2;% swingarm width
d1=0.04;%
d2=.4;%
d3=.45;%
d4=.55;%
d5=.35;%
d6=.40;%

w1=0.12;% swingarm width
w2=0.05;% swingarm front width
w3=0.095;% swingarm inner width
w4=0.01;%

h1=0.04;% swingarm height

x1=[-d1 d2  d3  d4  d4 d3 d2 -d1 -d1 d5 d6 d6 d5 -d1];
y1=[-w1 -w1 -w2 -w2 w2 w2 w1 w1 w3 w3 w4 -w4 -w3 -w3];
z1=[-h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1 -h1]/2;
p=R*[[x1 x1];[y1 y1];[z1 -z1]];
p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h1,'Vertices',p')
set(h.h2,'Vertices',p')
end
function updatesteeringhead(h,O,R,d3)
hp=0.0;
l=0.40;%fork length
% h=0.08;%
w=0.2;% width
d1=0.06;% outer diameter telescopic fork suspension tube
d2=0.04;% steering head joint diameter
%d3=100e-3;% fork offset
d4=20e-3 ;% Steering stem triple clamp overhang
t1=20e-3 ;% Steering stem triple clamp thickness
t2=150e-3;% steering head joint height
t3=0.05;% vertical offset
n=32;
t=linspace(-pi,pi,n);
x1=d1/2*cos(t);
y1=d1/2*sin(t);
h1=t2/2*ones(1,n)+hp;
h2=(t2/2-l)*ones(1,n)+hp;

p1=R*[x1+d3 x1+d3;y1+w/2 y1+w/2;h1+t3 h2+t3];
p1=[p1(1,:)+O(1);p1(2,:)+O(2);p1(3,:)+O(3)];
set(h.h1,'Vertices',p1');

p2=R*[x1+d3 x1+d3;y1-w/2 y1-w/2;h1+t3 h2+t3];
p2=[p2(1,:)+O(1);p2(2,:)+O(2);p2(3,:)+O(3)];
set(h.h2,'Vertices',p2');

x2=d2/2*cos(t);
y2=d2/2*sin(t);
h1=-t2/2*ones(1,n)+hp;
h2=t2/2*ones(1,n)+hp;

p3=R*[x2 x2;y2 y2;h1+t3 h2+t3];
p3=[p3(1,:)+O(1);p3(2,:)+O(2);p3(3,:)+O(3)];
set(h.h3,'Vertices',p3');

u1=linspace(0,pi-atan(2*d3/w),16);
u2=linspace(pi-atan(2*d3/w),pi,8);
u3=linspace(pi,pi+atan(2*d3/w),8);
u4=linspace(pi+atan(2*d3/w),2*pi,16);
%
t=linspace(-pi,pi,n);
x1=-d1/2*cos(t);
y1=d1/2*sin(t);

x4=[(d1/2+d4)+d3 x1+d3 (d1/2+d4)*cos(u1)+d3 (d2/2+d4)*cos(u2)  fliplr(x2) (d2/2+d4)*cos(u3) (d1/2+d4)*cos(u4)+d3 x1+d3 (d1/2+d4)+d3];
y4=[w/2 y1+w/2 (d1/2+d4)*sin(u1)+w/2  (d2/2+d4)*sin(u2) fliplr(y2) (d2/2+d4)*sin(u3)  (d1/2+d4)*sin(u4)-w/2 y1-w/2 -w/2];
h1=(t2/2-d4)*ones(1,length(x4))+hp;
h2=(t2/2-d4-t1)*ones(1,length(x4))+hp;

p4=R*[x4 x4;y4 y4;h1+t3 h2+t3];
p4=[p4(1,:)+O(1);p4(2,:)+O(2);p4(3,:)+O(3)];
set(h.h4,'Vertices',p4');

x5=[ (d1/2+d4)*cos(u1)+d3 (d2/2+d4)*cos(u2)   (d2/2+d4)*cos(u3) (d1/2+d4)*cos(u4)+d3  ];
y5=[ (d1/2+d4)*sin(u1)+w/2 (d2/2+d4)*sin(u2)  (d2/2+d4)*sin(u3) (d1/2+d4)*sin(u4)-w/2 ];

h1=(t2/2-d4)*ones(1,48)+hp;
h2=(t2/2-d4-t1)*ones(1,48)+hp;

p5=R*[x5 x5;y5 y5;h1+t3 h2+t3];
p5=[p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

set(h.h5,'Vertices',p5');

h1=-(t2/2-d4)*ones(1,length(x4))+hp;
h2=-(t2/2-d4-t1)*ones(1,length(x4))+hp;

p4=R*[x4 x4;y4 y4;h1+t3 h2+t3];
p4=[p4(1,:)+O(1);p4(2,:)+O(2);p4(3,:)+O(3)];
set(h.h6,'Vertices',p4');

h1=-(t2/2-d4)*ones(1,48)+hp;
h2=-(t2/2-d4-t1)*ones(1,48)+hp;

p5=R*[x5 x5;y5 y5;h1+t3 h2+t3];
p5=[p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

set(h.h7,'Vertices',p5');
end
function updatefrontfork(h,O,R)
l=0.6;%fork length
w=0.2;% width
d1=0.04;% inner diameter telescopic fork suspension tube
n=8;
t=linspace(-pi,pi,n+1);
t=t(1:end-1);
x1=d1/2*cos(t);
y1=d1/2*sin(t);
h1=-d1*ones(1,n);
h2=(l-d1)*ones(1,n);

p=R*[x1 x1;y1+w/2 y1+w/2;h1 h2];
p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h1,'Vertices',p');
set(h.h2,'Vertices',p');
p=R*[x1 x1;y1-w/2 y1-w/2;h1 h2];
p=[p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

set(h.h3,'Vertices',p');
set(h.h4,'Vertices',p');
end
function h=initializecom
f = [1 2 3;2 4 5;2 5 3;3 5 6;4 7 8;4 8 5;5 8 9;5 9 6;6 9 10;7 11 12;7 12 8;8 12 13;8 13 9;9 13 14;9 14 10;10 14 15];
f1=[f;f+15;f+30;f+45];
h.h1=patch('Vertices',zeros(60,3),'Faces',f1,'FaceColor',[0 0 0],'EdgeAlpha',0,'FaceLighting','phong','DiffuseStrength',0.2,'FaceAlpha',0.8);
h.h2=patch('Vertices',zeros(60,3),'Faces',f1,'FaceColor',[1 1 0],'EdgeAlpha',0,'FaceLighting','phong','DiffuseStrength',0.2,'FaceAlpha',0.8);
end
function h=initializewheel
r2=0;r1=0;R=eye(3);O=[0 0 0];
n=64;
t=linspace(-pi,pi,n);
[u v] = meshgrid(t,linspace(-pi/2,pi/2,16));
h.h1    =surface((r2+r1*cos(v)).*cos(u),r1*sin(v),(r2+r1*cos(v)).*sin(u));
set(h.h1,'EdgeAlpha',0,'FaceLighting','gouraud','FaceColor',[0.01 0.01 0.01],'AmbientStrength',1,'DiffuseStrength',1);

% rim
f  =reshape([1:n;[(n+2):(2*n) n+1]],2*n,1);
f1 =[f circshift(f,-1) circshift(f,-2)];

x1 = [r2*sin(t) (r2-.02)*sin(t-pi/n) (r2-.02)*sin(t-2*pi/n) r2* sin(t-3*pi/n)];
y1 = [r1*ones(1,n) (r1-.01)*ones(1,n) -(r1-.01)*ones(1,n) -r1*ones(1,n)];
z1 = [r2*cos(t) (r2-.02)*cos(t-pi/n) (r2-.02)*cos(t-2*pi/n) r2* cos(t-3*pi/n)];

p  = R*[x1;y1;z1];
p  = [p(1,:)+O(1);p(2,:)+O(2);p(3,:)+O(3)];

h.h2 = patch('vertices',p.','faces',[f1;f1+n;f1+n*2],'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');

% spokes
d1 = .01;
x2 = (r2-.02)* sin(2*pi*[-d1 d1 1-d1 1+d1 2-d1 2+d1]/3);
z2 = (r2-.02)* cos(2*pi*[-d1 d1 1-d1 1+d1 2-d1 2+d1]/3);
d2 = .5;
x3 = 0.03* sin(2*pi*[-d2 d2 1-d2 1+d2 2-d2 2+d2]/3);
z3 = 0.03* cos(2*pi*[-d2 d2 1-d2 1+d2 2-d2 2+d2]/3);
y2 = [.015*ones(1,6) .04*ones(1,6)];

p1 = R*[[x2 x3 x2 x3];[y2 -y2];[z2 z3 z2 z3]];
p1 = [p1(1,:)+O(1);p1(2,:)+O(2);p1(3,:)+O(3)];
f3 = [1 2 8 7;3 4 10 9;5 6 12 11;13 14 20 19;15 16 22 21;17 18 24 23;1 13 19 7;2 14 20 8;3 15 21 9;4 16 22 10;5 17 23 11;6 18 24 12 ];
h.h3=patch('vertices',p1','faces',f3,'FaceColor',[0.9 1 0.1],'EdgeAlpha',.3,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');

% hub
x5 = .04*[sin(t-pi/n) sin(t-2*pi/n)];
y5 = .09*[ones(1,n) -ones(1,n)];
z5 = .04*[cos(t-pi/n) cos(t-2*pi/n)];
p5 = R*[x5;y5;z5];
p5 = [p5(1,:)+O(1);p5(2,:)+O(2);p5(3,:)+O(3)];

h.h4=patch('vertices',p5.','faces',f1,'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
h.h5=patch('vertices',p5.','faces',[1:n;n+1:2*n],'FaceColor',[0.9 1 0.1],'EdgeAlpha',0,...
    'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
end
function h=initializeswingarm
f1 = [1:14; 15:28];
f2 = [1 2 16 15;2 3 17 16;3 4 18 17;4 5 19 18;5 6 20 19;6 7 21 20; ...
    7 8 22 21;8 9 23 22; 9 10 24 23;10 11 25 24;11 12 26 25;12 13 27 26;13 14 28 27;14 1 15 28];
h.h1=patch('Vertices',zeros(28,3),'Faces',f1,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
h.h2=patch('Vertices',zeros(28,3),'Faces',f2,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2,'BackFaceLighting','lit');
end
function h=initializesteeringhead

n=32;

faces_matrix1 = [1:n;n+1:2*n];
faces_matrix2=[];
for i=1:n-1
    faces_matrix2(i,:) = [i i+1 n+i+1 n+i];
end
faces_matrix3 = [1:146;146+1:2*146];
faces_matrix4=[];
for i=1:47
    faces_matrix4(i,:) = [i i+1 47+i+2 47+i+1];
end
faces_matrix4(48,:) = [48 1 49 96];
h.h1=patch('Vertices',zeros( 64,3),'Faces',faces_matrix2,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h2=patch('Vertices',zeros( 64,3),'Faces',faces_matrix2,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h3=patch('Vertices',zeros( 64,3),'Faces',faces_matrix2,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h4=patch('Vertices',zeros(292,3),'Faces',faces_matrix3,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h5=patch('Vertices',zeros( 96,3),'Faces',faces_matrix4,'FaceColor',[0.5 0.6  0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h6=patch('Vertices',zeros(292,3),'Faces',faces_matrix3,'FaceColor',[0.4 0.45 0.4],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h7=patch('Vertices',zeros( 96,3),'Faces',faces_matrix4,'FaceColor',[0.5 0.6  0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
end
function h=initializefrontfork
n=8;
faces_matrix1 = [1:n;n+1:2*n];
faces_matrix2=zeros(7,4);
for i=1:n-1
    faces_matrix2(i,:) = [i i+1 n+i+1 n+i];
end
faces_matrix2(n,:) = [n 1 n+1 2*n];
h.h1=patch('Vertices',zeros(16,3),'Faces',faces_matrix1,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h2=patch('Vertices',zeros(16,3),'Faces',faces_matrix2,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h3=patch('Vertices',zeros(16,3),'Faces',faces_matrix1,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
h.h4=patch('Vertices',zeros(16,3),'Faces',faces_matrix2,'FaceColor',[0.5 0.6 0.6],'EdgeAlpha',0,'FaceLighting','gouraud','DiffuseStrength',0.2)
end
function plotgroundsurface
% load groundsurface z y x
    [x,y]=meshgrid(linspace(-2,2,256));
    z=0.0001*rand(size(x));
%     save groundsurface x y z;
h=surf(x,y,z);
set(h,'EdgeAlpha',0,'FaceLighting','gouraud','FaceColor',[0.06 0.05 0.05],...
    'AmbientStrength',5,'DiffuseStrength',5,'SpecularStrength',0.1,...
    'SpecularExponent',1)
end
function fh = initialize_plot
% initialize_plot returns a figure handle structure

%  Create and then hide the figure as it is being constructed.
fh.f = figure(112358);clf;

set(fh.f,'Visible','off','Position',[360,500,1080,720]);
set(fh.f,'Name','motorcycle animation')
movegui(fh.f,'center')
view([45 30])
axis;
fh.ax1=gca;
grid on
set(fh.ax1,'DataAspectRatio',[1 1 1],'Units','pixels','position',[380 100 700 700])



rotate3d on



plotgroundsurface

% there are 16 reference frames
v = [1 0 0;0 0 0;0 1 0;0 0 0;0 0 1;0 0 0];
f = [1 2 3 4 5 6];
c = [0 0 1;0 0 1;0 .5 0;0 .5 0;1 0 0;1 0 0];
fh.r01=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r02=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r03=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r04=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r05=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r06=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r07=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r08=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r09=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r10=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r11=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r12=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r13=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r14=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r15=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);
fh.r16=patch('Faces',f,'Vertices',v,'FaceVertexCData',c,'FaceColor','none','EdgeColor','flat','LineWidth',2);

% initialize coms
fh.c1 = initializecom;
fh.c2 = initializecom;
fh.c3 = initializecom;
fh.c4 = initializecom;
fh.c5 = initializecom;
fh.c6 = initializecom;


% initialize wheels
fh.fwl = initializewheel;
fh.rwl = initializewheel;

% initialize bodies
fh.swa = initializeswingarm;
fh.sth = initializesteeringhead;
fh.ffo = initializefrontfork;

assignin('base','fh',fh)
light('Position',[1 0 0],'Style','infinite');
light('Position',[0 1 0],'Style','infinite');
light('Position',[0 0 1],'Style','infinite');
end
function fh = initialize_force_elements

        h_ax1=axes;polar(h_ax1,[0 1],[0 1]);
        h_ax2=axes;
        l1=compass(h_ax1,[1000 0],[0 1]);
        l2=compass(h_ax2,[1000 0],[0 1]);
        set(l1(1),'visible','off');
        set(l2(1),'visible','off');
        set(l1,'linewidth',4);
        set(l2,'linewidth',4);
        set(h_ax1,'position',[0.5 0.75 0.5 0.2])
        set(h_ax2,'position',[0.67 0.75 0.5 0.2])
        set(get(h_ax2,'Title'),'String','front wheel slip')
        set(get(h_ax1,'Title'),'String','rear wheel slip')
        set(h_ax1,'XTickLabel','one')
        
        
        h_ax3=axes;
        l3=bar(h_ax3,100)
        set(h_ax3,'position',[0.67 0.75 0.01 0.2],'ytick',[])
        set(get(h_ax3,'Ylabel'),'String','front wheel normal force')
        set(get(h_ax3,'Title'),'String','1e3')
        ylim([0 10000])

        h_ax4=axes;
        l4=bar(h_ax4,100)
        set(h_ax4,'position',[0.84 0.75 0.01 0.2],'ytick',[])
        set(get(h_ax4,'Ylabel'),'String','rear wheel normal force')
        set(get(h_ax4,'Title'),'String','1e3')
        ylim([0 10000])

fh.h_ax1=h_ax1;
fh.h_ax2=h_ax2;

fh.l3=l3;
fh.l4=l4;

end