function H = graph(num)
% format graph so it comes out nicely when you convert to eps or pdf
%
% © Copyright Phil Tresadern, University of Oxford, 2006

H = figure(num);

if (isunix),	figpos = [960 720 640 480];
else,					figpos = [540 330 480 360];
end

% set box to on for all axes
h_child = get(H,'Children');
for i = 1:length(h_child)
	if strcmp(get(h_child(i),'type'),'axes'), set(h_child(i),'Box','on'); end
end
set(H,'PaperPosition',[1 1 12 9],...
			'Renderer','Painters',...
			'Position',figpos,...
			'DoubleBuffer','on');
		

