function slide21
	
	figure('units','normalized',...
		'position',[0.1, 0.1, 0.7, 0.7],...
		'menubar','none');
	
	axes('units','normalized',...
		'position',[0.5, 0.5, 0.4, 0.4])
	
	x1 = 3;
	x2 = 5;
	y1 = 2;
	y2 = 3;
	
	patch([x1,x1,x2,x2],[y1,5,5,y1],[1,1,1]); % tank patch
	p1 = patch([x1,x1,x2,x2],[y1,y2,y2,y1],[0,0,1]); % liquid patch
	
	axis([0 6 0 6])
	
	t = 1;
	while true
		
		t = t + 0.05;
		
		% the upper left corner plots a cosine while the upper right corner
		% plots a sine function
		y = [y1, y1 + 2 + 0.25*cos(t),  y1 + 2 + 0.25*sin(t), y1];
		
		set(p1,'ydata',y)
		
		drawnow				
		
	end
	
end