function slide6
	
	figure('units','normalized',...
		'position',[0.1, 0.1, 0.7, 0.7],...
		'menubar','none');
	
	axes('units','normalized',...
		'position',[0.5, 0.5, 0.4, 0.4])
	
	p1 = patch([1,1,2,2],[1,2,2,1],[1,0,0]);
	
	axis([0 6 0 6])
	
end