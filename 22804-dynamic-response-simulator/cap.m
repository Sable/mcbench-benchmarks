function cap()

%{
Dynamic Responce Simulator

To launch, simply type cap in the MATLAB command window.
Alternatively, you can choose Debug -> Run from this editor window,
or press F5.

Works only on MATLAB 7.4 (R2007a) and above.

Version 1.0 12.12.2008
Version 1.05 21.12.2008 Added amplitude snap, number of systems button
%}

global tc1 tc2 tc3 cover pid pt OP Y2 camp f1 f2 y1 y2 x2 ydr cp LOAD1 hh el1 etl1 el2 etl2 dtf5 pbn ts2 tq1 pbn2 crr aii op1 op2 op3 op4 nsZ
figure('units','normalized','position',[.3 .2 .6 .6],'color','w','numbertitle','off','menubar','none','name','Dynamic Response Simulator')
dumdum=uicontrol('style','text','visible','off','string','1');
op1=uicontrol('style','text','visible','off','string','1');
op3=uicontrol('style','text','visible','off','string','1');
op2=uicontrol('style','text','visible','off','string','1');
op4=uicontrol('style','text','visible','off','string','0');
op5=uicontrol('style','text','visible','off','string','1');
crr=uicontrol('style','text','visible','off','string','0');
aii=uicontrol('style','text','visible','off','string','');
uver=uicontrol('style','text','visible','off','string','0');
uverY=uicontrol('style','text','visible','off','string','');
uicontrol('style','text','units','normalized','position',[.05*.75 .9 .175*.75 .025],'string','Amplitudes','backgroundcolor','w')
TT=uicontrol('style','edit','units','normalized','position',[.11*.75 .85 .05*.75 .04],'string','','backgroundcolor','w','fontsize',7);
nsZ=uicontrol('style','togglebutton','units','normalized','position',[.35 .565 .1 .05],'string','Multiple Systems','backgroundcolor','w',...
	'fontweight','b','callback',@cht);

	function cht(varargin)
		if get(nsZ,'value')
			set(nsZ,'string','One System')
			set(findobj('string','Time Constants'),'string','Time Constant');
			set(findobj('string','Sensitivities'),'string','Sensitivity');
			if get(hr,'selectedobject')~=hb1
				set(S,'max',1,'position',[.515*.75 .835 .07*.75 .1],'fontsize',22,'string','');
				set(TC,'max',1,'position',[.41*.75 .835 .07*.75 .1],'fontsize',22,'string','');
			end
		else
			set(nsZ,'string','Multiple Systems')			
			set(findobj('string','Time Constant'),'string','Time Constants');
			set(findobj('string','Sensitivity'),'string','Sensitivities');
			if get(hr,'selectedobject')~=hb1
				set(S,'max',2,'position',[.515*.75 .635 .07*.75 .3],'fontsize',7,'string','');
				set(TC,'max',2,'position',[.41*.75 .635 .07*.75 .3],'fontsize',7,'string','');
			end
		end
	end

uicontrol('style','text','units','normalized','position',[.075 .525 .275 .025],'fontname','arial','string','s: Step     r: Ramp     p: Parabolic     n: Sinosoidal','fontweight','b','backgroundcolor','w')

uicontrol('style','text','units','normalized','position',[.75*.2 .9 .175*.75 .025],'string','Constant Shift','backgroundcolor','w')
RT=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.26 .85 .05*.75 .04],'string','','backgroundcolor','w');

