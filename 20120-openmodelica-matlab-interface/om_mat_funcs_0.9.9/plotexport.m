function plotexport(prefix)
saveas(gcf,prefix,'fig');
print( gcf, '-depsc2', prefix );
print( gcf, '-dpng', prefix );
switch isunix 
    case 0
    print( gcf, '-dmeta', prefix );
end