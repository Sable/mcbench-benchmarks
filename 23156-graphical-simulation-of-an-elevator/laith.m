function laith()
% LAITH Graphical Simulation of an elevator system
% laith() creates a GUI with the number of floors as input. Granting this number
% creates a building with this number of floors and an elevator that moves up
% and down in it according to the will of animated people (modeled as balls).
%
% To run, type laith in the command window or press F5 from this editor window.
% 
% Laith Alkurdi is the name of a friend who worked with me on the code.
%
% Husam Aldahiyat
% Feb. 2009
% numandina@gmail.com
%
%
%% Creating Figure and Uicontrols
% create figure
figure('units','normalized','position',[.1 .1 .8 .8],'color',[1 1 1],...
	'menubar','none','numbertitle','off','name','Elevator')

% create axes
axes('position',[.35 .1 .65 .9])

% create pushbutton (Start)
pb=uicontrol('style','pushbutton','units','normalized','position',...
	[.1 .5 .04 .025],'backgroundcolor',[1 1 1],'string','Start',....
	'fontweight','bold','callback',@dogo);

% create edit box
ed2=uicontrol('style','edit','units','normalized','position',[.1 .525 .04 .025],...
	'backgroundcolor',[1 1 1],'fontweight','bold');

% create text (Floors)
uicontrol('style','text','units','normalized','position',[.1 .55 .04 .025],...
	'backgroundcolor',[1 1 1],'string','Floors','fontweight','bold')

% creates debug text 
tee=uicontrol('style','text','foregroundcolor',[1 0 0],'units','normalized',...
	'position',[.025 .6 .25 .35],'backgroundcolor',[0 0 0],'max',2,'fonts',15,...
	'fontname','courier');

% this is so the the floor numbers on the z-axis will have dotted lines
% showing their connection to the elevator
grid on

% initially, we can't see the axes
axis off

% this is just so we can move the camera around during play
rotate3d