uicontrol('style','text','units','normalized','position',[.75*0 .9 .075*.75 .025],'string','Mode','backgroundcolor','w')
hr=uibuttongroup('Units','normalized',...
'Position',[.75*0.015 .67 .05*.75 .225],'SelectionChangeFcn',@grv);
hb3=uicontrol('Style','Radiobutton','String','3','Units','normalized',...
'Position',[0 0 1 1/3],'Parent',hr,'backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0]);
hb2=uicontrol('Style','Radiobutton','String','2','Units','normalized',...
'Position',[0 1/3 1 1/3],'Parent',hr,'backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0]);
hb1=uicontrol('Style','Radiobutton','String','1','Units','normalized',...
'Position',[0 2/3 1 1/3],'Parent',hr,'backgroundcolor',[1 1 1],'foregroundcolor',[0 0 0]);
set(hr,'SelectedObject',hb1)

m1=uimenu('Label','File');
m2=uimenu('Label','More');
uimenu(m1,'Label','Save Model','Callback',@savv);
uimenu(m1,'Label','Load Model','Callback',@ladd,'Separator','on');
uimenu(m1,'Label','Preferences','Callback',@svd,'Separator','on');
uimenu(m1,'Label','Exit','Callback',@goon2,'Separator','on');

	function savv(varargin)
		figure('units','normalized','position',[0.1 .6 .2 .2],'color','w','numbertitle','off','menubar','none','name','Save')
		uicontrol('style','text','units','normalized','position',[.05 .7 .9 .2],'string','Save Model As','backgroundcolor','w',...
			'fontsize',15,'fontweight','b','fontname','arial','horizontalalignment','left')
				se=uicontrol('style','edit','units','normalized','position',[.05 .525 .7 .2],'string','','backgroundcolor','w',...
			'fontsize',15,'fontweight','b','fontname','arial','horizontalalignment','left');
				uicontrol('style','pushbutton','units','normalized','position',[.1 .25 .5 .2],'string','Save','backgroundcolor','w',...
			'fontsize',15,'fontweight','b','fontname','arial','horizontalalignment','left','callback',@savvy)
		
		function savvy(varargin)			
			ns=get(se,'string');
			close(gcf)
			sob=get(hr,'selectedobject');%#ok
			shift=(get(RT,'string'));%#ok
			tau=(get(TC,'string'));%#ok
			A=(get(TT,'string'));%#ok
			K=(get(S,'string'));%#ok
			types=get(SR,'string');%#ok
			durations=(get(TSR,'string'));%#ok
			save(['Models\',ns,'.mat'],'shift','tau' ,'A' ,'K' ,'types', 'durations', 'sob')
		end
		
	end

	function ladd(varargin)
		figure('units','normalized','position',[0.1 .6 .2 .2],'color','w','numbertitle','off','menubar','none','name','Load')
		uicontrol('style','text','units','normalized','position',[.05 .7 .9 .2],'string','Load the Model by the Name of','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left')
				se=uicontrol('style','edit','units','normalized','position',[.05 .525 .7 .2],'string','','backgroundcolor','w',...
			'fontsize',15,'fontweight','b','fontname','arial','horizontalalignment','left');
				uicontrol('style','pushbutton','units','normalized','position',[.1 .25 .5 .2],'string','Load','backgroundcolor','w',...
			'fontsize',15,'fontweight','b','fontname','arial','horizontalalignment','left','callback',@laddy)
		
		function laddy(varargin)
			ns=get(se,'string');
			close(gcf)
			load(['Models\',ns,'.mat'],'shift','tau' ,'A' ,'K' ,'types', 'durations', 'sob')
			switch round(sob)
				case 15
					set(hr,'selectedobject',hb1);
				otherwise
					set(hr,'selectedobject',hb3);
			end
			grv			
			set(RT,'string',shift);
			set(TC,'string',tau);
			set(TT,'string',A);
			(set(S,'string',K));
			set(SR,'string',types);
			set(TSR,'string',durations);
		end
		
	end

	function svd(varargin)
		tfg3=figure('units','normalized','position',[0.1 .5 .25 .3],'color','w','numbertitle','off','menubar','none','name','Preferences');
		ft1=uicontrol('style','checkbox','units','normalized','position',[.05 .8 .6 .2],'string','Enable Sounds','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left','value',str2double(get(op1,'string')));	
		ft3=uicontrol('style','checkbox','units','normalized','position',[.05 .35 .9 .2],'string','Enable Ramp Snap (Mode 3)','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left','value',str2double(get(op3,'string')));
		uicontrol('style','pushbutton','units','normalized','position',[.05 .05 .25 .15],'string','Done','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left','callback',@goddamn)
		ft2=uicontrol('style','checkbox','units','normalized','position',[.05 .65 .9 .2],'string','Enable Vertical Snap (Mode 3)','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left','value',str2double(get(op2,'string')));
		ft4=uicontrol('style','checkbox','units','normalized','position',[.05 .5 .9 .2],'string','Enable Horizontal Snap (Mode 3)','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left','value',str2double(get(op4,'string')));
		ft5=uicontrol('style','checkbox','units','normalized','position',[.05 .2 .9 .2],'string','Enable Amplitude Snap (Mode 3)','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left','value',str2double(get(op5,'string')));

		function goddamn(varargin)
			set(op1,'string',num2str(get(ft1,'value')))
			set(op2,'string',num2str(get(ft2,'value')))
			set(op3,'string',num2str(get(ft3,'value')))			
			set(op4,'string',num2str(get(ft4,'value')))						
			set(op5,'string',num2str(get(ft4,'value')))									
			close(tfg3)
		end
		
	end

uimenu(m2,'Label','Examples','Callback',@exak);
uimenu(m2,'Label','Help','Callback',@hep,'Separator','on');
uimenu(m2,'Label','About','Callback',@bot,'Separator','on');

	function hep(varargin)
		open('help.doc')
	end

	function bot(varargin)
		figure('units','normalized','position',[0.1 .7 .25 .1],'color','w','numbertitle','off','menubar','none','name','About');
		uicontrol('style','text','units','normalized','position',[.05 .25 .6 .2],'string','numandina@gmail.com','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left');		
		uicontrol('style','text','units','normalized','position',[.05 .65 .6 .2],'string','Version 1.05','backgroundcolor','w',...
			'fontsize',11,'fontweight','b','fontname','arial','horizontalalignment','left');
	end

	function exak(varargin)
		axes(a3d)
		cla
		axes(a2d)
		cla
		tq1=uicontrol('style','text','string','','units','normalized','position',[.75 .5 .25 .45],'fontname','arial','fontweight','b','horizontalalignment','left','backgroundcolor','w');
		dtf5=uicontrol('style','text','visible','off','string','1');
		ts2=uicontrol('style','text','string','','units','normalized','position',[.75 .05 .25 .45],'fontname','arial','fontweight','b','horizontalalignment','left','backgroundcolor','w','foregroundcolor','g');
		figure('units','normalized','position',[.5 .2 .4 .4],'color','w','numbertitle','off','menubar','none','name','Examples')
		axes('position',[0 0 1 1],'xlim',[0 1],'ylim',[0 1])
		set(gca,'xcolor','w','ycolor','w','zcolor','w')
		text('position',[.05,.95],'interpreter','none','fontsize',14,'fontweight','bold','string',...
			'Choose from the following examples:')
		patch([.05 .05 .85 .75],[.55 .65 .65 .55],'c','FaceVertexAlphaData',0.5,'FaceAlpha','flat','buttondownfcn',@x22)
		text('position',[.06,.6],'interpreter','tex','fontsize',14,'fontweight','bold','string',...
			'Derivation of Sinosoidal Input Response','fontangle','i','buttondownfcn',@x22)
		patch([.05 .05 .85 .75],[.7 .8 .8 .7],'c','FaceVertexAlphaData',0.5,'FaceAlpha','flat','buttondownfcn',@x1)
		text('position',[.06,.75],'interpreter','tex','fontsize',14,'fontweight','bold','string',...
			'Thermometre Example','fontangle','i','buttondownfcn',@x1)
		patch([.05 .05 .85 .75],[.4 .5 .5 .4],'c','FaceVertexAlphaData',0.5,'FaceAlpha','flat','buttondownfcn',@x3)
		text('position',[.06,.45],'interpreter','tex','fontsize',14,'fontweight','bold','string',...
			'Practical Step Function','fontangle','i','buttondownfcn',@x3)
		patch([.05 .05 .85 .75],[.1 .2 .2 .1],'c','FaceVertexAlphaData',0.5,'FaceAlpha','flat','buttondownfcn',@x5)
		text('position',[.06,.3/2],'interpreter','tex','fontsize',14,'fontweight','bold','string',...
			'Crown Pulse','fontangle','i','buttondownfcn',@x5)
		patch([.05 .05 .85 .75],[.25 .35 .35 .25],'c','FaceVertexAlphaData',0.5,'FaceAlpha','flat','buttondownfcn',@x4)
		text('position',[.06,.3],'interpreter','tex','fontsize',14,'fontweight','bold','string',...
			'Practical Impulse Function','fontangle','i','buttondownfcn',@x4)
	end

	function x1(varargin)
		close(gcf)
		cla
		b2='   A water tank has been heated to a';
		b3='temperature of 60 ºC. A mercury-in-glass';
		b4='thermometer is inserted into the water to';
		b5='measure its temperature. Assuming the';
		b6='thermometer can be approximated as a first';
		b7='order system with a time constant of 2';
		b8='seconds and that the room temperature is 23';
		b9='ºC, find the following:';
		b10='a) The temperature indicated by the';
		b10=strvcat(b10,'thermometer after:');%#ok
		c='1.0 second, ';
		d='1.5 seconds and ';
		e='2.0 seconds. ';
		f='b) The steady state error. ';		
		b=strvcat(b2,b3,b4,b5,b6,b7,b8,b9,' ',b10,c,d,e,' ',f);%#ok
		set(tq1,'string',b,'fontname','arial')
		pbn=uicontrol('style','pushbutton','visible','on','units','normalized','position',[.95 .5 .035 .035],'callback',@nexx,'backgroundcolor','w','string','Go');
	end

	function nexx(varargin)
		switch str2double(get(dtf5,'string'))
			case 1
				set(pbn,'string','Next')			
				a=['Problem is a single order';
				   'step input function with ';
				   'a continious shift       '					
					];
				set(ts2,'string',a)
				set(dtf5,'string','2')
			case 2
				set(RT,'string','23')
				set(SR,'string','s')
				set(TC,'string','2')				
				set(TT,'string','37')					
				set(S,'string','1')				
				set(TSR,'string','2.5')
				set(dtf5,'string','3')
			case 3
				go
				set(dtf5,'string','4')
			case 4
				set(el1,'string','1')
				editl
				set(dtf5,'string','5')
			case 5
				set(el1,'string','1.5')
				editl
				set(dtf5,'string','6')				
			case 6
				set(el1,'string','2')
				editl
				set(dtf5,'string','7')
				
			case 7
				set(TSR,'string','10')
				go
				a=['Steady State Error';
				   'is observed to be ';
				   'zero.             '					
					];
				set(ts2,'string',a)
				set(pbn,'visible','off')
		end
	end

 	function x22(varargin)
 		close(gcf)
		set(tq1,'fontname','courier');
		pbn2=uicontrol('style','pushbutton','visible','on','units','normalized','position',[.95 .5 .035 .035],'callback',@nexx2,'backgroundcolor','w','string','Go');
		b1='syms c K tau t s';
		set(tq1,'string',b1)
	end

	function nexx2(varargin)
				switch str2double(get(dtf5,'string'))
					case 1
						set(pbn2,'string','Next')
						b1=strvcat('p=c*sin(t)',' ',...
							'p =',...
							' ','c*sin(t)');%#ok
						set(tq1,'string',b1)
						set(dtf5,'string','2')
					case 2
						b1=strvcat('laplace(p)',' ',...
							'ans =',' ',...
							'c/(s^2+1)');%#ok
						set(tq1,'string',b1)
						set(dtf5,'string','3')
					case 3
						b1=strvcat('qs=ans*K/(1+tau*s)',' ',...
							'qs =',' ',...
							'c/(s^2+1)*K/(1+tau*s)');%#ok
						set(tq1,'string',b1)
						set(dtf5,'string','4')
					case 4
						b1=strvcat('q=ilaplace(qs)',' ',...
							'q =',' ',...
							'c*K/(1+tau^2)*(sin(t)+(exp(-t/tau)-cos(t))*tau)');	%#ok				
						set(tq1,'string',b1)
						set(pbn2,'visible','off')	
						text('position',[.05,.95],'interpreter','latex','fontsize',14,'fontweight','bold','string',...
							'$$q(s)=cK/(1+\tau^2)(sin(t)+(exp(-t/\tau)-cos(t))\tau)$$')
						ylim([0 1])					
				end
	end

	function x3(varargin)
		close(gcf)
		switch get(hr,'selectedobject')
			case hb1
				set(RT,'string','1')
				set(SR,'string','r r')
				set(TC,'string','1 1')				
				set(TT,'string','10 -10')					
				set(S,'string','1 1')				
				set(TSR,'string','1 10')				
			otherwise
				set(RT,'string','1')
				set(SR,'string',['r';'r'])
				set(TC,'string',['1';'1'])				
				set(TT,'string',['10 ';'-10'])					
				set(S,'string',['1';'1'])				
				set(TSR,'string',['1 ';'10'])				
		end
		go
	end

	function x4(varargin)
		close(gcf)
		switch get(hr,'selectedobject')
			case hb1
				set(RT,'string','1')
				set(SR,'string','s s')
				set(TC,'string','1 1')				
				set(TT,'string','10 -10')					
				set(S,'string','1 1')				
				set(TSR,'string','.5 10')				
			otherwise
				set(RT,'string','1')
				set(SR,'string',['s';'s'])
				set(TC,'string',['1';'1'])				
				set(TT,'string',['10 ';'-10'])					
				set(S,'string',['1';'1'])				
				set(TSR,'string',['1 ';'10'])				
		end
		go
	end

	function x5(varargin)
		close(gcf)
		TYPES=['s'
			'r'
			's'
			'r'
			's'
			'r'
			's'
			'r'];
		amps=num2str([
			5
			-2
			2
			2
			-2
			2
			-5
			-2]);
		durrs=num2str([1e-9
			2
			1e-9
			2
			1e-9
			2
			1e-9
			3]);
		timesc=num2str(ones(8,1));
		scz=num2str(ones(8,1));
		set(hr,'selectedobject',hb2)
		grv
		set(RT,'string','1')
		set(SR,'string',TYPES)
		set(TC,'string',timesc)
		set(TT,'string',amps)
		set(S,'string',scz)
		set(TSR,'string',durrs)		
		go
	end

	function goon2(varargin)
		close(gcf)
	end

	function editl(varargin)
		axes(a2d)
		delete(findobj('marker','*'))
		vv=str2double(get(el1,'string'));
		switch get(hr,'selectedobject')
			case hb1
				durations=str2num(get(TSR,'string'));%#ok
			otherwise
				durations=str2num(get(TSR,'string'))';%#ok
		end
		times=[0,cumsum(durations)];
		for p=1:length(times)-1
			if vv<=times(p+1)
				a=p;
				break
			end
		end
		k=inline(OP(a,:));
		set(el2,'string',num2str(k(vv),4))
		plot(vv,k(vv),'r*')		
	end

	function grv(varargin)
		axes(a2d)
		cla
		axes(a3d)
		cla
		set(gca,'zcolor','w')
		delete(findobj('style','edit'))
		delete(findobj('style','text'))
		delete(findobj('style','popupmenu'))		
		delete(findobj('style','pushbutton'))
		dumdum=uicontrol('style','text','visible','off','string','1');
		op1=uicontrol('style','text','visible','off','string','1');
		op2=uicontrol('style','text','visible','off','string','1');
		op3=uicontrol('style','text','visible','off','string','1');		
		op4=uicontrol('style','text','visible','off','string','0');				
		op5=uicontrol('style','text','visible','off','string','1');						
		nsZ=uicontrol('style','togglebutton','units','normalized','position',[.35 .565 .1 .05],'string','Multiple Systems','backgroundcolor','w',...
			'fontweight','b','callback',@cht);		
		aii=uicontrol('style','text','visible','off','string','');
		crr=uicontrol('style','text','visible','off','string','0');
		uver=uicontrol('style','text','visible','off','string','0');		
		uverY=uicontrol('style','text','visible','off','string','');
		dux=uicontrol('style','text','visible','off','string','0');
		uicontrol('style','text','units','normalized','position',[.075 .525 .275 .025],'fontname','arial','string','s: Step     r: Ramp     p: Parabolic     n: Sinosoidal','fontweight','b','backgroundcolor','w')
		LOAD1=uicontrol('style','text','foregroundcolor','r','string','LOADING...','visible','off','units','normalized','position',[.75*.6 .95 .35*.75 .035],'horizontalalignment','left','backgroundcolor','w');
		hh(1)=uicontrol('style','text','visible','on','units','normalized','position',[.51 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(2)=uicontrol('style','text','visible','on','units','normalized','position',[.521 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(3)=uicontrol('style','text','visible','on','units','normalized','position',[.532 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(4)=uicontrol('style','text','visible','on','units','normalized','position',[.543 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(5)=uicontrol('style','text','visible','on','units','normalized','position',[.554 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(6)=uicontrol('style','text','visible','on','units','normalized','position',[.565 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(7)=uicontrol('style','text','visible','on','units','normalized','position',[.576 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(8)=uicontrol('style','text','visible','on','units','normalized','position',[.587 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(9)=uicontrol('style','text','visible','on','units','normalized','position',[.598 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		hh(10)=uicontrol('style','text','visible','on','units','normalized','position',[.609 .965 .0075 .02],'horizontalalignment','left','backgroundcolor','r');
		set(hh,'visible','off')
		etl1=uicontrol('style','text','fontsize',8,'max',1,'fontname','calibri','units','normalized','position',[.75*.6 .9375 .035 .04],'backgroundcolor','w','visible','off','string','For t=','horizontalalignment','left');
		el1=uicontrol('style','edit','fontsize',8,'max',1,'fontname','calibri','units','normalized','position',[.75*.6+.03 .935 .025 .04],'backgroundcolor','w','visible','off','string','','horizontalalignment','center','callback',@editl);
		etl2=uicontrol('style','text','fontsize',8,'max',1,'fontname','calibri','units','normalized','position',[.75*.6+.07 .9375 .035 .04],'backgroundcolor','w','visible','off','string','H=','horizontalalignment','left');
		el2=uicontrol('style','text','fontsize',8,'max',1,'fontname','calibri','units','normalized','position',[.75*.6+.09 .935 .035 .04],'backgroundcolor','w','visible','off','string','','horizontalalignment','left');
		switch get(hr,'selectedobject')
			case hb1
				flc=uicontrol('style','popupmenu','fontsize',8,'max',2,'fontname','calibri','units','normalized','position',[.75*.55 .8 .35*.75 .1],'backgroundcolor','w','visible','off','string',{'For t='},'callback',@pop);
				fc=uicontrol('style','edit','fontsize',8,'max',2,'fontname','courier','horizontalalignment','left','enable','on','units','normalized','position',[.75*.55 .7 .35*.75 .15],'backgroundcolor','w','visible','off');				
				uicontrol('style','text','units','normalized','position',[.05*.75 .9 .175*.75 .025],'string','Amplitudes','backgroundcolor','w')
				TT=uicontrol('style','edit','units','normalized','position',[.11*.75 .85 .05*.75 .04],'string','','backgroundcolor','w','fontsize',7);
				uicontrol('style','text','units','normalized','position',[.75*.2 .9 .175*.75 .025],'string','Constant Shift','backgroundcolor','w')
				RT=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.26 .85 .05*.75 .04],'string','','backgroundcolor','w');
				uicontrol('style','text','units','normalized','position',[.75*.35 .9 .175*.75 .025],'string','Types','backgroundcolor','w')
				SR=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.41 .85 .05*.75 .04],'string','','backgroundcolor','w');
				uicontrol('style','text','units','normalized','position',[.75*.35 .8 .175*.75 .025],'string','Durations','backgroundcolor','w')
				TSR=uicontrol('fontsize',7,'fontsize',7,'style','edit','units','normalized','position',[.75*.41 .75 .05*.75 .04],'string','','backgroundcolor','w');
				uicontrol('style','text','units','normalized','position',[.75*.2 .8 .175*.75 .025],'string','Time Constants','backgroundcolor','w')
				TC=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.26 .75 .05*.75 .04],'string','','backgroundcolor','w');
				uicontrol('style','text','units','normalized','position',[.75*.1 .8 .075*.75 .025],'string','Sensitivities','backgroundcolor','w',...
					'horizontalalignment','left')
				S=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.11 .75 .05*.75 .04],'string','','backgroundcolor','w');
				uicontrol('style','pushbutton','units','normalized','position',[.75*.11 .7 .05*.75 .04],'string','Go','backgroundcolor','w','fontweight','b',...
					'callback',@go)
				pb2=uicontrol('style','pushbutton','units','normalized','position',[.75*.2 .7 .15*.75 .04],'string','Start Simulation','backgroundcolor','w','fontweight','b',...
					'callback',@go2,'visible','off');
				uicontrol('style','text','units','normalized','position',[.75*0 .9 .075*.75 .025],'string','Mode','backgroundcolor','w')
			case hb2
				flc=uicontrol('style','popupmenu','fontsize',8,'max',2,'fontname','calibri','units','normalized','position',[.75*.65 .8 .35*.75 .1],'backgroundcolor','w','visible','off','string',{'For t='},'callback',@pop);
				fc=uicontrol('style','edit','fontsize',8,'max',2,'fontname','courier','horizontalalignment','left','enable','on','units','normalized','position',[.75*.65 .7 .35*.75 .15],'backgroundcolor','w','visible','off');				
				uicontrol('style','text','units','normalized','position',[.05*.75 .95 .175*.75 .025],'string','Types','backgroundcolor','w')
				SR=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.105*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','text','units','normalized','position',[.37*.75 .95 .15*.75 .025],'string','Time Constants','backgroundcolor','w')
				TC=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.41*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);				
				uicontrol('fontsize',12,'style','text','units','normalized','position',[.38*.75 .635 .015*.75 .35],'string',{'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';},'backgroundcolor','w','max',1,...
					'fontweight','b');
				uicontrol('style','text','units','normalized','position',[.2*.75 .95 .075*.75 .025],'string','Amplitudes','backgroundcolor','w')
				TT=uicontrol('style','edit','units','normalized','position',[.2*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2,'fontsize',7);			
				uicontrol('style','text','units','normalized','position',[.305*.75 .95 .075*.75 .025],'string','Durations','backgroundcolor','w')
				TSR=uicontrol('fontsize',7,'fontsize',7,'style','edit','units','normalized','position',[.305*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','text','units','normalized','position',[.075 .575 .075 .025],'string','Constant Shift:','backgroundcolor','w')
				RT=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.15 .565 .035 .045],'string','','backgroundcolor','w');
				uicontrol('style','text','units','normalized','position',[.515*.75 .95 .075*.75 .025],'string','Sensitivities','backgroundcolor','w',...
					'horizontalalignment','left')
				S=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.515*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','pushbutton','units','normalized','position',[.2 .565 .035 .045],'string','Go','backgroundcolor','w','fontweight','b',...
					'callback',@go)
				pb2=uicontrol('style','pushbutton','units','normalized','position',[.25 .565 .1 .045],'string','Start Simulation','backgroundcolor','w','fontweight','b',...
					'callback',@go2,'visible','off');
				uicontrol('style','text','units','normalized','position',[.75*0 .9 .075*.75 .025],'string','Mode','backgroundcolor','w')						
			case hb3
				uicontrol('fontsize',12,'style','text','units','normalized','position',[.38*.75 .635 .015*.75 .35],'string',{'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';'|';},'backgroundcolor','w','max',1,...
					'fontweight','b');				
				flc=uicontrol('style','popupmenu','fontsize',8,'max',2,'fontname','calibri','units','normalized','position',[.75*.65 .8 .35*.75 .1],'backgroundcolor','w','visible','off','string',{'For t='},'callback',@pop);
				fc=uicontrol('style','edit','fontsize',8,'max',2,'fontname','courier','horizontalalignment','left','enable','on','units','normalized','position',[.75*.65 .7 .35*.75 .15],'backgroundcolor','w','visible','off');				
				uicontrol('style','text','units','normalized','position',[.05*.75 .95 .175*.75 .025],'string','Types','backgroundcolor','w')
				SR=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.105*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','text','units','normalized','position',[.37*.75 .95 .15*.75 .025],'string','Time Constants','backgroundcolor','w')
				TC=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.41*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','text','units','normalized','position',[.2*.75 .95 .075*.75 .025],'string','Amplitudes','backgroundcolor','w')
				TT=uicontrol('style','edit','units','normalized','position',[.2*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2,'fontsize',7);
				uicontrol('style','text','units','normalized','position',[.305*.75 .95 .075*.75 .025],'string','Durations','backgroundcolor','w')
				TSR=uicontrol('fontsize',7,'fontsize',7,'style','edit','units','normalized','position',[.305*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','text','units','normalized','position',[.075 .575 .075 .025],'string','Constant Shift:','backgroundcolor','w')
				RT=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.15 .565 .035 .045],'string','','backgroundcolor','w');
				uicontrol('style','text','units','normalized','position',[.515*.75 .95 .075*.75 .025],'string','Sensitivities','backgroundcolor','w',...
					'horizontalalignment','left')
				S=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.515*.75 .635 .07*.75 .3],'string','','backgroundcolor','w','max',2);
				uicontrol('style','pushbutton','units','normalized','position',[.2 .565 .035 .045],'string','Go','backgroundcolor','w','fontweight','b',...
					'callback',@go)
				pb2=uicontrol('style','pushbutton','units','normalized','position',[.25 .565 .1 .045],'string','Start Simulation','backgroundcolor','w','fontweight','b',...
					'callback',@go2,'visible','off');
				uicontrol('style','text','units','normalized','position',[.75*0 .9 .075*.75 .025],'string','Mode','backgroundcolor','w')
				axes(a2d)
 				zoom off
				cla
				xlim([-3 1])
				y2=uicontrol('style','edit','units','normalized','position',[.06 .475 .025 .035],'string','1','backgroundcolor','w','callback',@cgz);
				y1=uicontrol('style','edit','units','normalized','position',[.06 .075 .025 .035],'string','-1','backgroundcolor','w','callback',@cgz);
				ydr=uicontrol('style','edit','units','normalized','position',[.06 .275 .025 .035],'string','.5','backgroundcolor','w','callback',@dr);				
				x2=uicontrol('style','edit','units','normalized','position',[.36 .0675 .025 .035],'string','5','backgroundcolor','w','callback',@cgz);
				set(a2d,'buttondownfcn',@clk)			
				cht
		end
	end

	function clk(varargin)
		set(ydr,'enable','inactive')
		legend off
		hold on
		choice=0;
		while  get(hr,'selectedobject')==hb3
			if strcmp(get(dumdum,'string'),'1')
				cp=[0,str2double(get(ydr,'string'))];
				set(dumdum,'string','2')
			end
			p=get(gca,'currentpoint');
			p=[p(1,1),p(1,2)];
			set(RT,'string',get(ydr,'string'));
			ppy1=str2double(get(y1,'string')) ;
			ppy2=str2double(get(y2,'string')) ;
			dunn=diff([ppy1 ppy2]);
			if strcmp(get(op4,'string'),'1')
				p(1)=ceil(p(1));
			end
			if strcmp(get(op5,'string'),'1')
				p(2)=round(p(2));
			end
			if strcmp(get(op2,'string'),'1')
				if abs(p(2)-str2double(get(ydr,'string')))<dunn/20
					p(2)=str2double(get(ydr,'string'));
					tmp=line([-1 p(1)],[p(2) p(2)],'linestyle','--','color','r');
					pause(.15)
					delete(tmp)
				end
			end
			aiid=str2num(get(aii,'string'));%#ok
			kk=abs(aiid-p(2));
			ll=find(kk<dunn/20);		
			if strcmp(get(op2,'string'),'1')
				if ~isempty(aiid) && ~isempty(ll)
					p(2)=aiid(ll(1));
					tmp=line([-1 p(1)],[p(2) p(2)],'linestyle','--','color','r');
					pause(.15)
					delete(tmp)
				end
			end
			set(aii,'string',num2str([str2num(get(aii,'string'));p(2)]));%#ok
			if p(1)<cp(1)
				line([cp(1) cp(1)],[cp(2),p(2)])
				set(TT,'string',strvcat(get(TT,'string'),num2str(p(2)-cp(2),4)))%#ok
				set(SR,'string',[get(SR,'string');'s'])
				set(crr,'string',num2str(str2double(get(crr,'string'))+1))
				cp(2)=p(2);
				break
			end			
			soim=str2double(get(uver,'string'));
			if strcmp(get(op2,'string'),'1')
				if abs(p(2)-cp(2))<dunn/20
					tmp=line([-1 p(1)],[p(2) p(2)],'linestyle','--','color','r');
					pause(.15)
					delete(tmp)					
					if abs(soim) <.01
						line([cp(1) p(1)],[cp(2),cp(2)])
						set(SR,'string',[get(SR,'string');'s'])
						set(crr,'string',num2str(str2double(get(crr,'string'))+1))
						set(TSR,'string',strvcat(get(TSR,'string'),num2str(p(1)-cp(1),4)))%#ok
						cp(1)=p(1);
						break
					end
					line([cp(1) p(1)],[cp(2) cp(2)])
					set(SR,'string',[get(SR,'string');'r'])					
					set(crr,'string','0')
					soim=str2double(get(uver,'string'));%#ok
					pek=get(SR,'string');
					pik=str2num(get(TT,'string'));%#ok
					set(TT,'string',strvcat(get(TT,'string'),num2str(-1*sum(pik(pek(1:end-1)=='r')),4)))%#ok
					set(TSR,'string',strvcat(get(TSR,'string'),num2str(p(1)-cp(1),4)))%#ok
					cp=p;
					set(uver,'string','0')
					break
				end
 			end
 			amp=(p(2)-cp(2))/(p(1)-cp(1));
 			TTT=str2num(get(uverY,'string'));%#ok
 			kk=abs(TTT-amp);
 			ll=find(kk<dunn/10);		
 			if strcmp(get(op3,'string'),'1')
 				if ~isempty(TTT) && ~isempty(ll)
 					p(1)=cp(1)+(p(2)-cp(2))/TTT(ll(1));
 					tmp=line([-1 p(1)],[p(2) p(2)],'linestyle','--','color','g');
 					pause(.15)
 					delete(tmp)
					if abs(diff([(p(2)-cp(2))/(p(1)-cp(1)) str2double(get(uver,'string'))]))<.0001
						choice=1;
					end					
				end
			end
			line([cp(1) p(1)],[cp(2) p(2)])
			amp=(p(2)-cp(2))/(p(1)-cp(1));
			set(TT,'string',strvcat(get(TT,'string'),num2str(amp-str2double(get(uver,'string')),4)));%#ok
			set(uver,'string',num2str(amp))
 			set(uverY,'string',num2str(strvcat(get(uverY,'string'),num2str(amp))));%#ok			
			set(TSR,'string',strvcat(get(TSR,'string'),num2str(p(1)-cp(1),4)))%#ok
			set(SR,'string',[get(SR,'string');'r'])			
			set(crr,'string','0')
			cp=p;
			break					
		end
		l=get(SR,'string');
		for aa=length(l)-1
			if aa && strcmp(l(aa),'s') && strcmp(l(aa+1),'s') && (strcmp(get(crr,'string'),'2') ||  strcmp(get(crr,'string'),'4'))
				l(aa)=[];
				set(SR,'string',l)
				break
			end
		end
		if strcmp(get(crr,'string'),'4')
			set(crr,'string','0')
		end							
		if (size((get(SR,'string')),1)~=size(str2num(get(TSR,'string')),1)) && size(str2num(get(TSR,'string')),1)>0%#ok
			pch=str2num(get(TSR,'string'));%#ok
			pl=pch(end);
			pch(end)=[];
			if strcmp(l(end),'r')
				pch=[pch;1e-9;pl];
			else
				pch=[pch;pl;1e-9];
			end
			set(TSR,'string',num2str(pch))
		end
		piT=str2num(get(TT,'string'));%#ok
		if piT(end)==-inf || piT(end)==inf			
			l(end+1)='s';
			set(SR,'string',l)
			piT(end)=p(2)-cp(2);
			set(TT,'string',num2str(piT))
		end				
		if size((get(SR,'string')),1)==size(str2num(get(TSR,'string')),1)-2%#ok
			pch=str2num(get(TSR,'string'));%#ok
			pl=pch(end-1);
			pch(end-2:end)=[];
			pch=[pch;pl];
			set(TSR,'string',num2str(pch))
		end		
			if choice
				ttT=str2num(get(TT,'string'));%#ok
				ttD=str2num(get(TSR,'string'));%#ok
				ttS=(get(SR,'string'));
				ttT(end)=[];
				ttS(end)=[];
				ttD(end-1)=[];
				set(TT,'string',num2str(ttT))
				set(TSR,'string',num2str(ttD))
				set(SR,'string',(ttS))			
			end
	end

	function dr(varargin)
		delete(findobj(gca,'type','line'));
 		fplot(get(ydr,'string'),[-3 0])
		xlim([-3 str2double(get(x2,'string'))])
		ylim([str2double(get(y1,'string')) str2double(get(y2,'string'))])
		pp=get(ydr,'position');
		ppy1=(get(y1,'position')) ;
		ppy1=ppy1(2);
		ppy2=(get(y2,'position')) ;
		ppy2=ppy2(2);
		dunn=diff([ppy1 ppy2]);
		pp(2)=ppy1+dunn/diff([str2double(get(y1,'string')) str2double(get(y2,'string'))])*(str2double(get(ydr,'string'))-str2double(get(y1,'string')));
		set(ydr,'position',pp);
		set(a2d,'buttondownfcn',@clk)
	end
		
	function cgz(varargin)
		hold on
		legend off
 		fplot(get(ydr,'string'),[-3 0])
		xlim([-3 str2double(get(x2,'string'))])
		ylim([str2double(get(y1,'string')) str2double(get(y2,'string'))])
		set(a2d,'buttondownfcn',@clk)
		pp=get(ydr,'position');
		ppy1=(get(y1,'position')) ;
		ppy1=ppy1(2);
		ppy2=(get(y2,'position')) ;
		ppy2=ppy2(2);
		dunn=diff([ppy1 ppy2]);
		pp(2)=ppy1+ dunn/diff([str2double(get(y1,'string')) str2double(get(y2,'string'))])*(str2double(get(ydr,'string'))-str2double(get(y1,'string')));
		set(ydr,'position',pp);
	end

uicontrol('style','text','units','normalized','position',[.75*.35 .9 .175*.75 .025],'string','Types','backgroundcolor','w')
SR=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.41 .85 .05*.75 .04],'string','','backgroundcolor','w');
uicontrol('style','text','units','normalized','position',[.75*.35 .8 .175*.75 .025],'string','Durations','backgroundcolor','w')
TSR=uicontrol('fontsize',7,'fontsize',7,'style','edit','units','normalized','position',[.75*.41 .75 .05*.75 .04],'string','','backgroundcolor','w');
uicontrol('style','text','units','normalized','position',[.75*.2 .8 .175*.75 .025],'string','Time Constants','backgroundcolor','w')
TC=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.26 .75 .05*.75 .04],'string','','backgroundcolor','w');
uicontrol('style','text','units','normalized','position',[.75*.1 .8 .075*.75 .025],'string','Sensitivities','backgroundcolor','w',...
	'horizontalalignment','left')
S=uicontrol('fontsize',7,'style','edit','units','normalized','position',[.75*.11 .75 .05*.75 .04],'string','','backgroundcolor','w');
a2d=axes('position',[.75*0.1 .1 .4*.75 .4],'buttondownfcn',@clk);
a3d=axes('position',[.75*0.65 .01 .4*.75 .8],'xcolor','w','ycolor','w','zcolor','w','xlim',[0 1],'ylim',[0 1],'zlim',[0 1]);
uicontrol('style','pushbutton','units','normalized','position',[.75*.11 .7 .05*.75 .04],'string','Go','backgroundcolor','w','fontweight','b',...
	'callback',@go)
pb2=uicontrol('style','pushbutton','units','normalized','position',[.75*.2 .7 .15*.75 .04],'string','Start Simulation','backgroundcolor','w','fontweight','b',...
	'callback',@go2,'visible','off');

    function sound4(a) 
        t=-4:.01:4;      
        sound(cos(a*t)*10)
    end

	function go(varargin)
		if strcmp(get(op1,'string'),'1')
			sound4(40)
			pause(.15)
			sound4(40)
			pause(.15)
			sound4(40)
			pause(.15)
			sound4(40)
			pause(.15)
			sound4(40+9/2)
		end
		set(el1,'visible','off','string','')
		set(el2,'visible','off','string','')
		set(etl1,'visible','off')
		set(etl2,'visible','off')		
		set(LOAD1,'visible','on')
		set(hh,'visible','on','backgroundcolor','r')
		set(pb2,'visible','off')
		drawnow()
		axes(a3d)
		cla
		axes(a2d)
		cla
		switch get(hr,'selectedobject')
			case hb1
				shift=str2num(get(RT,'string'));%#ok
				tau=str2num(get(TC,'string'));%#ok
				A=str2num(get(TT,'string'));%#ok
				K=str2num(get(S,'string'));%#ok
				types=get(SR,'string');
				durations=str2num(get(TSR,'string'));%#ok
			otherwise
				shift=str2num(get(RT,'string'))';%#ok
				tau=str2num(get(TC,'string'))';%#ok
				A=str2num(get(TT,'string'))';%#ok
				K=str2num(get(S,'string'))';%#ok			
				types=get(SR,'string')';
				durations=str2num(get(TSR,'string'))';%#ok
		end
				if get(nsZ,'value')
					K=repmat(K,size(A));
					tau=repmat(tau,size(A));					
				end
		times=[0,cumsum(durations)];
		types(ismember(types,' '))=[];
		types(ismember(types,','))=[];		
		types(ismember(types,';'))=[];		
		Y=[0;shift];		
		axes(a2d)
		cla
		hold on
		line([-3 0],[shift shift]);
		set(findobj('type','line'),'color','y')
		output=num2str(shift);
		OP='';
		Y2=[];
		roy2=shift;
		EX=[];
		camp=[];
		for UL=1:length(A)
			switch types(UL)
				case 's'					
					switch sign(A(UL))*sign(K(UL))
						case 1
							koi='+';
						case -1
							koi='';
						case 0
							error('There is no change!')%#ok
					end
					output=[output,koi,num2str((A(UL))*K(UL)),'*(1-exp(-(t-',num2str(times(UL)),')/',num2str(tau(UL)),'))'];%#ok
					OP=strvcat(OP,output);%#ok
					roy=sym([koi,num2str((A(UL))*K(UL)),'*(1-exp(-(t-',num2str(times(UL)),')/',num2str(tau(UL)),'))']);
					roy=ilaplace(1/K(UL)*(1+tau(UL)*sym('s'))*laplace(roy));					
					EX=[EX;[times(UL) subs(roy2,times(UL));times(UL) subs(roy2,times(UL))+A(UL)]];%#ok
					fplot(output,[times(UL) times(UL+1)]);
				case 'r'
					switch sign(A(UL))*sign(K(UL))
						case 1
							koi='+';
						case -1
							koi='';
						case 0
							error('There is no change!')%#ok
					end
					switch sign(tau(UL))
						case 1
							koi2='-';
						case -1
							koi='+';
					end					
					output=[output,koi,num2str((A(UL))*K(UL)),'*(',num2str(tau(UL)),'*exp(-(t-',num2str(times(UL)),')/',num2str(tau(UL)),')','+t-',num2str(times(UL)),koi2,num2str(abs(tau(UL))),')'];%#ok
					OP=strvcat(OP,output);%#ok
					roy=sym([koi,num2str((A(UL))*K(UL)),'*(',num2str(tau(UL)),'*exp(-(t-',num2str(times(UL)),')/',num2str(tau(UL)),')','+t-',num2str(times(UL)),koi2,num2str(abs(tau(UL))),')']);
					roy=ilaplace(1/K(UL)*(1+tau(UL)*sym('s'))*laplace(roy));
					fplot(output,[times(UL) times(UL+1)]);
				case 'p'
					switch sign(A(UL))*sign(K(UL))
						case 1
							koi='+';
						case -1
							koi='';
						case 0
							error('There is no change!')%#ok
					end
					output=[output,koi,num2str((A(UL))*K(UL)),'*(((t-',num2str(times(UL)),')^2)/2','-',num2str(tau(UL)),'*(t-',num2str(times(UL)),')+',num2str(tau(UL)^2),'-',num2str(tau(UL)^2),'*exp(-(t-',num2str(times(UL)),')/',num2str(tau(UL)),'))'];%#ok
					OP=strvcat(OP,output);%#ok
					roy=sym([koi,num2str((A(UL))*K(UL)),'*(((t-',num2str(times(UL)),')^2)/2','-',num2str(tau(UL)),'*(t-',num2str(times(UL)),')+',num2str(tau(UL)^2),'-',num2str(tau(UL)^2),'*exp(-(t-',num2str(times(UL)),')/',num2str(tau(UL)),'))']);
					roy=ilaplace(1/K(UL)*(1+tau(UL)*sym('s'))*laplace(roy));					
					fplot(output,[times(UL) times(UL+1)]);
				case 'n'
					switch sign(A(UL))*sign(K(UL))
						case 1
							koi='+';
						case -1
							koi='';
						case 0
							error('There is no change!')%#ok
					end
					output=[output,koi,num2str(A(UL)*K(UL)),'/(1+',num2str(tau(UL)^2),')*(sin(t-',num2str(times(UL)),')+',num2str(tau(UL)),'*(exp(-(t-',num2str(times(UL)),...
						')/',num2str(tau(UL)),')-cos(t-',num2str(times(UL)),')))'];					%#ok
					OP=strvcat(OP,output);%#ok
					roy=sym([koi,num2str(A(UL)*K(UL)),'/(1+',num2str(tau(UL)^2),')*(sin(t-',num2str(times(UL)),')+',num2str(tau(UL)),'*(exp(-(t-',num2str(times(UL)),...
						')/',num2str(tau(UL)),')-cos(t-',num2str(times(UL)),')))']);
					roy=ilaplace(1/K(UL)*(1+tau(UL)*sym('s'))*laplace(roy))				;
					fplot(output,[times(UL) times(UL+1)]);
			end
			set(findobj('type','line','color','b'),'color','m')
			roy2=roy2+roy;
			ezplot((roy2),[times(UL),times(UL+1)]);
			if ~isempty(EX)
				for k=1:2:size(EX,1)
					line([EX(k,1),EX(k,1)],[EX(k,2),EX(k+1,2)])
				end
			end
			set(findobj('type','line','color','b'),'color','y')
			k=inline(output);
			if strcmp(types(UL),'n')
				Y=[Y;Y(end)+A(UL);Y(end)-A(UL)];%#ok
			end
			Y=[Y;k(times(UL+1))];%#ok
			k3=inline((roy2));
			Y2=[Y2;k3(times(UL+1))];%#ok
			camp=[camp;roy2];%#ok
			if UL>length(A)/3
				set(hh(1),'backgroundcolor','g')
				drawnow()
			end
			if UL>length(A)*2/3
				set(hh(2),'backgroundcolor','g')
				drawnow()				
			end
		end
		set(hh(3),'backgroundcolor','g')
		drawnow()
		Y=[Y;Y2];
		xlim([-3,times(end)+1]);
		set(findobj('type','line','color','m'),'linestyle','--','linewidth',2)
		set(findobj('type','line','color','y'),'color','b','linewidth',2)					 
		set(findobj('type','line','color','b'),'linewidth',2)
		fplot('0',[-3 times(end)+1],'k-.')
		title('')
		h=xlabel('t (s)');
		set(h,'fontsize',10,'fontangle','i','fontweight','b')
		h=ylabel('Height');
		set(h,'fontsize',10,'fontangle','i','fontweight','b')
		axis([-3,times(end)+1 min(Y)-1 max(Y)+3])
		h1=findobj(gca,'color','b');
		hg3510=findobj(gca,'color','m');
		legend([h1(1),hg3510(1)],'Ideal','True','location','best');
 		cover=patch([-3 times(end)+2 times(end)+2 -3],[min(Y)-1 min(Y)-1 max(Y)+5 max(Y)+5],'w','linestyle','--');		
		axes(a3d)
		cla		
		axis square
		view(3)
		a=[0 0 0;
			1 0 0;
			1 1 0;
			0 1 0;
			0 0 1;
			1 0 1;
			1 1 1;
			0 1 1];
		a(:,2)=a(:,2)*.3+.7;
		a(:,1)=a(:,1)*.3;
		ab=a;
		a(:,3)=a(:,3)*(max(Y)+3);
		a(1:4,3)=a(1:4,3)+(min(Y)-1);
		b=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
 		patch('vertices',a,'faces',b,'edgecolor','k','facecolor','w','linewidth',2,'FaceVertexAlphaData',0.5)	
		ab(:,3)=ab(:,3)*shift;
  		pid=patch('vertices',ab,'faces',b,'edgecolor','k','facecolor','b','linewidth',2);
		a=[0 0 0;
			1 0 0;
			1 1 0;
			0 1 0;
			0 0 1;
			1 0 1;
			1 1 1;
			0 1 1];
		a(:,2)=a(:,2)*.3+.4;
		a(:,1)=a(:,1)*.3+.3;
		ab=a;
		a(:,3)=a(:,3)*(max(Y)+3);
		a(1:4,3)=a(1:4,3)+(min(Y-1));
		b=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
		patch('vertices',a,'faces',b,'edgecolor','k','facecolor','w','linewidth',2,'FaceVertexAlphaData',0.5)
		ab(:,3)=ab(:,3)*shift;	
		pt=patch('vertices',ab,'faces',b,'edgecolor','k','facecolor','m','linewidth',2);		
		tc1=text('position',[0 .3 min(Y)-1],'string',['Height= ',num2str(shift)],'fontweight','b','fontsize',10,'fontangle','i');
 		tc2=text('position',[.3 .05 min(Y)-1],'string',['Time= ',num2str(0),','],'fontweight','b','fontsize',10,'fontangle','i');
		tc3=text('position',[-.3 .55 min(Y)-1],'string',['Height= ',num2str(shift),','],'fontweight','b','fontsize',10,'fontangle','i');		
		zlim([min(Y)-2 max(Y)+4])
 		set(a3d,'zcolor','k')		
		p=get(gca,'ztick');
		pc=str2num(get(dux,'string'));%#ok
		for llp=1:length(pc)
			p2=p-pc(llp);
			p2(p2<1e-1)=0;
			p(p2==0)=[];
		end
		set(dux,'string',mat2str([Y2;shift]));
		pu=[p,Y2',shift,0];
		set(gca,'ztick',unique(sort(round(pu*1000)/1000)))		
		set(fc,'visible','on');
		str=cell(length(times)-1);
		for j=1:length(times)-1
			str{j}=['For t= ',num2str(times(j)),' to ',num2str(times(j+1))];
		end
		set(flc,'visible','on','string',str,'value',1);
		pop		
		limit=times(end);
		times=[times,9e99];
		wr=0;
		pr=1;
		inc=limit/50;
		t=[0.001:inc:limit,limit];
		f1=zeros(length(t),1);
		f2=zeros(length(t),1);	
		set(hh(4),'backgroundcolor','g')
		drawnow()
		for l=1:length(t)
			if t(l)>times(pr)
				pr=pr+1;
				wr=wr+1;
			end
			f1(l)=subs(OP(wr,:),t(l));
			f2(l)=subs(camp(wr),t(l));
			if l>length(t)/6
				set(hh(5),'backgroundcolor','g')
				drawnow()
			end
			if l>length(t)*2/6
				set(hh(6),'backgroundcolor','g')
				drawnow()				
			end
			if l>length(t)*3/6
				set(hh(7),'backgroundcolor','g')
				drawnow()				
			end
			if l>length(t)*4/6
				set(hh(8),'backgroundcolor','g')
				drawnow()				
			end
			if l>length(t)*5/6
				set(hh(9),'backgroundcolor','g')
				drawnow()				
			end
		end
		set(hh(10),'backgroundcolor','g')
		set(LOAD1,'visible','off')
		set(pb2,'visible','on')
		if strcmp(get(op1,'string'),'1')
			sound4(40)
			pause(.15)
			sound4(40)
			pause(.15)
			sound4(40)
			pause(.15)
			sound4(40)
			pause(.15)
			sound4(40+9/2)
		end
		set(el1,'visible','on')
		set(el2,'visible','on')
		set(etl1,'visible','on')
		set(etl2,'visible','on')
		set(hh,'visible','off')
	end

dux=uicontrol('style','text','visible','off','string','0');
flc=uicontrol('style','popupmenu','fontsize',8,'max',2,'fontname','calibri','units','normalized','position',[.75*.55 .8 .35*.75 .1],'backgroundcolor','w','visible','off','string',{'For t='},'callback',@pop);

	function pop(varargin)
		val=get(flc,'value');
		set(fc,'string',strvcat('The output is equal to',OP(val,:),'','OR',sym2str(simple(sym(OP(val,:)))))) %#ok
	end

fc=uicontrol('style','edit','fontsize',8,'max',2,'fontname','courier','horizontalalignment','left','enable','on','units','normalized','position',[.75*.55 .7 .35*.75 .15],'backgroundcolor','w','visible','off');

	function [out] = sym2str(sy)
		sy = vpa(sy,10);
		siz = numel(sy);
		for i = 1:siz
			in{i} = char(sy(i));%#ok
			in{i} = strrep(in{i},'array([[','[');%#ok
			in{i} = strrep(in{i},'],[',';');%#ok
			in{i} = strrep(in{i},']])',']');%#ok
		end
		if siz == 1
			in = char(in);
		end
		out = in;
	end

	function sound2(a)
		if strcmp(get(op1,'string'),'0')
			return
		end
		t=-4:.01:4;
		switch a
			case 1
				T0=1;
				t=-4:.01:4;
				w0=2*pi/T0;
				s2=1/2;
				for k=1:140
					s2=s2+2*(1-cos(20*k*w0*t-pi/2)+1*sin(20*k*w0*t-pi/2))*10/(1+k^2);
				end
				sound(s2)
			case 2
				T0=1;
				t=-4:.01:4;
				w0=2*pi/T0;
				s2=1/2;
				for k=1:140
					s2=s2+2*(1-cos(10*k*w0*t-pi/2)+1*sin(10*k*w0*t-pi/2))*10/(1+k^2);
				end
				sound(s2)
			case 2
				sound(10*sin(50*t))
		end
	end

	function go2(varargin)
		sound2(1)
		switch get(hr,'selectedobject')
			case hb1
				durations=str2num(get(TSR,'string'));%#ok
			otherwise
				durations=str2num(get(TSR,'string'))';%#ok	
		end
		shift=str2double(get(RT,'string'));
		times=[0,cumsum(durations)];
		limit=times(end);
		inc=limit/50;
		ss=0;
		kk=1;
		for t=[-3:inc:limit,limit]	
			if t>0
				if kk<=length(times) && t>times(kk)
					sound2(2)
					kk=kk+1;
				end
				ss=ss+1;
				axes(a3d)
				a=get(pt,'vertices');
				a2=get(pid,'vertices');
				output=f1(ss);
				a(5:8,3)=output;
				a2(5:8,3)=f2(ss);
				set(pt,'vertices',a)
				set(pid,'vertices',a2)
				set(tc1,'string',['Height= ',num2str(output,3)]);
				set(tc3,'string',['Height= ',num2str(f2(ss),3)]);
				drawnow()
				axes(a2d)
			else
				axes(a3d)
				a=get(pt,'vertices');
				a2=get(pid,'vertices');
				output=shift;
				a(5:8,3)=output;
				a2(5:8,3)=shift;
				set(pt,'vertices',a)
				set(pid,'vertices',a2)
				set(tc1,'string',['Height= ',num2str(output,3)]);
				set(tc3,'string',['Height= ',num2str(shift,3)]);
				drawnow()
				axes(a2d)
			end
			set(cover,'xdata',[t limit+2 limit+2 t])
			set(tc2,'string',['Time= ',num2str(t,3),' s']);
		end
	end
set(gcf,'position',[.1 .2 .8 .6])
grv
end