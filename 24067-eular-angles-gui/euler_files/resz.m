function resz(fig)

fgp=get(fig,'Position');
sz=min([fgp(3) fgp(4)]);
fud=get(fig,'UserData');
hs=fud{1};

% 691.2 (initial figure height) -> 10 pts (default latex text size)
for hsc=1:length(hs)

        set(hs(hsc),'FontSize',10*sz/691.2);

end