%% Drawing the Elevator
% when we press the pushbutton we go here
	function dogo(varargin)
		
		% if we press the 'Start' button, change its string to 'Stop'
		if strcmp(get(pb,'string'),'Start')
			set(pb,'string','Stop')
		else
			
			% if we press the 'Stop' button, change its string to 'Start' and
			set(pb,'string','Start')
			
			% clear the axes
			cla
			
			% and halt operation
			return
		end
		
		% make axes appear
		axis on
		
		% clear debugging text
		set(tee,'string','')
		
		% get number of floors and turn it from string to number
		flrz=str2double(get(ed2,'string'));
		
		% check input
		if flrz < 2
			errordlg('Number of floors needs to be at least 2','Stupid!')
			set(pb,'string','Start')
			return
		end
		
		% this is compensated later by adding 1 to flrz
		% it's stupid but I like to do things like this
		flrz=flrz-1;
		
		% the following (a) and (b) matrices are very important. they create our
		% 'cube' shape.
		% the first column of (a) determines the min and max values for the (x),
		% the second for (y) and third for (z). So initially we have a unit cube
		% because the min and max for (x),(y) and (z) are (0) and (1).
		a= [0 0 0;
			1 0 0;
			1 1 0;
			0 1 0;
			0 0 1;
			1 0 1;
			1 1 1;
			0 1 1];
		
		% this (b) matrix specifies the faces of said cube. The cube has six faces
		% and eight vertices (points). the first row of (b) specifies which points
		% of (a) lie on the [b] face. 
		% For example, the first face is (1,2,6,5), which are the rows of (a).
		% This mean the points [0,0,0],[1,0,0],[1,0,1] and [0,0,1] lie on the
		% first face, and so on.
		b= [1 2 6 5;
			2 3 7 6;
			3 4 8 7;
			4 1 5 8;
			1 2 3 4;
			5 6 7 8];
		
		% we want to make the elevator shaft first.
		ac=a;
		
		% take the max for (z) and multiply it by the number of floors. I have
		% decided that each floor is (0.2) high.
		ac(5:8,3)=.2*(flrz+1);
		
		% make the 3D patch that has height of the number of floors. this will act
		% as the elevator shaft, or building which our elevator will move
		% through in.
		% the facealpha makes the shaft kind of transparent so you would see the
		% people inside
		patch('vertices',ac,'faces',b,'edgecolor','k','facecolor',[.3 .3 .3],...
			'facevertexalphadata',0.5,'facealpha','flat');
		
		% next we make the elevator itself
		c=a;
		
		% for this, just make the (z) column of (a) from (0) to (0.2),
		% this means our elevator is placed initially between (0) and (0.2)
		% in the (z) axis
		c(:,3)=c(:,3).*.2;
		
		% create our elevator!
		elv=patch('vertices',c,'faces',b,'edgecolor','w','facecolor',[0 0 1],...
			'facevertexalphadata',0.3,'facealpha','flat');
		
		% next we will make the two elevator doors		
		c1=a;
		
		% the (x) of these doors is zero (flat!)
		c1(:,1)=c1(:,1).*0;
		
		% the (z) is the same as the elevator
		c1(:,3)=[0;0;0;0;.2;.2;.2;.2];
		
		% for the first door, the (y) goes from (0) to (0.5)
		c1(:,2)=c1(:,2).*.5;
		
		% create door number one!
		door1 = patch('vertices',c1,'faces',b,'edgecolor','k','facecolor',...
			[0 0 .8],'facevertexalphadata',1,'facealpha','flat','linewidth',2);
		
		% same thing for our second door
		c2=a;
		
		% flat (x)
		c2(:,1)=c2(:,1).*0;
		
		% (z) from (0) to (0.2)
		c2(:,3)=[0;0;0;0;.2;.2;.2;.2];
		
		% (y) from (0.5) to (1)
		c2(:,2)=c2(:,2).*.5+.5;
		
		% create second door!
		door2 = patch('vertices',c2,'faces',b,'edgecolor','k','facecolor',[0 0 1],'facevertexalphadata',1,'facealpha','flat',...
			'linewidth',2);
		
		% next we want to make flat surfaces for each ground as a reference
		
		% for each floor go through the loop
		for jk=1:flrz+1
			
			pk=a;
			
			% make the (z) equal a number multiple of (0.2)
			% since the min and max of (z) are the same, the resulting surface
			% is flat
			pk(:,3)=repmat(.2*(jk-1),8,1);
			
			% create this floor
			patch('vertices',pk,'faces',b,'edgecolor','k','facecolor','k','facevertexalphadata',0.9,'facealpha','flat');
			
		end
		
		% by now we'll have a transparent elevator shaft with floors and an
		% elevator inside. we'll next want to cover one of the shaft sides with
		% a kind of curtain patch right above and below the elevator.
		% to do this, we will create two patches, one right above the elevator
		% and extends to the roof, while the other will have a min of the ground
		% and a max of the lower limits of our elevators.
		% these two patches will have the cyan face colour
		
		% flat (x)
		ar=[0 0 0;
			0 0 0;
			0 1 0;
			0 1 0;
			0 0 1;
			0 0 1;
			0 1 1;
			0 1 1];
		
		% max (z) depends on number of floors
		ar(5:8,3)=.2*(flrz+1);
		
		% for our first patch, min (z) stays at (0), while max (z) changes with
		% the min height of the elevator, so initially, max (z) is (0)
		
		af1=ar;
		af1(5:8,3)=repmat(0,4,1);
		fp1=patch('vertices',af1,'faces',b,'edgecolor','k','facecolor','c',...
			'facevertexalphadata',1,'facealpha','flat');
		
		% for our second patch, max (z) stays at the roof, while min (z) changes
		% with elevator max height. initially, min (z) is (0.2)
		af2=ar;
		af2(1:4,3)=repmat(0.2,4,1);
		fp2=patch('vertices',af2,'faces',b,'edgecolor','k','facecolor','c',...
			'facevertexalphadata',1,'facealpha','flat');
		
		%  next we'll mark the (z) axis with labels indicating the floor names
		FN=cell(flrz+1,1);
		for kkp=1:flrz+1
			FN{kkp}=['Floor ',num2str(kkp)];
		end
		
		% by now we have a cell (FN) containing strings for the floors numbers,
		% so we then set the (z) tick label as this string, and the (z) ticks
		% as multiples of (0.2)
		set(gca,'zticklabel',FN,'ztick',.1:.2:(flrz+1)*.2)
		
		% hide (x) and (y) ticks
		set(gca,'xtick',[]);
		set(gca,'ytick',[]);
		
		% the following are saved points that will be used later (kind of like
		% lookup table)
		
		% first are the co-ordinates for the points -inside- the elevator
		in={[.25 .1];[.35 .1];[.5 .1];[.65 .1];[.8 .1];[.925 .1]};
		
		% these are the co-ordinates for the points outside the elevator after
		% getting out from it
		out={[-.2 .925];[-.2 .75];[-.2 .575];[-.2 .425];[-.2 .275];[-.2 .125]};
		
		% points outside the elevator waiting to get inside it
		toin={[-.2 .1];[-.2 .25];[-.2 .4];[-.2 .55];[-.2 .7];[-.2 .85]};
		
		% run function (do1)
		do1
		
		function do1()
			
			% create the ground (lobby)
			
			% the groud axis limits
			v(1)=-.25;
			v(2)=1;
			v(3)=0;
			v(4)=1;
			
			% (z) is (0) and flat, (y) is same as elevator shaft, while (x) min
			% is slightly lower (so the ground would appear sticking out)
			aaa=[v(1) v(3) 0;
				v(2) v(3) 0;
				v(2) v(4) 0;
				v(1) v(4) 0;
				v(1) v(3) 0;
				v(2) v(3) 0;
				v(2) v(4) 0;
				v(1) v(4) 0];
			b=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
			
			% create the ground!
			patch('vertices',aaa,'faces',b,'edgecolor',[1 1 1],'facecolor',...
				[.3 .3 .3],'facevertexalphadata',0.5,'facealpha','flat');
			
			% set proper view (3D)
			view(3)
			
			% current floor is (0)
			cf=0;
			
			% dummy variable, means nothing
			dumnop=4;

			% choose number of balls randomly from (1) to (6)
			num=floor(6*rand)+1;
			
			% create these balls (people)
			createballs(num)
			
			% counter to be used later
			countz=0;
			
			% choose heading floor randomly between (2) and max number of floors
			tofloor=floor(rand*(flrz))+1;
