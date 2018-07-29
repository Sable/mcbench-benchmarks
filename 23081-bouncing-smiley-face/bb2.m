function bb2()
% BB2 Bouncing Smiley Ball Physics
% BB2 is a graphical User Interface that creates a simple simulation of a ball bouncing
% off the ground. 
% 
% Ball Parameters are:
% 
% Height from the center of the ball to the ground is 10. This is constant and cannot
% change. Instead, change the other parameters since they're all relative.
% 
% Radius: Radius of the ball. It's best to put it between 1 and 9. Any value equal to
% or above 10 will present problems as 10 is the distance from the centre of the ball
% to the ground.
% 
% Gravity: Affect the ratio in which the ball gains speed in the negative Y direction.
% 
% Initial Yv: Initial velocity in the Y direction. Can be positive, negative, or anything.
% 
% Initial Xv: Initial velocity in the X direction. Can be positive, negative, or anything.
% 
% Vertical Speed Conservation (%): Affects how much energy (velocity) is retained in the
% Y direction after hitting the ground. A value of 0 to 100 is normal. A value of 0 means
% no energy is retained and the ball comes to a halt after hitting the ground. A value
% of 100 means all energy is retained and the ball will bounce indefinitely. A value of 
% over 100 will cause energy to increase after hitting the ground.
% 
% Horizontal Speed Conservation (%): Same as Vertical Speed Conservation but in the
% X direction.
% 
% Initial Angular Velocity (CW): The initial rotational velocity of the ball (spin).
%
% Plotting a path enables you to see the x-y diagram of the ball's movement and gives
% you the ability to pan the axes with the mouse.
%
%
% Please note that the ball may stop moving at different locations for different 
% trials, even with the same input parameters. This is due to the slight
% randomization of the deformations of the ball and the ground, which could lead
% to the ball getting "stuck" to the ground at times. This is normal and
% deliberate.
%
% Set the vertical speed conservation as a value larger than 100 (e.g. 170) for
% a small bonus ;)
%
% I'd like to thank John D'Errico and Kennith Eaton whose ideas helped me a lot.
%
%
% To launch the GUI, type bb2 in the command window with this file in the current
% directory. Alternatively, you can choose Debug -> Run from this editor window, or
% press F5.
%
% Tested on MATLAB 7.4 (R2007a)
% 
% Husam Aldahiyat, 2009
% numandina@gmail.com
%

figure('units','normalized','position',[.2 .2 .65 .65],'menubar','none','numbertitle','off','color','w','name','Bouncing Smiley')
axes('position',[.25 .05 .65 .75])
ed1=uicontrol('style','edit','units','normalized','position',[.025 .895 .1 .05],'backgroundcolor','w','string','1','callback',@init);
uicontrol('style','text','units','normalized','position',[.025 .96 .1 .025],'backgroundcolor','w','string','Radius');
ed2=uicontrol('style','edit','units','normalized','position',[.025 .775 .1 .05],'backgroundcolor','w','string','9.81');
uicontrol('style','text','units','normalized','position',[.025 .84 .1 .025],'backgroundcolor','w','string','Gravity');
ed3=uicontrol('style','edit','units','normalized','position',[.025 .65 .1 .05],'backgroundcolor','w','string','0');
uicontrol('style','text','units','normalized','position',[.025 .72 .1 .025],'backgroundcolor','w','string','Initial Yv');
ed4=uicontrol('style','edit','units','normalized','position',[.025 .535 .1 .05],'backgroundcolor','w','string','500');
uicontrol('style','text','units','normalized','position',[.025 .6 .1 .025],'backgroundcolor','w','string','Initial Xv');
ed5=uicontrol('style','edit','units','normalized','position',[.025 .415 .1 .05],'backgroundcolor','w','string','70');
uicontrol('style','text','units','normalized','position',[.005 .48 .21 .025],'backgroundcolor','w','string',...
	'Vertical Speed Conservation (%)','horizontalalignment','left');
ed6=uicontrol('style','edit','units','normalized','position',[.025 .295 .1 .05],'backgroundcolor','w','string','50');
uicontrol('style','text','units','normalized','position',[.005 .36 .21 .025],'backgroundcolor','w','string',...
	'Horizontal Speed Conservation (%)','horizontalalignment','left');
ed7=uicontrol('style','edit','units','normalized','position',[.025 .175 .1 .05],'backgroundcolor','w','string','25');
uicontrol('style','text','units','normalized','position',[.005 .24 .21 .025],'backgroundcolor','w','string',...
	'Initial Angular Velocity (CW)','horizontalalignment','left');

