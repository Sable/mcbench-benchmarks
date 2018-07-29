function mquake(h,int,dur,op1,op2)
% MQUAKE Matlab earthquake
% -------------------------------------------------------------------------------------
% mquake(h,int,dur,op1,op2) Randomly vibrates graphical objects, where:
% 
% h:      Handle of required object(s) (scalar or vector)
% 
% int:    Intensity of vibration (scalar)
% 
% dur:    Duration of vibration in seconds (estimate, scalar)
% 
% op1:     1 -> Object returns to starting position at the end
%          0 -> Object ends up where earthquake lands it
%
% op2:     1 -> Confine object to screen limits
%          0 -> Vibrate freely
%
% Setting OP2 to 1 will confine the vibrating object to its container's
% limits. It confines a figure to the screen limits, and confines axes and
% uicontrols to the limits of the figures containing them.
% 
% + Example 1:
% % Vibrate figure (Highlight and press F9 to run)
% 
% t=0:.1:4;
% y=cos(t);
% plot(t,y)
% mquake(gcf,2,5,0,1)
% 
% 
% + Example 2:
% % Vibrate uicontrol (Highlight and press F9 to run)
% 
% h=uicontrol('style','pushbutton','callback','mquake(h,.25,.5,1,1)','string','Press Me!');  
% 
% 
% + Example 3:
% % Observe the effect of confinement (Highlight and press F9 to run)
% 
% h=uicontrol('style','pushbutton','callback','mquake(h,9,5,1,1)','string','Press Me!');  
% 
% 
% + Example 4:
% % Vibrate Line (Highlight and press F9 to run)
% 
% plot(1:9,rand(1,9),1:9,rand(1,9))
% set(findobj('type','line'),'linewidth',3)
% axis([0 10 -1 2])
% mquake(findobj('color','b'),3,5,1)
% 
% 
% + Example 5:
% % Vibrate multiple figures (Highlight and press F9 to run)
% 
% a=zeros(1,5);
% for k=1:5
%     a(k)=figure('menubar','none');
% end
% mquake(a,2.5,10,0,1)
% close(a)
%
%
% + Example 6:
% % Explosion (Highlight and press F9 to run)
%
% uicontrol('style','pushbutton','callback','mquake(gca,.25,.5,1,1)','string','Press Me!');
% -------------------------------------------------------------------------------------
% 
% Tested on MATLAB R2007a (7.4)
% 
% Husam Aldahiyat, Jan, 2009
% numandina@gmail.com
% Version 1.6

if nargin < 3
	error('MSG:ID3','Too few inputs; please Check input parameter documentation')
elseif nargin < 4
	op1=0;
	op2=1;
elseif nargin < 5
	op2=1;
end

if length([int, dur, op1, op2]) > 4
	error('MSG:ID1','Inputs for INT, DUR, OP1 and OP2 need to be scalars. Please read documentation.')
end

try 
	g=num2cell(get(h,'type'),2);
catch
	error('MSG:ID2','Handle object does not exist. Please check your input.')
end

if strcmp(g{1},'figure') || strcmp(g{1},'uicontrol') || strcmp(g{1},'axes') 
	
	set(h,'units','normalized')
	p=num2cell(get(h,'position'),2);
	tic
	while toc<dur		
		for k=1:length(g)
			if op1
				set(h(k),'position',p{k}+[(2*rand-1)*int/100 (2*rand-1)*int/100 0 0])				
			else
 				o=num2cell(get(h(k),'position'),2);
				set(h(k),'position',o{1}+[(2*rand-1)*int/100 (2*rand-1)*int/100 0 0])
			end
			if op2
				a=get(h(k),'position');
				tot=a(1:2)+a(3:4);
				if ~isempty(find(tot>1,1))										
					a(tot>1)=1-a(find(tot>1)+2);
					set(h(k),'position',a)
				end
				if ~isempty(find(a<0,1))										
					a(a<0)=0;
					set(h(k),'position',a)
				end
			end
		end
		drawnow()
	end
	
	if op1
		for k=1:length(g)
			set(h(k),'position',p{k})
		end
	end

else
	
	if size(get(h,'xdata'),1)==1
		p1{1}=get(h,'xdata');
	else
		p1=get(h,'xdata');
	end
	if size(get(h,'ydata'),1)==1
		p2{1}=get(h,'ydata');
	else
		p2=get(h,'ydata');
	end
	if size(get(h,'zdata'),1)==1
		p3{1}=get(h,'zdata');
	else
		p3=get(h,'zdata');
	end
	
	tic
	while toc<dur		
		for k=1:length(g)
			if op1
				set(h(k),'xdata',p1{k}+(2*rand-1)*int/100)
				set(h(k),'ydata',p2{k}+(2*rand-1)*int/100)
				set(h(k),'zdata',p3{k}+(2*rand-1)*int/100)
			else
				set(h(k),'xdata',get(h(k),'xdata')+(2*rand-1)*int/100)
				set(h(k),'ydata',get(h(k),'ydata')+(2*rand-1)*int/100)
				set(h(k),'zdata',get(h(k),'zdata')+(2*rand-1)*int/100)
			end
		end
		drawnow()
	end
	
	if op1
		for k=1:length(g)
			set(h(k),'xdata',p1{k})
			set(h(k),'ydata',p2{k})
			set(h(k),'zdata',p3{k})
		end
	end
	
end