% 			
% [pa1,pa2,aa,aa1,aa2,aa3,ha]=pigeon(.05);
% 			function movp(varargin)
% 				
% 				for kkl=1:length(ha)
% 					set(ha(kkl),'zdata',get(ha(kkl),'zdata')+.5)
% 					set(ha(kkl),'ydata',get(ha(kkl),'ydata')+.5)
% 					set(ha(kkl),'xdata',get(ha(kkl),'xdata')-.5)
% 				end
% 				ppI=get(pa1,'vertices');
% 				ppII=get(pa2,'vertices');
% 				ppI(:,3)=ppI(:,3)+.5;
% 				ppI(:,2)=ppI(:,2)+.5;
% 				ppI(:,1)=ppI(:,1)-.5;
% 				ppII(:,3)=ppII(:,3)+.5;
% 				ppII(:,2)=ppII(:,2)+.5;
% 				ppII(:,1)=ppII(:,1)-.5;
% 				
% 				aa2(:,1)=aa2(:,1)-.5;
% 				aa2(:,2)=aa2(:,2)+.5;
% 				aa2(:,3)=aa2(:,3)+.5;
% 				aa1(:,1)=aa1(:,1)-.5;
% 				aa1(:,2)=aa1(:,2)+.5;
% 				aa1(:,3)=aa1(:,3)+.5;
% 				aa3(:,1)=aa3(:,1)-.5;
% 				aa3(:,2)=aa3(:,2)+.5;
% 				aa3(:,3)=aa3(:,3)+.5;
% 				aa(:,1)=aa(:,1)-.5;
% 				aa(:,2)=aa(:,2)+.5;
% 				aa(:,3)=aa(:,3)+.5;
% 				
% 				aa
% 				aa1
% 				aa2
% 				aa3
% 				
% 				get(pa1,'faces')
% 				for kk=1:2
% 					set(pa1,'vertices',aa2)
% 					set(pa2,'vertices',aa3)
% 					pause(.1)
% 					set(pa1,'vertices',aa)
% 					set(pa2,'vertices',aa1)
% 					pause(.1)
% 				end
% 				
% 
% 			end
%% Main Loop
			% while 'Stop' pushbutton has not yet been pressed
			while strcmp(get(pb,'string'),'Stop')
				
				% increment counter
				countz=countz+1;
				
				% choose speed for opening the door
				dspeed=.1;
				
				% open door
				opend(dspeed)
				
				% move balls inside
				for j=1:num
					
					% move each ball from its location (toin) to its heading
					% point (in)
					hs(j)=movb(rz(j),toin{j},in{j},rand*10+15,j,hs(j)); %#ok
				end
		
				% choose speed for closing the door
				dspeed=.1;
				
				% close door
				closed(dspeed)
				
				% choose speed of going up
				upspeed=.035;
				
				% update debugging text
				set(tee,'string',{['Number of Stops: ',num2str(countz)];...
					sprintf('Current Stop: Floor %d',tofloor+1);...
					['Number of Dudes: ',num2str(num)]})
