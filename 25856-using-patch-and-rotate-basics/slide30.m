function slide30
	
	a = [0 0 0;
		1 0 0;
		1 1 0;
		0 1 0;
		0 0 1;
		1 0 1;
		1 1 1;
		0 1 1];
	
	b = [1 2 6 5;
		2 3 7 6;
		3 4 8 7;
		4 1 5 8;
		1 2 3 4;
		5 6 7 8];
	
	p1 = patch('faces',b,...
		'vertices',a,...
		'facecolor',[.5 .5 .5],...
		'edgecolor',[1,1,1],...
		'facealpha',0.5);
	
	view(3)
	axis square
	
end