function slide24
	
	figure('units','normalized',...
		'position',[0.1, 0.1, 0.7, 0.7],...
		'menubar','none');
	
	axes('units','normalized',...
		'position',[0.5, 0.5, 0.4, 0.4])
	
	t1 = uicontrol('style','text',...
		'units','normalized',...
		'position',[.1 .4 .2 .2],...
		'fontsize',20,...
		'string','Time = 0');
	
	t = 0:.01:10;
	y = cos(t);
	plot(t,y);
	xlabel('t')
	
	x1 = 0;
	
	pp = patch([x1,x1,10,10],[-1 1 1 -1],[1 1 1]);
	set(pp,'edgecolor','none')
end