function figureOutput = getMagicWebFigure(x)
    f = figure;

    magicOutput = magic(x);
    surf(magicOutput);
    
    set(gcf,'Color',[1,1,1])
    figureOutput = webfigure(f);
    close(f);
end