% 				movp
				% have elevator go up from (cf) to (tofloor) with speed
				% (upspeed) and ball handles (hs)
				cf=goup(upspeed,tofloor,cf,hs);
				
				% choose speed of door opening again
				dspeed=.075;
				
				% open door
				opend(dspeed)
				
				% next we'll want to move each ball outside the elevator
				% also, we want to get their handles
				
				% preallocation
				todel=zeros(1,num*2);				
				
				% for each ball go once around the loop
				for kmpf=1:num
					
					% move ball outside its location to (out) and draw virtual
					% ground (patch) and get the patche's handle
					[hs2,pn]=movb(rz(num),dumnop,out{kmpf},20,kmpf,hs(kmpf));
					
					% store handles for each ball and ground here
					todel(kmpf*2-1:kmpf*2)=[hs2,pn];
				end
				
				% now it's time to make the balls and patches gradually
				% disappear
				
				% initial transperancy is (0.5)
				for k=.5:-.075:0
					
					% gradually lower the transperancy of everything (every
					% handle) in (todel)
					set(todel,'facealpha',k,'edgealpha',k)					
					pause(.05)
					
				end
				
				% finally after everything is completely transparent, delete it
				delete(todel)
				
				% choose speed for closing the door
				speedc=.075;
				
				% close doors
				closed(speedc)
				
				% choose a new number of dudes from (1) to (6)
				num=floor(6*rand)+1;
				
				% choose a new floor number from (2) to number of floors
				tofloor=floor(rand*(flrz))+1;
				
				% update debugger text
				set(tee,'string',{['Number of Stops: ',num2str(countz)];...
					sprintf('Current Stop: Floor %d',tofloor+1);...
					['Number of Dudes: ',num2str(num)]})
				
				% create the balls (people)
				createballs(num)
				
				% choose speed to returning the elevator to the ground
				speedret=.035;
				
				% return elevator to the ground
				cf=retn(speedret,cf);
				
			end
			
%% Create Balls
			function createballs(num)
				
				% choose random radii for each ball (fat, tall, young, etc...)
				% from (0.02) to (0.05)
				rz=rand(num,1).*.03+.02;
				
				% next we create the balls by moving them from (toin) to (toin)
				hs=zeros(num,1);
				for n2=1:num
					hs(n2)=movb(rz(n2),toin{n2},toin{n2},10,n2);
				end
			end
			
		end
		
%% Raising the Elevator
		function cf=goup(inc_speed,floor,cf,hs)
			
			% counter for use later
			cc=1;
			while true
				
				% condition for stopping the elevator: next elevtor position
				% (indicated by current position + speed) is higher than
				% required floor, in which case, set the position of the
				% elevator as the next floor minimum coordinate
				if min(c(:,3))+inc_speed>floor*.2
					
					% min (z) of elevator is same as floor height
					c(1:4,3)=repmat(floor*.2,4,1);
					
					% max (z) of elevator is same as floor ceiling (next floor)
					c(5:8,3)=repmat(floor*.2+.2,4,1);
					
					% move elevator to this position
					set(elv,'vertices',c)
					
					% do the same thing for the elevator doors
					c1(1:4,3)=repmat(floor*.2,4,1);
					c1(5:8,3)=repmat(floor*.2+.2,4,1);
					c2(1:4,3)=repmat(floor*.2,4,1);
					c2(5:8,3)=repmat(floor*.2+.2,4,1);
					set(door1,'vertices',c1)
					set(door2,'vertices',c2)
					
					% also move the curtains in the same way
					af1=get(fp1,'vertices');
					af1(5:8,3)=repmat(floor*.2,4,1);
					af2=get(fp2,'vertices');
					af2(1:4,3)=repmat(.2+floor*.2,4,1);
					set(fp1,'vertices',af1)
					set(fp2,'vertices',af2)
					
					% and move the balls as well
					for k=1:length(hs)
						ppv=get(hs(k),'zdata');
						set(hs(k),'zdata',ppv+floor*.2-min(min(ppv)))
					end
					
					% update plot
					drawnow()
					
					% leave loop
					break
				end
				
				% increment counter
				cc=cc+1;
				
				% increase height of elevator (z) by its speed
				c(:,3)=c(:,3) + inc_speed;
				set(elv,'vertices',c)
				
				% same with doorsw
				c1(:,3)=c1(:,3) + inc_speed;
				c2(:,3)=c2(:,3) + inc_speed;
				set(door1,'vertices',c1)
				set(door2,'vertices',c2)
				
				% change the height of curtains in the same way
				af1=get(fp1,'vertices');
				af1(5:8,3)=repmat(0+cc*inc_speed+cf*.2,4,1);
				af2=get(fp2,'vertices');
				af2(1:4,3)=repmat(0.2+cc*inc_speed+cf*.2,4,1);
				set(fp1,'vertices',af1)
				set(fp2,'vertices',af2)
				
				% increase the height of the balls as well
				for k=1:length(hs)
					set(hs(k),'zdata',get(hs(k),'zdata')+inc_speed)
				end
				
				% update plot
				drawnow()
								
			end
			
			% update floor number (output)
			cf=floor;
		end

