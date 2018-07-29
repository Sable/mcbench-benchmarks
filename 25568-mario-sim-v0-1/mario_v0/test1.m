clear; clc;
load mariodata;

global H;
global A;
global mario;
global dxnkey;
global dxnpressed;
global shiftpressed;
global spacepressed;
global spacetime;
dxnpressed=0;
shiftpressed=0;
spacepressed=0;
dxnkey='';


timeout	= 30;	% duration of sim (sec)
% rfrsh	= 1/60;	% NTSC refresh rate (sec)
rfrsh	= 1/10;	% refresh rate that works for now (want better rate)
scale	= 1;	% 


%SETUP FIGURE:
figure(1); clf; 
hold on;
gnd=patch([0 0 10000 10000 0],[-20 0 0 -20 -20],7);
set(gca,'YTick',[],'XTick',[],'Color',[0.3 0.6 0.94]);
plot3([0 1000],[0 0],[-1 -1],'k','LineWidth',2);
axis([0 400 -20 200]);
set(gcf,'keypressfcn',@keypress,'keyreleasefcn',@keyrelease,'WindowButtonUpFcn','');
axis equal;

%INITIALIZE SPRITE PATCHES:
maxdims = [32 17]; %sprite dimensions
colormap(clrs);
for i=1:maxdims(1)	%rows
	for j=1:maxdims(2)	%cols
		H(i,j)=patch([-1 -1 0 0 -1]+j,[-1 0 0 -1 -1]+i,0,'FaceAlpha',0);
	end;
end;
shading flat;
ttl = title(sprintf('TIME\n%03.0f',max(timeout,0)),'FontWeight','bold','Color',[1 1 1],'FontSize',14,'FontName','Monotxt','HorizontalAlignment','right','Position', [390,150,1]);


%INITIAL STATE:
%states:	1:small, 2:big, 3:firepower
%actions:	1:stand, 2:run, 3:jump, 4:duck, 5:skid, 6:climb, 7:switm, 8:shoot, 9: die
%dxns:		1:right, 2:left
state	= 3;		%current character state
dxn		= 1;		%current character direction
action	= 1;		%current character action
iter	= 1;		%frame within current action
loc		= [0 0];	%initial position
spd		= [0 0];	%current x and y speed
spdlim	= [8 18];	%magnitude of max speed in x and y
acc		= [0 0];	%current x and y acceleration
updatesprite(state,dxn,action,iter,[0 0])

%REMINDER:
%states:	1:small	2:big  3:firepower
%dxns:		1:right 2:left
%actions:	1:stand 2:walk 3:jump 4:duck 5:skid 6:climb 7:swim 8:shoot 9:die


%MAIN LOOP:
tic;
tnext=0;
t=toc;
while toc<timeout,
	%DIRECTION COMMANDED:
	if dxnpressed,				%accelerate
		if dxnkey(1)=='d'	%user pressed down (duck)
			action=4;
			if spd(1)==0	%stay at rest
				acc(1)=0;
			else
				acc(1) = -sign(spd(1))*ceil(abs(spd(1)/2)); %decellerate
			end;
			
		elseif dxnkey(1)=='r'		%accelerate right
			acc(1) = 2*(spd(1)<spdlim(1));
			if spd(1)<0			%skidding turn left to right
				action	= 5;
				dxn		= 2;
			else				%running right
				action	= 2;
				dxn		= 1;
			end;
			
		elseif dxnkey(1)=='l'	%accelerate left
			acc(1) = -2*(spd(1)>-spdlim(1));
			if spd(1)>0			%skidding turn right to left
				action	= 5;
				dxn		= 1;
			else				%running left
				action	= 2;
				dxn		= 2;
			end;
		end;	
	%NO ARROWS PRESSED: slow to rest
	else
		if spd(1)==0	%stay at rest
			acc(1)=0;
			action=1;
		else
			acc(1) = -sign(spd(1))*ceil(abs(spd(1)/2)); %decellerate
		end;
	end;
	
	%SHOOTING:
	if state==3 && shiftpressed,
		action=8;
	end;
	
	%Jumping:
	if spacepressed && loc(2)==0,
		spacepressed = 0;
		acc(2)=-3;
		spd(2)=18;
	end;
	
	%UPDATE POSITION:
	spd = round(spd+acc);
	loc = loc+spd;
	
	%end jump?
	if loc(2)<=0 && spd(2)<0	%end jump
		loc(2)=0;
		spd(2)=0;
		acc(2)=0;
		if dxnkey(1)=='l' || dxnkey(1)=='r' %end running
			action=2;
		elseif dxnkey(1)=='d'				%end ducking
			action=4;
		end;
	elseif loc(2)>0
		if action==4 || action==8 %jumping stance unless ducking or shooting
		else
			action=3;	%airborne stance
		end;
	end;
		
	
	%INCREMENT FRAME OF CURRENT ACTION:
	if action==2,
		if iter==1, iter=3;
		else iter=iter-1;
		end;
	elseif sum(action==[1 3 4 5 7 9])
		iter=1;
	end;
	
	%UPDATE FIGURE:
	updatesprite(state,dxn,action,iter,loc)
	axis([0 400 -20 200])
	set(ttl,'String',sprintf('TIME\n%03.0f',max(timeout-toc,0)));
	drawnow;


	%CONTROL REFRESH RATE:
% 	tnext	= tnext+rfrsh;
% 	t=toc;
% 	txtra	= tnext-t;
% 	if txtra>0,
% 		pause(txtra);
% 		disp('paused');
% 	else
% 		disp([t,tnext,txtra])
% 	end;
end;


%DEATH
ylims = get(gca,'YLim');
spd=[0 12];
acc=[0 -3];
updatesprite(1,1,9,1,loc);
pause(1);
while loc(2)>ylims(1)-30
	spd(2)=max(spd(2)+acc(2),-spdlim(2)); %terminal velocity
	loc=loc+spd;
	updatesprite(1,1,9,1,loc);
	drawnow;
end;

clf;
plot(0,0); 
set(gca,'Color','k','XTick',[],'YTick',[],'ButtonDownFcn','test1');
text(140,100,'click to continue','Color','w','FontSize',18);
axis([0 400 -20 200],'equal');

