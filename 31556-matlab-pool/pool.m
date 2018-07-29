function pool(varargin)
	% POOL MATLAB Pool Demonstration
	%
	% Husam Aldahiyat, numandina@gmail.com, 2011
	%
	
	ff = figure('color',[1 1 1],'me','n','nu','off');
	he = uicontrol('sty','e','ba','w','un','n','p',[.04 .1 .1 .05],'str','0 90','visible','off');
	hhs = uicontrol('sty','slider','un','n','p',[.02 .1 .1 .05],'min',-.2,'max',4*pi+.2,'sliderstep',[.0005,.01],...
		'callback',@chs,'value',1.5*pi);
	hhs2 = uicontrol('sty','slider','un','n','p',[.13 .1 .025 .15],'min',1e3,'max',1e4,'sliderstep',[.001,.1],...
		'callback',@chs,'value',3e3);
	
	function chs(varargin)
		
		if get(hhs,'value') >= 4*pi
			set(hhs,'value',0)
		elseif get(hhs,'value') <= 0
			set(hhs,'value',4*pi)
		end
		
		h = H(1);
		
		ctr=[(max(max(get(h,'xdata')))+min(min(get(h,'xdata'))))/2,...
			(max(max(get(h,'ydata')))+min(min(get(h,'ydata'))))/2];
		
		xx = cos(2*pi - get(hhs,'value'))*get(hhs2,'value')/200 + ctr(1);
		yy = sin(2*pi - get(hhs,'value'))*get(hhs2,'value')/200 + ctr(2);
		
		delete(findobj(gca,'type','line'))
		line([ctr(1),xx],[ctr(2),yy],[1,1],'linestyle','--','color',[1,1,1])
		set(he,'string',num2str([cos(2*pi - get(hhs,'value')),sin(2*pi - get(hhs,'value'))]*get(hhs2,'value')))
		
	end
	
	uicontrol('sty','pu','ba','w','str','Shoot','ca',@go1)
	
	uicontrol('sty','pu','ba','w','str','Reset','ca',@go2,'un','n','pos',...
		[0.02,.3,.05,.035]-[0,.1,0,0])
	if ~isempty(varargin)
		em1 = uicontrol('sty','e','ba','w','str',num2str(varargin{1}),'un','n','pos',...
			[0.02,.35,.05,.035]-[0,.1,0,0]);
		em2 = uicontrol('sty','e','ba','w','str',num2str(varargin{2}),'un','n','pos',...
			[0.02,.4,.05,.035]-[0,.1,0,0]);
		em3 = uicontrol('sty','e','ba','w','str',num2str(varargin{3}),'un','n','pos',...
			[0.02,.45,.05,.035]-[0,.1,0,0]);
		em4 = uicontrol('sty','e','ba','w','str',num2str(varargin{4}),'un','n','pos',...
			[0.02,.5,.05,.035]-[0,.1,0,0]);
		em5 = uicontrol('sty','e','ba','w','str',num2str(varargin{5}),'un','n','pos',...
			[0.02,.55,.05,.035]-[0,.1,0,0]);
		em6 = uicontrol('sty','e','ba','w','str',num2str(varargin{6}),'un','n','pos',...
			[0.02,.6,.05,.035]-[0,.1,0,0]);
	else
		em1 = uicontrol('sty','e','ba','w','str','1 -10','un','n','pos',...
			[0.02,.35,.05,.035]-[0,.1,0,0]);
		em2 = uicontrol('sty','e','ba','w','str','-1 -10','un','n','pos',...
			[0.02,.4,.05,.035]-[0,.1,0,0]);
		em3 = uicontrol('sty','e','ba','w','str','0 -8','un','n','pos',...
			[0.02,.45,.05,.035]-[0,.1,0,0]);
		em4 = uicontrol('sty','e','ba','w','str','2 12','un','n','pos',...
			[0.02,.5,.05,.035]-[0,.1,0,0]);
		em5 = uicontrol('sty','e','ba','w','str','12 -8','un','n','pos',...
			[0.02,.55,.05,.035]-[0,.1,0,0]);
		em6 = uicontrol('sty','e','ba','w','str','-5 6','un','n','pos',...
			[0.02,.6,.05,.035]-[0,.1,0,0]);
	end
	
	function go2(varargin)
		
		pool(str2num(get(em1,'string')),str2num(get(em2,'string')),str2num(get(em3,'string')),...
			str2num(get(em4,'string')),str2num(get(em5,'string')),str2num(get(em6,'string')))
		close(ff)
		
	end
	
	ue = uicontrol('sty','te','ba','w','fonts',12,'str','FPS:','un','n',...
		'p',[.02 .86 .1 .035],'fontn','courier','horizontalal','l','visible','off');
	
	hold on
	grid on
	axis([-2.5 2.5 -5 5 -5 5].*10)
	axis equal
	set(gcf,'visible','off')
	
	aaa=[-5 -5 0;
		5 -5 0;
		5 5 0;
		-5 5 0;
		-5 -5 0;
		5 -5 0;
		5 5 0;
		-5 5 0].*10;
	
	aaa(:,1) = aaa(:,1)*.5;
	b = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
	patch('vertices',aaa,'faces',b,'edgecolor','w','facecolor',[.0 .5 0],...
		'facevertexalphadata',0.5,'facealpha','flat');
	view(3)
	rotate3d
	xlabel('X')
	ylabel('Y')
	
	colormap([1,1,1;0,0,0;1,1,0;1,0,1;0,1,1;1,0,0;0,1,0;0,0,1;.5,.5,.5])
	h1 = movsph(1,[0,-40],[0,-40],25,0,[],0);
	
	if ~isempty(varargin)
		h2 = movsph(1,varargin{1},varargin{1},25,0,[],1);
		h3 = movsph(1,varargin{2},varargin{2},25,0,[],2);
		h4 = movsph(1,varargin{3},varargin{3},25,0,[],4);
		h5 = movsph(1,varargin{4},varargin{4},25,0,[],3);
		h6 = movsph(1,varargin{5},varargin{5},25,0,[],5);
		h7 = movsph(1,varargin{6},varargin{6},25,0,[],6);
	else
		h2 = movsph(1,[1,-10],[1,-10],25,0,[],1);
		h3 = movsph(1,[-1,-10],[-1,-10],25,0,[],2);
		h4 = movsph(1,[0,-8],[0,-8],25,0,[],4);
		h5 = movsph(1,[2,12],[2,12],25,0,[],3);
		h6 = movsph(1,[12,-8],[12,-8],25,0,[],5);
		h7 = movsph(1,[-5,6],[5,6],25,0,[],6);
	end
	
	H = [h1,h2,h3,h4,h5,h6,h7];
	
	X = (cell2mat(cellfun(@max,cellfun(@max,get(H,'xdata'),'un',0),'un',0)) + ...
		cell2mat(cellfun(@min,cellfun(@min,get(H,'xdata'),'un',0),'un',0)))/2;
	Y = (cell2mat(cellfun(@max,cellfun(@max,get(H,'ydata'),'un',0),'un',0)) + ...
		cell2mat(cellfun(@min,cellfun(@min,get(H,'ydata'),'un',0),'un',0)))/2;
	BB = zeros(length(X),2);
	
	set(gca,'pos',[-.75,-.75,2.5,2.5]);
	axis off
	set(gcf,'un','n','pos',[0.1,0.1,.7,.7],'name','Billiards')
	set(gcf,'visible','on')
	M = [1,0,0,0,0,0,0];
	
	t = linspace(1.5*pi,2.5*pi,100);
	x = 2*cos(t) - 25;
	y = 2*sin(t);
	ph1 = patch(x,y,'k');
	
	t = linspace(.5*pi,1.5*pi,100);
	x = 2*cos(t) + 25;
	y = 2*sin(t);
	ph2 = patch(x,y,'k');
	
	t = linspace(-1*pi,-.5*pi,100);
	x = 3*cos(t) + 25;
	y = 3*sin(t) + 50;
	ph3 = patch([x,25],[y,50],'k');
	
	t = linspace(0*pi,.5*pi,100);
	x = 3*cos(t) - 25;
	y = 3*sin(t) - 50;
	ph4 = patch([x,-25],[y,-50],'k');
	
	t = linspace(-.5*pi,0*pi,100);
	x = 3*cos(t) - 25;
	y = 3*sin(t) + 50;
	ph5 = patch([x,-25],[y,50],'k');
	
	t = linspace(-1.5*pi,-1*pi,100);
	x = 3*cos(t) + 25;
	y = 3*sin(t) - 50;
	ph6 = patch([x,25],[y,-50],'k');
	chs
	hold on
	
	function go1(varargin)
		set(findobj('type','uicontrol'),'enable','off')
		set(ue,'visible','on')
		pt = str2num(get(he,'string')); %#ok<*ST2NM>
		delete(findobj('type','line'))
		M(1) = 1;
		X = (cell2mat(cellfun(@max,cellfun(@max,get(H,'xdata'),'un',0),'un',0)) + ...
			cell2mat(cellfun(@min,cellfun(@min,get(H,'xdata'),'un',0),'un',0)))/2;
		Y = (cell2mat(cellfun(@max,cellfun(@max,get(H,'ydata'),'un',0),'un',0)) + ...
			cell2mat(cellfun(@min,cellfun(@min,get(H,'ydata'),'un',0),'un',0)))/2;
		xt = X;
		yt = Y;
		
		h1 = movsphm(1,pt,h1);
		chs
		set(findobj('type','uicontrol'),'enable','on')
		set(ue,'visible','off')
		
		function h = movsphm(r,B,ph)
			
			h = ph;
			
			BB(1,:) = B;
			tic
			ccc = 0;
			isB = zeros(1,length(X));
			HT = zeros(1,length(X));
			
			while true
				
				if toc >= 1
					set(ue,'string',['FPS: ',num2str(ccc)])
					tic
					ccc = 0;
				end
				ccc = ccc + 1;
				
				for k = 1:numel(H)
					if M(k)
						B = BB(k,:);
						h = H(k);
						V = sqrt(B(1)^2 + B(2)^2);
						ctr=[(max(max(get(h,'xdata')))+min(min(get(h,'xdata'))))/2,...
							(max(max(get(h,'ydata')))+min(min(get(h,'ydata'))))/2];
						
						rot = B;
						BB(k,:) = B*.99;
						
						yu=rot(2);
						rot(2)=rot(1);
						rot(1)=-yu;
						V = V*.99;
						
						rotate(h,[rot,0],V/100,[ctr,r])
						
						set(h,'xdata',get(h,'xdata')...
							+ V*sin(atan2(rot(2),rot(1)))*1/10000)
						X(k) = X(k) + + V*sin(atan2(rot(2),rot(1)))*1/10000;
						set(h,'ydata',get(h,'ydata') - 1/10000*V*sin(atan2(rot(1),rot(2))))
						Y(k) = Y(k) - 1/10000*V*sin(atan2(rot(1),rot(2)));
						
						if B(1)^2 + B(2)^2 < 5e4
							M(k) = 0;
						end
						
						if sum(inpolygon(ctr(1),ctr(2),get(ph1,'xdata'),get(ph1,'ydata')))
							if k == 1
								M(k) = []; H(k) = []; delete(h);
								cla
								msgbox('You Lose!')
								return
							end
							M(k) = []; H(k) = []; X(k) = [];Y(k) = []; delete(h); BB(k,:) = [];break
						end
						if sum(inpolygon(ctr(1),ctr(2),get(ph2,'xdata'),get(ph2,'ydata')))
							if k == 1
								M(k) = []; H(k) = []; delete(h);
								cla
								msgbox('You Lose!')
								return
							end
							M(k) = []; H(k) = []; X(k) = [];Y(k) = []; delete(h); BB(k,:) = [];break
						end
						if sum(inpolygon(ctr(1),ctr(2),get(ph3,'xdata'),get(ph3,'ydata')))
							if k == 1
								M(k) = []; H(k) = []; delete(h);
								cla
								msgbox('You Lose!')
								return
							end
							M(k) = []; H(k) = []; X(k) = [];Y(k) = []; delete(h); BB(k,:) = [];break
						end
						if sum(inpolygon(ctr(1),ctr(2),get(ph4,'xdata'),get(ph4,'ydata')))
							if k == 1
								M(k) = []; H(k) = []; delete(h);
								cla
								msgbox('You Lose!')
								return
							end
							M(k) = []; H(k) = []; X(k) = [];Y(k) = []; delete(h); BB(k,:) = [];break
						end
						if sum(inpolygon(ctr(1),ctr(2),get(ph5,'xdata'),get(ph5,'ydata')))
							if k == 1
								M(k) = []; H(k) = []; delete(h);
								cla
								msgbox('You Lose!')
								return
							end
							M(k) = []; H(k) = []; X(k) = [];Y(k) = []; delete(h); BB(k,:) = [];break
						end
						if sum(inpolygon(ctr(1),ctr(2),get(ph6,'xdata'),get(ph6,'ydata')))
							if k == 1
								M(k) = []; H(k) = []; delete(h);
								cla
								msgbox('You Lose!')
								return
							end
							M(k) = []; H(k) = []; X(k) = [];Y(k) = []; delete(h); BB(k,:) = [];break
						end
						
						drawnow()
					end
				end
				if length(H) == 1
					msgbox('You win!')
					return
				end
				vz = volume_intersect_sphere_analytical(X,Y);
				[v1,v2] = find(vz);
				V3 = [v1,v2];
				
				if ~isempty(V3(v1~=v2))
					bz = (sort(V3(v1~=v2,:),2));
					M(unique(bz)) = 1;
					BBb = BB;
					
					for jk = 1:numel(unique(bz)) - 1
						b1 = bz(jk,1);
						b2 = bz(jk,2);
						
						if sum(HT([b1,b2])) ~= 2
							
							if mean(abs(BBb(b1,:))) > mean(abs(BBb(b2,:)))
								B_diff = BBb(b1,:) + BBb(b2,:);
								Bm = B_diff/max(abs(B_diff));
								B_diff = mean(abs((B_diff)));
								vec = [xt(b2),yt(b2)] - [xt(b1),yt(b1)];
								BB(b2,:) = B_diff.*vec*.9;
								a = BB(b1,:);
								b = vec;
								
								x1 = a(1);
								y1 = a(2);
								x2 = b(1);
								y2 = b(2);
								angle = mod(atan2(x1*y2-x2*y1,x1*x2+y1*y2),2*pi);
								
								if angle < pi/2 && angle > 0
									sg = -1;
								else
									sg = 1;
								end
								
								if (angle) < 15/180*pi || angle > 345*pi/180
									BB(b1,:) = Bm.*-B_diff.*vec*.8;
								else
									BB(b1,:) = Bm.*B_diff.*vec*rotz(sg*pi/2)*.8;
								end
								
							else
								
								B_diff = BBb(b2,:) + BBb(b1,:);
								vec = fliplr([xt(b2),yt(b2)] - [xt(b1),yt(b1)]);
								Bm = B_diff/max(abs(B_diff));
								B_diff = mean(abs((B_diff)));
								BB(b1,:) = B_diff.*vec*.9;
								a = BB(b2,:);
								b = vec;
								
								x1 = a(1);
								y1 = a(2);
								x2 = b(1);
								y2 = b(2);
								angle = mod(atan2(x1*y2-x2*y1,x1*x2+y1*y2),2*pi);

								if angle < pi/2 && angle > 0
									sg = -1;
								else
									sg = 1;
								end
								
								if (angle) < 15/180*pi || angle > 345*pi/180
									BB(b2,:) = Bm.*-B_diff.*vec*.8;
								else
									BB(b2,:) = Bm.*B_diff.*vec*rotz(sg*pi/2)*.8;
								end
								
							end
							
							HT([b1,b2]) = 1;
						end
						
					end
					
				else
					HT = zeros(1,length(X));
				end
				
				if any(X <= -24)
					fB = find(X <= -24);
					for j = 1:sum((X <= -24))
						if ~isB(fB(j))
							bBc = BB(fB(j),:);
							
							bBc(1) = -1*bBc(1);
							bBc = .75*bBc;
							
							BB(fB(j),:) = bBc;
							isB(fB(j)) = 1;
						end
					end
				end
				
				if any(X >= 24)
					fB = find(X >= 24);
					for j = 1:sum((X >= 24))
						if ~isB(fB(j))
							
							bBc = BB(fB(j),:);
							
							bBc(1) = -1*bBc(1);
							bBc = .75*bBc;
							
							BB(fB(j),:) = bBc;
							isB(fB(j)) = 1;
						end
					end
				end
				
				if any(Y >= 49)
					fB = find(Y >= 49);
					for j = 1:sum((Y >= 49))
						if ~isB(fB(j))
							
							bBc = BB(fB(j),:);
							
							bBc(2) = -1*bBc(2);
							bBc = .75*bBc;
							
							BB(fB(j),:) = bBc;
							isB(fB(j)) = 1;
						end
					end
				end
				
				if any(Y <= -49)
					fB = find(Y <= -49);
					for j = 1:sum((Y <= -49))
						if ~isB(fB(j))
							
							bBc = BB(fB(j),:);
							
							bBc(2) = -1*bBc(2);
							bBc = .75*bBc;
							
							BB(fB(j),:) = bBc;
							isB(fB(j)) = 1;
						end
					end
				end
				
				isB(~(Y <= -49 | Y >= 49 | X >= 24 | X <= -24) & M') = 0;
				
				if ~sum(M)
					break
				end
				xt = X;
				yt = Y;
			end
		end
	end
	
	function a = rotz(b)
		a = [cos(b) sin(b);-sin(b),cos(b)];
	end
	
	set(gcf,'color',[.6,.9,.7])
	set(ue,'backgroundc',get(gcf,'color'))
	uicontrol('sty','tex','ba','w','str','Black','un','n','pos',...
		[0.08,.345,.05,.035]-[0,.1,0,0],'backgroundc',get(gcf,'color'),'horizontalal','l');
	uicontrol('sty','tex','ba','w','str','Yellow','un','n','pos',...
		[0.08,.39,.05,.035]-[0,.1,0,0],'backgroundc',get(gcf,'color'),'horizontalal','l');
	uicontrol('sty','tex','ba','w','str','Blue','un','n','pos',...
		[0.08,.44,.05,.035]-[0,.1,0,0],'backgroundc',get(gcf,'color'),'horizontalal','l');
	uicontrol('sty','tex','ba','w','str','Pink','un','n','pos',...
		[0.08,.49,.05,.035]-[0,.1,0,0],'backgroundc',get(gcf,'color'),'horizontalal','l');
	uicontrol('sty','tex','ba','w','str','Red','un','n','pos',...
		[0.08,.54,.05,.035]-[0,.1,0,0],'backgroundc',get(gcf,'color'),'horizontalal','l');
	uicontrol('sty','tex','ba','w','str','Green','un','n','pos',...
		[0.08,.6,.05,.035]-[0,.1,0,0],'backgroundc',get(gcf,'color'),'horizontalal','l');
	
	function M = volume_intersect_sphere_analytical(x,y)
		
		size_x = numel(x);
		size_y = numel(y);
		
		x = reshape(x,size_x,1);
		y = reshape(y,size_y,1);
		
		X2 = meshgrid(x);
		Y2 = meshgrid(y);
		
		D = sqrt((X2-X2').^2+(Y2-Y2').^2);
		
		M = (D<2);
		
	end
	
	function h=movsph(r,A,B,V,op1,ph,coeffc) %#ok<*INUSL>
		
		hold on
		
		[a,b,c]=sphere(15);
		
		h=surf(a.*r+A(1),b.*r+A(2),c.*r+r);
		
		set(h,'cdata',[repmat(coeffc,14,16);repmat(8,2,16)],'edgecolor','interp')
		
		v=axis;
		
		ctr=[1e9 1e9];
		
		while mean(abs(ctr-B))>1e-1
			
			ctr=[(max(max(get(h,'xdata')))+min(min(get(h,'xdata'))))/2,...
				(max(max(get(h,'ydata')))+min(min(get(h,'ydata'))))/2];
			
			rot=B-ctr;
			
			yu=rot(2);
			rot(2)=rot(1);
			rot(1)=-yu;
			
			rotate(h,[rot,0],V,[ctr,r])
			
			set(h,'xdata',get(h,'xdata')...
				-(sign(rot(1))-~sign(rot(1)))...
				*V/360*...
				atan(-rot(2)/rot(1)))
			set(h,'ydata',get(h,'ydata')+(sign(rot(2))+sign(rot(2)))*V/360*atan(rot(1)/-rot(2)))
			
			axis(v)
			drawnow()
		end
		
	end
	
end