%% Returning the Elevator
		function cf=retn(inc_speed,cf)
			
			% counter
			cc=1;
			
			% destination floor
			floor=0;
			
			% the following is the same as raising the elevator, with the
			% replacement of a few addition with subtractions
			while true
				
				if min(c(:,3))-inc_speed<floor*.2
					
					c(1:4,3)=repmat(floor*.2,4,1);
					c(5:8,3)=repmat(floor*.2+.2,4,1);
					set(elv,'vertices',c)
					
					c1(1:4,3)=repmat(floor*.2,4,1);
					c1(5:8,3)=repmat(floor*.2+.2,4,1);
					c2(1:4,3)=repmat(floor*.2,4,1);
					c2(5:8,3)=repmat(floor*.2+.2,4,1);
					set(door1,'vertices',c1)
					set(door2,'vertices',c2)
				
					af1=get(fp1,'vertices');
					af1(5:8,3)=repmat(floor*.2,4,1);
					af2=get(fp2,'vertices');
					af2(1:4,3)=repmat(.2+floor*.2,4,1);
					set(fp1,'vertices',af1)
					set(fp2,'vertices',af2)
					drawnow()
					break
				end
				cc=cc+1;
				c(:,3)=c(:,3) - inc_speed;
				set(elv,'vertices',c)
				
				c1(:,3)=c1(:,3) - inc_speed;
				c2(:,3)=c2(:,3) - inc_speed;
				set(door1,'vertices',c1)
				set(door2,'vertices',c2)
				
				af1=get(fp1,'vertices');
				af1(5:8,3)=repmat(0-cc*inc_speed+cf*.2,4,1);
				af2=get(fp2,'vertices');
				af2(1:4,3)=repmat(0.2-cc*inc_speed+cf*.2,4,1);
				set(fp1,'vertices',af1)
				set(fp2,'vertices',af2)
				drawnow()
				
				
			end
			cf=floor;
		end
		
%% Opening Elevator Doors
		function opend(dspeed)
			
			% get location information for both doors
			var1=get(door1,'vertices');
			
			% for use in the while loop that lies ahead
			y1=var1(:,2);
			var2=get(door2,'vertices');
			
			% loop until next location of first door is lower than its fully
			% opened location (y) = (0), in which case get out of the loop and
			% manually set both door locations
			while max(y1)-dspeed>0;
				
				% move both doors relative to the speed, in opposite directions
				var1([3,4,7,8],2)=var1([3,4,7,8],2)-dspeed;
				var2([1,2,5,6],2)=var2([1,2,5,6],2)+dspeed;
				set(door1,'vertices',var1)
				set(door2,'vertices',var2)
				
				% for the loop condition
				y1=var1(:,2);			
				
				% update plot
				drawnow()
			end
			
			% set both doors to fully open status
			var1(:,2)=zeros(8,1);
			var2(:,2)=ones(8,1);
			set(door1,'vertices',var1)
			set(door2,'vertices',var2)
			
			% update plot
			drawnow()
			
		end
		
%% Closing Elevator Doors
		function closed(dspeed)
			
			% very similar to opening the elevator doors, with subtraction
			% operation replacing the addition, as well as having the fully
			% closed conditions being one door having a maximum (y) of (0.5)
			% while the other has a minimum (y) of (0.5).
			var1=get(door1,'vertices');
			y1=var1(:,2);
			var2=get(door2,'vertices');
			while max(y1)+dspeed<0.5;
				var1([3,4,7,8],2)=var1([3,4,7,8],2)+dspeed;
				var2([1,2,5,6],2)=var2([1,2,5,6],2)-dspeed;
				y1=var1(:,2);
				set(door1,'vertices',var1)
				set(door2,'vertices',var2)
				drawnow()
			end
			var1([3,4,7,8],2)=repmat(.5,4,1);
			var2([1,2,5,6],2)=repmat(.5,4,1);
			set(door1,'vertices',var1)
			set(door2,'vertices',var2)
			drawnow()
			
		end

