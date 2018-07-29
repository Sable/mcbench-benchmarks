function roboticsc(varargin)
	global tts ss5 T2 f kkx kky kkz
	figure('un','n','num','off','nam','Robot','color','w','pos',[.1 .1 .8 .8])
	
	ma = axes('pos',[.15 .15 1 1]);
	axis off
	view(3)
	rotate3d
	grid on
	hold on
	
	axes('pos',[.01 .91 .45 .05])
	
	text('position',[0.01,.5],'string','\alpha_i_-_1   a_i_-_1    d_i      \theta_i              q_i','fontsize',15,'fontangle','i')
	axis off
	axes(ma)
	e1=uicontrol('sty','e','un','n','pos',[.01 .5 .225 .4],'backgroundcolor','w','max',2,'ho','l','fonts',10,'fontn','courier');
	e5=uicontrol('sty','e','un','n','pos',[.25 .5 .05 .4],'backgroundcolor','w','max',2,'fonts',10,'fontn','courier');
	
	uicontrol('sty','pu','callback',@pp,'string','Go','backgroundcolor','w')
	lxf=uicontrol('sty','li','string',{'Null';'Planar';'Puma 560';'Complete';'Piper''s 1st';'Yasukawa L-3';'Stanford';'IRB1400';'DIESTRO';'DLR'},'callback',@dl,'un','n','pos',[.7 .05 .2 .1],'backgroundcolor','w');
	
	function T=trans(al,a,d,t)
		
		T=[cos(t) -sin(t) 0 a;
			sin(t)*cos(al) cos(t)*cos(al) -sin(al) -sin(al)*d;
			sin(t)*sin(al) cos(t)*sin(al) cos(al) cos(al)*d;
			0 0 0 1];
		
	end
	
	function dl(varargin)
		set(dumd,'string','0')
		switch get(lxf,'value')
			case 1
				set([e5,e1],'string','','sty','e')
			case 2
				set(e1,'string',strvcat('0 2 0 0','0 2 0 0','0 2 0 0')) %#ok<*VCAT>
				set(e5,'string',['t';'d';'t'])
			case 3
				set(e1,'sty','e')
				set(e1,'str',strvcat('0 0 0 0','-pi/2 0 0 0','0 3 1 0','-pi/2 1 2 0','pi/2 0 0 0','-pi/2 0 0 0'))
				set(e5,'string',['t';'t';'t';'t';'t';'t'])
			case 4
				set(e1,'sty','e')
				set(e1,'str',strvcat('0 0 3 0','-pi/2 0 3 pi/2','pi/2 0 3 0'))
				set(e5,'string',['d';'d';'d'])
			case 5
				set(e1,'sty','e')
				set(e5,'string',['t';'t';'t';'t';'t';'t'])
				set(e1,'str',strvcat('0 0 0 0','pi/2 0 2 0','-pi/2 2 2 0','pi/2 2 2 0','-pi/2 0 0 0','pi/2 0 0 0'))
			case 6
				set(e1,'sty','e')
				set(e5,'string',['t';'t';'t';'t';'t'])
				set(e1,'str',strvcat('0 0 0 0','-pi/2 0 0 0','0 3 0 0','0 4 0 0','pi/2 0 0 0'))
			case 7
				set(e1,'sty','e')
				set(e5,'string',['t';'t';'d';'t';'t';'t'])
				set(e1,'str',strvcat('0 0 0 0','-pi/2 0 4 0','pi/2 0 3 0','0 0 0 0','-pi/2 0 0 0',...
					'pi/2 0 2 0'))
			case 8
				set(e1,'sty','e')
				set(e5,'string',['t';'t';'t';'t';'t';'d'])
				set(e1,'str',num2str([      0           0        4.75           0
					1.5708         1.5           0      1.5708
					0           6           0           0
					1.5708         1.2         7.2           0
					-1.5708           0           0           0
					1.5708           0        0.85           0]));
			case 9
				sdgsdg=[-1.5708           5           5     0.25533
					1.5708           5           5     0.25533
					-1.5708           5           5      1.2766
					1.5708           5           5      1.2766
					-1.5708           5           5      1.2766
					1.5708           5           5      1.2766];
				sdgsdg(:,end) = zeros(6,1);
				set(e1,'sty','e','str',num2str(sdgsdg))
				set(e5,'string',['t';'t';'t';'t';'t';'t'])
				
			case 10
				sdgsdg=[       1.5708            0            0            0
					1.5708            0            0            0
					1.5708            0            3            0
					1.5708            0            0            0
					1.5708            0            3            0
					1.5708            0            0            0
					1.5708            0            4            0
					];
				sdgsdg(:,end) = rand(7,1);
				set(e1,'sty','e','str',num2str(sdgsdg))
				set(e5,'string',['t';'t';'t';'t';'t';'t';'t'])
				
				
		end
	end
	
	function pp(varargin)
		
		cla
		plot3(0,0,0,'r*')
		set(dumd,'string','0');
		
		DH=str2num(get(e1,'string'));
		
		al=DH(:,1);
		a=DH(:,2);
		d=DH(:,3);
		t=DH(:,4);
		
		w=get(e5,'string');
		delete(findobj('type','uicontrol','style','slider'));
		delete(findobj('type','uicontrol','style','text'));
		tts=uicontrol('sty','te','backgroundcolor','w','un','n','pos',[.7 0 .2 .05],'string','','fontsize',15);
		
		for k=1:length(a)
			if strcmp(w(k),'t')
				eval(['uicontrol(''style'',''slider'',''units'',''norm'',''pos'',[.1 ',num2str(k*.1/2),' .1 .05 ],''callback'',@slm,''min'',-2*pi-.1,''max'',2*pi+.1,''value'',',...
					num2str(t(k)),')'])
				eval(['uicontrol(''style'',''text'',''fontsize'',14,''fontname'',''calibri'',''fontangle'',''italic'',''units'',''norm'',''backgroundcolor'',''w'',''pos'',[.2 ',num2str(k*.1/2),' .05 .05 ],''string'',',...
					'[''t',num2str(k),'''])'])
			else
				eval(['uicontrol(''style'',''slider'',''units'',''norm'',''pos'',[.1 ',num2str(k*.1/2),' .1 .05 ],''callback'',@slm,''min'',-50,''max'',50,''value'',',...
					num2str(d(k)),',''sliderstep'',[.001 .05])'])
				eval(['uicontrol(''style'',''text'',''fontname'',''calibri'',''fontsize'',14,''fontangle'',''italic'',''units'',''norm'',''backgroundcolor'',''w'',''pos'',[.2 ',num2str(k*.1/2),' .05 .05 ],''string'',',...
					'[''d',num2str(k),'''])'])
			end
		end
		
		T=cell(length(a),1);
		f=1;
		for k=1:length(a)
			T{k}=trans(al(k),a(k),d(k),t(k));
			f=f*T{k};
		end
		set(e1,'style','li')
		
		delete(findobj('type','uicontrol','style','pus','string','Set'));
		delete(findobj('type','uicontrol','style','edit','pos',[.025 .4 .2 .025]));
		ep=uicontrol('sty','ed','un','n','pos',[.025 .4 .2 .025],'backgroundcolor','w');
		uicontrol('sty','pu','un','n','pos',[.025 .425 .05 .025],'string','Set','callback',@chl,'backgroundcolor','w');
		set(e1,'value',1,'callback',@leq)
		
		ss5=abs(sum([d;a]));
		slm(ss5)
		leq
		
		function leq(varargin)
			ss=get(e1,'string');
			vv=get(e1,'value');
			sv=ss(vv,:);
			set(ep,'string',sv)
		end
		
		function chl(varargin)
			set(dumd,'string','0');
			val=str2num(get(ep,'string'));
			ss=get(e1,'string');
			vv=get(e1,'value');
			
			ss=str2num(ss);
			ss(vv,:)=val;
			set(e1,'string',num2str(ss))
			pp;
		end
	end
	
	function slm(varargin)
		axis on
		set(e1,'value',1)
		
		ll=flipud(findobj('type','uicontrol','style','slider'));
		cla;
		hold on
		plot3(0,0,0,'r*')
		
		DH=(str2num(get(e1,'string'))); %#ok<*ST2NM>
		
		al=DH(:,1);
		a=DH(:,2);
		d=DH(:,3);
		t=DH(:,4);
		
		w=get(e5,'string');
		n=length(a);
		
		for k=1:length(a)
			if strcmp(w(k),'t')
				t(k)=get(ll(k),'value');
			else
				d(k)=get(ll(k),'value');
			end
		end
		
		FFF=num2str([al,a,d,t],5);
		set(e1,'string',FFF)
		T=cell(length(a),1);
		f=1;
		for k=1:length(a)
			T{k}=trans(al(k),a(k),d(k),t(k));
		end
		
		T2=cell(n,1);
		T2{1}=T{1};
		for k=2:n
			T2{k}=T2{k-1}*T{k};
		end
		
		pv=plotorg([eye(4),[0;0;0;0]]);
		for k=1:n
			if w(k)=='d'
				T2{k}=T2{k}+[0,0,0,0;0,0,0,0;0,0,0,0;1,0,0,0];
			else
				T2{k}=T2{k}.*(1-[0,0,0,0;0,0,0,0;0,0,0,0;1,0,0,0]);
			end
			if k<n && abs(a(k+1))>1e-10 && abs(d(k))>1e-10
				pv=plotorg([double(T2{k}),[pv;k]],'t',[a(k+1),d(k),al(k)]);
			elseif k<n && abs(a(k+1))>1e-10
				pv=plotorg([double(T2{k}),[pv;k]],'a',a(k+1));
			elseif abs(d(k))>1e-10
				pv=plotorg([double(T2{k}),[pv;k]],'d',[d(k),al(k)]);
			else
				pv=plotorg([double(T2{k}),[pv;k]]);
			end
		end
		
		% 		axis([-ss5-2 ss5+2 -ss5-2 ss5+2 -ss5-2 ss5+2])
		PPPPP=T2{end};
		set(tts,'string',sprintf('%2.2f ',transpose(PPPPP(1:3,4))));
		
		dddd=T2{end};
		disp((dddd))
		
		if strcmp(get(dumd,'string'),'0')
			JL = zeros(length(w),2);
			for klk = 1:length(w)
				
				if strcmp(w(klk),'t')
					JL(klk,:) = [0,2*pi];
				else
					JL(klk,:) = [-ss5,ss5];
				end
				
			end
			
			[kkx,kky,kkz] = mc(DH,w,JL);
			set(dumd,'string','1');
		end
		axis([min(kkx),max(kkx),min(kky),max(kkx),min(kkz),max(kkz)]);
		axis square
		function [pv,g]=plotorg(T,varargin)
			
			nuk = T(end);
			w=get(e5,'string');
			
			res=10;
			R=T(1:3,1:3);
			
			g2=tr2eul(R);
			g=struct;
			g.a=g2(1);
			g.b=g2(2);
			g.g=g2(3);
			
			P=T(1:3,4);
			
			pp=plot3(P(1),P(2),P(3),'k.');
			set(pp,'markersize',20)
			
			[A,B,C]=sphere(res);
			pp1=surf(A.*.5+P(1),B.*.5+P(2),C.*.5+P(3));
			
			if T(4,1)==1
				set(pp1,'edgecolor','none','facealpha',.5,'facecolor','y')
			else
				set(pp1,'edgecolor','none','facealpha',.5,'facecolor','c')
			end
			
			lz=line([P(1) P(1)],[P(2) P(2)],[ P(3) P(3)+2.5]);
			set(lz,'color','g','linewidth',1.5,'linestyle','-.')
			
			ly=line([P(1) P(1)],[P(2) P(2)+2.5],[ P(3) P(3)]);
			set(ly,'color','r','linewidth',1.5,'linestyle','-.')
			lx=line([P(1) P(1)+2.5],[P(2) P(2)],[P(3) P(3)]);
			set(lx,'color','b','linewidth',1.5,'linestyle','-.')
			
			t1=text('string',['x_',num2str(T(4,5))],'position',[P(1)+1.25 P(2) P(3)+.05]);
			t3=text('string',['y_',num2str(T(4,5))],'position',[P(1) P(2)+1.25 P(3)+.05]);
			t2=text('string',['z_',num2str(T(4,5))],'position',[P(1)+.05 P(2) P(3)+1.25]);
			
			pv=T(1:3,5);
			if T(4,5)==0
				set([ly,lx,lz],'color','k','linestyle','-','linewidth',1)
				delete(pp1)
				return
			end
			
			ppj=[];
			if numel(varargin)
				if strcmp(varargin{1},'a')
					[A,B,C]=cylinder(.5,res);
					mor=surf(A+P(1),B+P(2),C.*varargin{2}+P(3));
					set(mor,'facecolor',[.4 .8 .4])
					rotate(mor,[0,1,0],90,P)
					
				elseif strcmp(varargin{1},'d')
					ll=varargin{2};
					[A,B,C]=cylinder(.5,res);
					mor=surf(A+P(1),B+P(2),C.*ll(1)+P(3));
					[A,B,C]=sphere(res);
					ppj1=surf(A.*.5+P(1),B.*.5+P(2),C.*.5+P(3)-ll(1));
					if strcmp(w(T(4,5)),'d')
						set(mor,'facecolor',[.14 .18 .14])
						set(ppj1,'facecolor',[.4 .8 .4],'facealpha',.5,'facecolor','y')
					else
						set(mor,'facecolor',[.4 .8 .4])
						set(ppj1,'facecolor',[.4 .8 .4],'facealpha',.5,'facecolor','c')
					end
					rotate(mor,[0,1,0],180,P)
					ppj=[ppj,ppj1];
				else
					ll=varargin{2};
					[A,B,C]=cylinder(.5,res);
					mor1=surf(A+P(1),B+P(2),C.*ll(1)+P(3));
					set(mor1,'facecolor',[.4 .8 .4])
					rotate(mor1,[0,1,0],90,P)
					
					[A,B,C]=cylinder(.5,res);
					mor=surf(A+P(1),B+P(2),C.*ll(2)+P(3));
					[A,B,C]=sphere(res);
					ppj2=surf(A.*.5+P(1),B.*.5+P(2),C.*.5+P(3)-ll(2));
					
					if strcmp(w(T(4,5)),'d')
						set(mor,'facecolor',[.14 .18 .14])
						set(ppj2,'edgecolor','none','facecolor','y')
					else
						set(mor,'facecolor',[.4 .8 .4])
						set(ppj2,'edgecolor','none','facecolor','c')
					end
					rotate(mor,[0,1,0],180,P)
					
					mor=[mor,mor1];
					ppj=[ppj,ppj2];
					
				end
			else
				mor=[];
			end
			
			set(findobj('type','surface'),'facealpha',.5,'edgecolor','k','edgealpha',.25)
			set(findobj(gca,'type','text'),'fontsize',8,'fontweight','b')
			set(findobj('type','surface','facecolor',[.4 .8 .4]),'facecolor',[.6 .7 .5])
			
			T12=[t1 t2 t3];
			
			if nuk == length(w)
				
				x=P(1);
				y=P(2);
				z=P(3);
				
				NLS1=line([x,x+1,x+2],[y,y-.25,y-.15],[z,z,z]);
				NLS2=line([x,x+1,x+2],[y,y+.25,y+.15],[z,z,z]);
				
				set([NLS1,NLS2],'color','k','linewidth',3)
				set([lx,ly,lz],'linestyle','-','linewidth',2)
				lx=[lx,NLS1,NLS2];
				
			end
			
			rotate([lx,ly,lz,mor,T12,pp1,ppj],[0,0,1],g.a*180/pi,P');%+[max(max(get(mor,'xdata'))),max(max(get(mor,'ydata'))),max(max(get(mor,'zdata')))])
			
			pxx=get(ly,'xdata');
			pyy=get(ly,'ydata');
			pzz=get(ly,'zdata');
			
			rotate([lx,ly,lz,mor,T12,pp1,ppj],[pxx(2)-pxx(1),pyy(2)-pyy(1),pzz(2)-pzz(1)],g.b*180/pi,P');%+[max(max(get(mor,'xdata'))),max(max(get(mor,'ydata'))),max(max(get(mor,'zdata')))])
			
			pxx=get(lz,'xdata');
			pyy=get(lz,'ydata');
			pzz=get(lz,'zdata');
			
			rotate([lx,ly,lz,mor,T12,pp1,ppj],[pxx(2)-pxx(1),pyy(2)-pyy(1),pzz(2)-pzz(1)],g.g*180/pi,P');%+[max(max(get(mor,'xdata'))),max(max(get(mor,'ydata'))),max(max(get(mor,'zdata')))])
			
			% 			axis equal
			
		end
		
	end
	dumd = uicontrol('visible','off','string','0');
	function [xx,yy,zz] = mc(DH,w,JL)
		Xn=[0;0;0;1];
		ns=1000;
		n=length(w);
		xx=zeros(1,ns);
		yy=zeros(1,ns);
		zz=zeros(1,ns);
		JR=JL(:,2)-JL(:,1);
		
		cc=0;
		for index=1:ns
			fkDH=DH;
			for kn=1:n
				if w(kn)=='d'
					fkDH(kn,3)=JL(kn,1)+rand*JR(kn);
				else
					fkDH(kn,4)=JL(kn,1)+rand*JR(kn);
				end
			end
			X0=FK(fkDH,w,0,n,0)*Xn;
			
			cc=cc+1;
			xx(cc)=X0(1);
			yy(cc)=X0(2);
			zz(cc)=X0(3);
			
		end
	end
	
	function euler = tr2eul(m) % from downloaded robotics toolbox
		
		euler = zeros(1,3);
		euler(1) = atan2(m(2,3), m(1,3));
		sp = sin(euler(1));
		cp = cos(euler(1));
		euler(2) = atan2(cp*m(1,3) + sp*m(2,3), m(3,3));
		euler(3) = atan2(-sp * m(1,1) + cp * m(2,1), -sp*m(1,2) + cp*m(2,2));
	end
	
end