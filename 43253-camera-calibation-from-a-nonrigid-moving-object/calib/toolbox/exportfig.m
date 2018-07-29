function exportfig(fname)
% put in a filename (minus extension) and this exports
% the .fig, .eps and .pdf files for use in LaTeX...
%
% © Copyright Phil Tresadern, University of Oxford, 2006

% if no path then assume relative to current dir
[p,n,e] = fileparts(fname);
if isempty(p)
	p = './';
end

% if extension exists then delete it
if (strcmp(e,'.fig') | strcmp(e,'.eps') | strcmp(e,'.pdf'))
	fname = [p n];
end

% save figure
saveas(gcf,[fname '.fig']);

% export eps
print('-depsc2','-loose',[fname '.eps']);
% % make background transparent if asked so (doesn't always work)
% fp = fopen([fname,'.eps'],'r+t');
% while ~feof(fp)
% 	l = fgets(fp);
% 	if ~strcmp(l,'1 sg')
% 		fprintf(fp,'%%'); % comment out next line
% 	end
% end
% fclose(fp);

% export png
% print('-dpng',[fname '.png']);

% convert to pdf using epstopdf (needs to be installed)
if (isunix)
	eval(['!epstopdf ' fname '.eps']);
else
	if ~isempty(p)
		olddir	= cd;
		cd(p);
			eval(['!epstopdf ' n '.eps']);
		cd(olddir);	
	else
		eval(['!epstopdf ' n '.eps']);
	end
end