tb=uicontrol('style','togglebutton','string','Start','callback',@go,'units','normalized','position',[.025 .05 .1 .05],...
	'backgroundcolor','g');
chk=uicontrol('style','checkbox','string','Plot Path','units','normalized','position',[.025 .125 .1 .025],'backgroundcolor','w');
dummy1=uicontrol('style','text','max',2,'visible','off');
init;

	function [hb,h2,hx,h1,r,t,KE,hL]=init(varargin)
		r=str2double(get(ed1,'string'));
		t=linspace(0,2*pi,100);
		cla reset
		hold on
		h1=fill((5)+r*cos(t),(10)+r*sin(t),'y');
		am =[
			0    0    0    0    0    1    1    0    0    0    0    0    0    0    0    0    0    1    1    0    0    0    0    0    0
			0    0    0    0    1    1    1    1    0    0    0    0    0    0    0    0    1    1    1    1    0    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    0    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
			0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
			0    0    0    0    1    1    1    1    0    0    0    0    0    0    0    0    1    1    1    1    0    0    0    0    0
			0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
			1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1
			1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1
			1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1
			1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1
			1    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1
			1    1    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1    1
			0    0    1    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1    0    0
			0    0    0    0    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1    0    0    0
			0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    0    0    0    0    0
			0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    1    1    0    0    0    0    0    0
			];
		am=[zeros(2,25);am;zeros(2,25)];
		colormap([1 1 0;0 0 0]);
		axis([0 10 -1 10+r+1])
		axis equal
		hx=axis;
		hL=line(1000.*[hx(1),hx(2)],[10 10]);
		axis(hx)
		set(hL,'color','c','linestyle','--')
		set(h1,'linewidth',3)
		hL=line(1000.*[hx(1) hx(2)],[0 0]);
		set(hL,'color','k','linestyle','-','linewidth',3)		
		h2=plot(5,10,'k+');
		hb=[h1,h2];
		KE=surface(flipud(am),'facecolor','texturemap','xdata',linspace(get(h2,'xdata')-r/2,get(h2,'xdata')+r/2,...
				25),'ydata',linspace(get(h2,'ydata')-r/2,get(h2,'ydata')+r/2,25),'edgecolor','none');
	end

	function go(varargin)
		set(tb,'value',0)
		if strcmp(get(tb,'string'),'Start')			
			set(tb,'string','Stop','backgroundcolor','r')			
		else
			set(tb,'string','Start','backgroundcolor','g')
			return
		end
		set(dummy1,'string','')
		dt=1;
		[hb,h2,hx,h1,r,t,KE]=init;
		rot=str2double(get(ed7,'string'));
		a=str2double(get(ed2,'string'))/2000;
		Yv=-1*str2double(get(ed3,'string'))/2000;
		Xv=str2double(get(ed4,'string'))/2000;
		e=str2double(get(ed5,'string'))/100;
		f=str2double(get(ed6,'string'))*.7/100;
		pc=0;
		c=0;
		set(h2,'visible','off')
		ll=0;
		while strcmp(get(tb,'string'),'Stop')
			if c<5
				am =[					
				0    0    0    0    0    1    1    0    0    0    0    0    0    0    0    0    0    1    1    0    0    0    0    0    0
				0    0    0    0    1    1    1    1    0    0    0    0    0    0    0    0    1    1    1    1    0    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    0    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
				0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
				0    0    0    0    1    1    1    1    0    0    0    0    0    0    0    0    1    1    1    1    0    0    0    0    0
				0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
				1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1
				1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1
				1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1
				1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1
				1    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1
				1    0    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    0    1
				0    0    0    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1    0    0
				0    0    0    0    1    1    1    0    0    0    0    0    0    0    0    0    0    0    0    1    1    1    0    0    0
				0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    1    1    1    1    1    0    0    0    0    0
				0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    1    1    0    0    0    0    0    0
				];
			am=[zeros(2,25);am;zeros(2,25)]; %#ok
			colormap([1 1 0;0 0 0])
			set(h1,'facecolor','y')
			p=0;
			else
				c=c-1;
				p=p+1;
			end
			if p>30 && rot<.1
				set(tb,'string','Start','backgroundcolor','g');
				break
			end
			pc=pc+1;			
			yc=get(h2,'ydata');
			if get(chk,'value')
				plot(get(h2,'xdata'),yc,'k.')
				pan on
			end
			Yv=Yv+a*dt;			
			if yc-(Yv+a*dt)*dt<=r-min(get(h1,'ydata'))						
				if Yv>1
					figure('units','normalized','menubar','none','numbertitle','off','color','w')
					set(gcf,'position',[0 -.3 1 1.27])
					axes('position',[0 0 1 1 ])
					t=-4:.01:4;
					sound(cos(300.*t.^2));
					a=imread('face.jpg');
					image(a)
					return
				end
				Yv=Yv+a*dt/(Yv+a*dt)*(yc-r);
				Yv=-Yv*e;
				yt=get(h1,'ydata');
				xxt=get(h1,'xdata');
				ys=sort(yt);
				xr=xxt((ismember(yt,ys(1:10)))==1);
				xrp=str2num(get(dummy1,'string')); %#ok
				set(dummy1,'string',mat2str(xr));
				Xv=Xv*f;
				rot2=rot/10+Xv/r*100;				
				Xv=Xv+rot/250;
				rot=rot2;
				% rot=sqrt(10*a*hg/7/r^2)*10;
				if ~isempty(xrp) && sign(Xv+~sign(Xv))*max(xrp)>min(xr)*sign(Xv+~sign(Xv)) 
					newy=get(pl,'ydata')-rand(size(get(pl,'ydata')))/10*abs(Yv);
					newy(1)=0;
					newy(end)=0;
					set(pl,'ydata',newy);					
				else					
					sar=zeros(1,8)-(rand(1,8).*(1-f).*abs(Yv));
					ltt=line([min(xr) max(xr)],[0 0]);
					set(ltt,'linewidth',3,'color','w')
					pl=plot(sort(xr),[zeros(1,length(xr)-9),sar,0]);
					set(pl,'linewidth',2.5,'color','k')
				end				
 				yt((ismember(yt,ys(1:10))))=yt((ismember(yt,ys(1:10))))+...
					transpose(rand(1,length(yt((ismember(yt,ys(1:10)))))).*(1-f).*abs(Yv));
				set(h2,'ydata',r)				
				set(h1,'ydata',yt)
				am =[
					0    0    0    0    0    1    1    0    0    0    0    0    0    0    0    0    0    1    1    0    0    0    0    0    0
					0    0    0    0    1    1    1    1    0    0    0    0    0    0    0    0    1    1    1    1    0    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    1    1    1    1    1    1    0    0    0    0    0    0    1    1    1    1    1    1    0    0    0    0
					0    0    0    0    1    1    1    1    0    0    0    0    0    0    0    0    1    1    1    1    0    0    0    0    0
					0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    0    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    0    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    1    0    0    0    0    1    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    1    0    0    0    0    1    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    0    0    0    0    0    0    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    0    0    0    0    0    0    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    0    0    0    0    0    0    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    1    1    1    1    1    1    1    1    1    1    0    0    0    0    0    0    0    0
					0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0    0					
					];
				am=[zeros(2,25);am;zeros(2,25)]; %#ok
				colormap([1 0 0;0 0 0])
				set(h1,'facecolor','r')
				c=15;
			else
				for k=1:2
					set(hb(k),'ydata',get(hb(k),'ydata')-Yv*dt)
				end
			end
			set(KE,'xdata',get(KE,'xdata')+Xv*dt)
			set(hb(1),'xdata',get(hb(1),'xdata')+Xv*dt)
			set(hb(2),'xdata',get(hb(2),'xdata')+Xv*dt)
			l=axis;
			if get(h2,'xdata')>l(2)-r && Xv>0
				xlim([hx(1),hx(2)]+l(2))
			end
			if get(h2,'ydata')>l(4)-r && Yv<0
				ylim([hx(3),hx(4)]+l(4))
			end
			if get(h2,'xdata')<l(1)+r && Xv<0
				xlim([l(1),l(2)]-(hx(2)-hx(1)))
			end			
			if get(h2,'ydata')<l(3)+r && Yv>0
				ylim([l(3),l(4)]-(hx(4)-hx(3)))
			end
			ccc=(max(get(h1,'ydata'))+min(get(h1,'ydata')))/2;
			ccc2=(max(get(h1,'xdata'))+min(get(h1,'xdata')))/2;
			ll=ll+rot;
			delete(KE)
			KE=surface(flipud(am),'facecolor','texturemap','xdata',linspace(ccc2-r/2,ccc2+r/2,...
				25),'ydata',linspace(ccc-r/2,ccc+r/2,25),'edgecolor','none');
			rotate(KE,[0 0 1],-ll,[ccc2 ccc 1])
			rotate(h1,[0 0 1],-rot,[ccc2,ccc 1])
			drawnow()
		end
	end
end