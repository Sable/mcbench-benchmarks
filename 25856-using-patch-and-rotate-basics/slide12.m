function slide12
	
	figure('units','normalized',...
		'position',[0.1, 0.1, 0.7, 0.7],...
		'menubar','none');
	
	axes('units','normalized',...
		'position',[0.5, 0.5, 0.4, 0.4])
	
	x1 = 3;
	x2 = 5;
	y1 = 2;
	y2 = 3;
	
	p1 = patch([x1,x1,x2,x2],[y1,y2,y2,y1],[1,0,0]);
	
	axis([0 6 0 6])
	
	while true
		
		xold = get(p1,'xdata');
		set(p1,'xdata',xold + 0.01)
		
		yold = get(p1,'ydata');
		set(p1,'ydata',yold + 0.01)
		
		drawnow
		
	end
	
end