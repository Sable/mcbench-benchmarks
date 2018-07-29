function slide9
	
	figure('units','normalized',...
		'position',[0.1, 0.1, 0.7, 0.7],...
		'menubar','none');
	
	axes('units','normalized',...
		'position',[0.5, 0.5, 0.4, 0.4])
	
	x1 = 3;
	x2 = 5;
	y1 = 2;
	y2 = 3;
	
	patch([x1,x1,x2,x2],[y1,y2,y2,y1],[1,0,0])
	
	axis([0 6 0 6])
	
end