%% Moving the Balls
		function [h,pn]=movb(r,A,B,V,nm,varargin)
			
			% r: Radius of ball
			%
			% A: Starting position of centre of ball
			%
			% B: Ending position of centre of ball
			%
			% V: Speed of rotation
			%
			% nm: Number denoting the colour
			%
			% varargin: Could contain handle of previously created ball
			
			% so previous plots would not disappear
			hold on
			
			% if no previous ball is created (i.e. we want to create instead
			% of move)
			if ~numel(varargin)
				% create unit ball
				[a,b,cC2]=sphere(25);
				
				% adjust size of ball by multiplying by the radius
				% also, move ball to starting position by adding
				% and put ball on the ground (0z) by adding r to z
				h=surf(a.*r+A(1),b.*r+A(2),cC2.*r+r);
				
				% make colors cooler
				set(h,'facecolor','interp','edgecolor','interp')
				
				% get ball colour data
				s2=get(h,'cdata');
				
				% take the ball top and change its colour to something
				% now each ball has a cute little colourful hat!
				s2(end-3:end,:)=repmat(.15*nm,4,size(s2,2));				
				set(h,'cdata',s2)
				
				% adjust axis for better viewing
 				axis equal

			end
			
			% for future reference
			v=axis;
			
			% for while loop initial status
			ctr=[1e9 1e9];
			
			% move ball
			if numel(varargin)

				% get handle of ball
				h=varargin{1};
				
				% create a patch that spans the axis edges (acts as ground)
				% (z) is flat, and depends on the ball's min (z)				
				pft=min(min(get(h,'zdata')));
				aaa=[v(1) v(3) pft;
					v(2) v(3) pft;
					v(2) v(4) pft;
					v(1) v(4) pft;
					v(1) v(3) pft;
					v(2) v(3) pft;
					v(2) v(4) pft;
					v(1) v(4) pft];
				b=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
				
				% plot ground!
				pn=patch('vertices',aaa,'faces',b,'edgecolor',[1 1 1],'facecolor',[.3 .3 .3],...
					'facevertexalphadata',0.5,'facealpha','flat');
			end
			
			% get min (z) of ball (i.e. get the current floor)
			llpp=get(h,'zdata');
			cf=min(min(llpp));
			
			% while centre of the ball is at least .1 away from
			% the destination points, keep moving it. notice here that the
			% condition for stopping the ball movement doesn't depend on the
			% next location, but rather on the current location. this leads to
			% the balls to end up in slightly different locations that their
			% destinations, due to the randomization of the ball radius coupled
			% with their relatively high speeds
			while mean(abs(ctr-B))>1e-1
				
				% get centre of ball
				ctr=[(max(max(get(h,'xdata')))+min(min(get(h,'xdata'))))/2,...
					(max(max(get(h,'ydata')))+min(min(get(h,'ydata'))))/2];
				
				% vector from current point to destination
				rot=B-ctr;
				
				% get orthogonal vector (which the ball will spin around)
				yu=rot(2);
				rot(2)=rot(1);
				rot(1)=-yu;
				
				% rotate around ball about said vector
				% origin is centre of ball
				rotate(h,[rot,0],V,[ctr,r+cf])
				
				% move ball according to its speed
				% the sign commands are for the direction of movement
				% the sphere moves in X and Y the same distance as the one it has rolled
				% in other words it moves V/360
				% but it doesn't move the entirety of this roll since it is divided between
				% X and Y rolling, we find out how much is shared between X and Y using atan
				set(h,'xdata',get(h,'xdata')...
					-(sign(rot(1))-~sign(rot(1)))...
					*V/360*...
					atan(rot(2)/-rot(1)))
				set(h,'ydata',get(h,'ydata')+(sign(rot(2))+sign(rot(2)))*V/360*atan(rot(1)/-rot(2)))
				
				% so that axis wouldn't change while animating
				axis(v)
				
				% update plot
				drawnow()
			end
		end
	end
% EOF
end
