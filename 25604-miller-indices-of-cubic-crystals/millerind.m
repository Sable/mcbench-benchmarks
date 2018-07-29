function millerind
	% MILLERIND Cubic Miller Indices Explanation GUI
	%
	% millerind() is a graphical user interface that gives a  simple method to
	% view and understand the underlying princples behind the Miller indices of
	% a cubic crystal.
	%
	% By entering a desired plane and pressing "Plot", the desired plane along
	% with its orthogonal vector is displayed on the crystal cube, and all
	% possible plane equivalents are shown. You can choose any of these planes
	% to have them being shown on the axes, or you can rotate the cube manually
	% and find out which equivalent plane results.
	%
	% To launch, simply type 'millerind' in your command window.
	% Alternatively, you can choose run from this editor window, or press 'F5'.
	%
	% Created with MATLAB R2008b (7.7), but should work on earlier versions.
	%
	% numandina@gmail.com Jordan 2009
	%
	
	global C til pl tl mp lp sp
	
	figure('color',[1,1,1],...
		'menubar','none',...
		'numbertit','off',...
		'name','Miller Indices')
	
	uipanel('un','n',...
		'pos',[.01 .05 .275 .925],...
		'backgroundc',[1,1,1])
	
	uipanel('un','n',...
		'pos',[.285 .775 .675 .2],...
		'backgroundc',[1,1,1])
	
	uipanel('un','n',...
		'pos',[.285 .05 .675 .725],...
		'backgroundc',[1,1,1])
	
	axes('un','n',...
		'pos',[0 -.1 1.2 1])
	
	uicontrol('sty','tex',...
		'un','n',...
		'pos',[.05 .8 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Enter Plane Index')
	
	e1 = uicontrol('sty','ed',...
		'un','n',...
		'pos',[.05 .77 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','',...
		'fontn','courier',...
		'fonts',12,...
		'fontw','b');
	
	uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.1 .7 .1 .05],...
		'backgroundc',[1,1,1],...
		'string','Plot',...
		'callback',@main)
	
	r1r = uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.3 .9 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Rotate about x',...
		'callback',@r1,...
		'visible','off');
	
	r2r = uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.525 .9 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Rotate about y',...
		'callback',@r2,...
		'visible','off');
	
	r3r = uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.75 .9 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Rotate about z',...
		'callback',@r3,...
		'visible','off');
	
	r1r2 = uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.3 .8 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Rotate about -x',...
		'callback',@r4,...
		'visible','off');
	
	r2r2 = uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.525 .8 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Rotate about -y',...
		'callback',@r5,...
		'visible','off');
	
	r3r2 = uicontrol('sty','pushbutton',...
		'un','n',...
		'pos',[.75 .8 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Rotate about -z',...
		'callback',@r6,...
		'visible','off');
	
	t1 = uicontrol('sty','text',...
		'un','n',...
		'pos',[.05 .6 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','X Planes Found',...
		'foregroundc',[0,.5,0],...
		'fontw','b',...
		'visible','off');
	
	uicontrol('sty','text',...
		'un','n',...
		'pos',[.05 .56 .2 .05],...
		'backgroundc',[1,1,1],...
		'string','Animation Speed',...
		'foregroundc',[0,0,0],...
		'fontw','b');
	
	l1 = uicontrol('sty','listbox',...
		'un','n',...
		'pos',[.025 .1 .25 .4],...
		'backgroundc',[1,1,1],...
		'fontname','courier',...
		'string',{'2 3 4';'3 2  1'},...
		'fonts',15,...
		'visible','off',...
		'callback',@liz);
	
	sd = uicontrol('style','slider',...
		'un','n',...
		'pos',[.0225 .525 .25 .05],...
		'min',10,...
		'max',210,...
		'value',120,...
		'sliderstep',[1/20,1/5],...
		'callback',@ups);
	
	axis off
	hold on
	
	function ups(varargin)
		sp = 220 - get(sd,'value');
	end
	
	function r1(varargin)
		rot(1,[1,0,0])
	end
	
	function r2(varargin)
		rot(1,[0,1,0])
	end
	
	function r3(varargin)
		rot(-1,[0,0,1])
	end
	
	function r4(varargin)
		rot(-1,[1,0,0])
	end
	
	function r5(varargin)
		rot(-1,[0,1,0])
	end
	
	function r6(varargin)
		rot(1,[0,0,1])
	end
	
	function rot(s,az)
		delete(findobj('type','text'));
		rotate([pl,tl,mp,lp],az,s*90,[0.5,0.5,0.5])
		p1 = str2num(get(e1,'string')); %#ok;
		
		x = get(tl,'xdata');
		y = get(tl,'ydata');
		z = get(tl,'zdata');
		
		v1 = [x(2)-x(1),y(2)-y(1),z(2)-z(1)];
		v1 = round(v1(~~v1)*abs(prod(p1(~~p1))));
		v1(end+1:3) = 0;
		v1 = round(v1/gcd(gcd(v1(1),v1(2)),v1(3)));
		
		X = v1(1);
		Y = v1(2);
		Z = v1(3);
		tlt = text('string',[' Plane (',num2str(X),' ',num2str(Y),...
			' ',num2str(Z),')'],'position',[1,.5,1.5]);
		set(tlt,'fontsize',12,'fontw','b')
		rotate([pl,tl,mp,lp],az,-s*90,[0.5,0.5,0.5])
		
		for t = 1:sp
			rotate([pl,tl,mp,lp],az,s*90/sp,[0.5,0.5,0.5])
			drawnow
		end
	end
	
	function liz(varargin)
		cla
		
		a = [0 0 0;...
			1 0 0;...
			1 1 0;...
			0 1 0;...
			0 0 1;...
			1 0 1;...
			1 1 1;...
			0 1 1];
		
		b=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
		mp = patch('vertices',a,...
			'faces',b,...
			'edgecolor',[0,0,0],...
			'facecolor',[.24 .24 .24]+.6,...
			'linewidth',2,...
			'facealpha',.5,...
			'linestyle','-');
		p1 = str2num(get(e1,'string')); %#ok;
		[kkk,lll] = unique(round(C*10000),'rows','first');
		
		if isequal((sort(abs(p1))),[0,1,1])
			lll = lll(7:12);
		end
		
		[rr1,rr2,rr3] = ind2sub([4,4,4],(lll));
		
		rr3=rr3-1;
		rr2=rr2-1;
		rr1=rr1-1;
		
		rr3(rr3 == 4) = 0;
		rr1(rr2 == 4) = 0;
		rr2(rr2 == 4) = 0;
		
		v = get(l1,'value');
		
		tlt = plot(0,0,'.','markersize',.0001);
		
		for kj = v:v
			
			delete(tlt)
			tlt = text('string',[' Plane (',num2str(til(kj,:)*1),')'],...
				'position',[1,.5,1.5]);
			
			set(tlt,'fontsize',12,'fontw','b')
			
			if sum(~~p1) == 3
				
				a = [0 0 1/p1(3);1/p1(1) 0 0;0 1/p1(2) 0];
				b=[1,2,3];
				
			elseif sum(~~p1) == 2
				
				if ~p1(3)
					
					a = ([0 1/p1(2) 1;1/p1(1) 0 1;1/p1(1) 0 0;0 1/p1(2) 0]);
					
				elseif ~p1(2)
					
					a = [0 0 1/(p1(3));1/p1(1) 0 0;1/p1(1) 1 0;0 1 1/(p1(3))];
					
				elseif ~p1(1)
					
					a = ([0 0 1/p1(3);0 1/p1(2) 0;1 1/p1(2) 0;1 0 1/p1(3)]);
					
				end
				
				b=[1,2,3,4];
				
			else
				
				a = [0 0 0;...
					1 0 0;...
					1 1 0;...
					0 1 0;...
					0 0 1;...
					1 0 1;...
					1 1 1;...
					0 1 1];
				
				B = [2,6,7,3;...
					4,8,7,3;...
					5:8;...
					1,4,8,5;...
					1,2,6,5;...
					1:4];
				
				c = find(p1);
				
				if p1(c) < 0
					c = c + 3;
				end
				
				b = B(c,:);
				
			end
			
			for k = 1:3
				if any(a(:,k) < 0)
					a(:,k) = a(:,k) + 1;
				end
			end
			
			lx = [0,p1(1)];
			ly = [0,p1(2)];
			lz = [0,p1(3)];
			
			ml = max(abs([lx,ly,lz]));
			lx = lx/ml + (1 - lx(1))*~(sign(p1(1))+1); % + ~sum(lx)*.5;
			ly = ly/ml + (1 - ly(1))*~(sign(p1(2))+1); % + ~sum(ly)*.5;
			lz = lz/ml + (1 - lz(1))*~(sign(p1(3))+1); % + ~sum(lz)*.5;
			
			tl = line(lx,ly,lz,...
				'color',[.25,.9,.5],...
				'linewidth',3);
			pl = plot3(lx(2),ly(2),lz(2),'.');
			set(pl,'color',[.25,.9,.5],...
				'markersize',20);
			lp = patch('vertices',a,...
				'faces',b,...
				'edgecolor','k',...
				'facecolor',[.94 .24 .24],...
				'linewidth',1,...
				'facealpha',1,...
				'linestyle','-');
			drawnow
			pause(.5)
			
			for ind = 1:rr3(kj)
				
				for t = 1:sp
					if rr3(kj) == 3
						rotate([pl,tl,mp,lp],[0,0,1],-90/sp,[0.5,0.5,0.5])
					else
						rotate([pl,tl,mp,lp],[0,0,1],90/sp,[0.5,0.5,0.5])
					end
					drawnow
				end
				
				if rr3(kj) == 3
					break
				end
				
			end
			
			for ind = 1:rr2(kj)
				
				for t = 1:sp
					
					if rr2(kj) == 3
						rotate([pl,tl,mp,lp],[0,1,0],-90/sp,[0.5,0.5,0.5])
					else
						rotate([pl,tl,mp,lp],[0,1,0],90/sp,[0.5,0.5,0.5])
					end
					drawnow
				end
				
				if rr2(kj) == 3
					break
				end
				
			end
			
			for ind = 1:rr1(kj)
				
				for t = 1:sp
					
					if rr1(kj) == 3
						rotate([pl,tl,mp,lp],[1,0,0],-90/sp,[0.5,0.5,0.5])
					else
						rotate([pl,tl,mp,lp],[1,0,0],90/sp,[0.5,0.5,0.5])
					end
					drawnow
				end
				
				if rr1(kj) == 3
					break
				end
				
			end
			
		end
		
	end
	
	function main(varargin)
		
		cla
		
		sp = 220 - get(sd,'value');
		
		a = [0 0 0;...
			1 0 0;...
			1 1 0;...
			0 1 0;...
			0 0 1;...
			1 0 1;...
			1 1 1;...
			0 1 1];
		
		
		b=[1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
		mp = patch('vertices',a,...
			'faces',b,...
			'edgecolor','k',...
			'facecolor',[.24 .24 .24]+.6,...
			'linewidth',2,...
			'facealpha',.5,...
			'linestyle','-');
		view(3)
		axis vis3d
		axis([-.5 1.5 -.5 1.5 -.5 1.5])
		
		p1 = str2num(get(e1,'string')); %#ok;
		
		if gcd(gcd(p1(1),p1(2)),p1(3)) ~= 1
			errordlg(['The greatest common divisor of the the plane''s',...
				' three elements needs to be 1'],'Error')
			error('err')
		end
		
		lx = [0,p1(1)];
		ly = [0,p1(2)];
		lz = [0,p1(3)];
		
		ml = max(abs([lx,ly,lz]));
		lx = lx/ml + (1 - lx(1))*~(sign(p1(1))+1); % + ~sum(lx)*.5;
		ly = ly/ml + (1 - ly(1))*~(sign(p1(2))+1); % + ~sum(ly)*.5;
		lz = lz/ml + (1 - lz(1))*~(sign(p1(3))+1); % + ~sum(lz)*.5;
		
		rotate3d on
		
		tl = line(lx,ly,lz,'color',[.25,.9,.5],'linewidth',3);
		pl = plot3(lx(2),ly(2),lz(2),'.');
		set(pl,'color',[.25,.9,.5],'markersize',20);
		
		hold on
		
		if sum(~~p1) == 3
			
			a = [0 0 1/p1(3);1/p1(1) 0 0;0 1/p1(2) 0];
			b=[1,2,3];
			
		elseif sum(~~p1) == 2
			
			if ~p1(3)
				
				a = ([0 1/p1(2) 1;1/p1(1) 0 1;1/p1(1) 0 0;0 1/p1(2) 0]);
				
			elseif ~p1(2)
				
				a = [0 0 1/(p1(3));1/p1(1) 0 0;1/p1(1) 1 0;0 1 1/(p1(3))];
				
			elseif ~p1(1)
				
				a = ([0 0 1/p1(3);0 1/p1(2) 0;1 1/p1(2) 0;1 0 1/p1(3)]);
				
			end
			
			b=[1,2,3,4];
			
		else
			
			a = [0 0 0;...
				1 0 0;...
				1 1 0;...
				0 1 0;...
				0 0 1;...
				1 0 1;...
				1 1 1;...
				0 1 1];
			
			B = [2,6,7,3;...
				4,8,7,3;...
				5:8;...
				1,4,8,5;...
				1,2,6,5;...
				1:4];
			
			c = find(p1);
			
			if p1(c) < 0
				c = c + 3;
			end
			
			b = B(c,:);
			
		end
		
		for k = 1:3
			if any(a(:,k) < 0)
				a(:,k) = a(:,k) + 1;
			end
		end
		
		lp = patch('vertices',a,...
			'faces',b,...
			'edgecolor','k',...
			'facecolor',[.54 .54 .24],...
			'linewidth',1,...
			'facealpha',1,...
			'linestyle','-');
		
		C = zeros(4^3,3);
		
		c = 0;
		
		for ro1 = 1:4
			
			for ro2 = 1:4
				
				for ro3 = 1:4
					
					c = c + 1;
					
					x1 = (get(tl,'xdata')');
					x2 = (get(tl,'ydata')');
					x3 = (get(tl,'zdata')');
					
					C(c,:) = [x1(2)-x1(1),x2(2)-x2(1),x3(2)-x3(1)];
					
					rotate([pl,tl,mp,lp],[1,0,0],90,[0.5,0.5,0.5])
					
				end
				
				rotate([pl,tl,mp,lp],[0,1,0],90,[0.5,0.5,0.5])
				
			end
			
			rotate([pl,tl,mp,lp],[0,0,1],90,[0.5,0.5,0.5])
			
		end
		
		delete([pl,tl,lp])
		lp = patch('vertices',a,...
			'faces',b,...
			'edgecolor','k',...
			'facecolor',[.94 .24 .24],...
			'linewidth',1,...
			'facealpha',1,...
			'linestyle','-');
		tl = line(lx,ly,lz,'color',[.25,.9,.5],'linewidth',3);
		pl = plot3(lx(2),ly(2),lz(2),'.');
		set(pl,'color',[.25,.9,.5],'markersize',20);
		C(abs(C) < 1e-5) = 0;
		
		[kkk,lll] = unique(round(C*10000),'rows','first');
		
		if isequal((sort(abs(p1))),[0,1,1])
			lll = lll(7:12);
		end
		
		til = round(C(lll,:)*10000)/10000;
		
		for klm = 1:size(til,1)
			
			til2 = til(klm,:);
			til2 = til2(~~til2)*abs(prod(p1(~~p1)));
			til2(length(til2)+1:3) = 0;
			til2 = round(til2);
			til(klm,:) = round(round(til(klm,:)/gcd(gcd(til2(1),til2(2)),...
				til2(3))*abs(prod(p1(~~p1)))*100000)/100000);
			
		end
		
		set(t1,'string',[num2str(size(til,1)),' Planes Found'],'visible','on')
		set(l1,'visible','on','string',...
			transpose(arrayfun(@(x)num2str(til(x,:)),...
			1:size(til,1),'uniformoutput',false)),'value',1)
		rotate3d on
		tlt = text('string',[' Plane (',num2str(p1*1),')'],...
			'position',[1,.5,1.5]);
		
		set(tlt,'fontsize',12,'fontw','b')
		
		set([r1r,r2r,r3r,r1r2,r2r2,r3r2],'visible','on')
	end
	
end