function set_chicken(hia,chickens,chclr,chcs,brocken_eggs)

for cc=1:5
    if chcs(cc)
        set_visible(hia,chickens{cc,chclr});
    end
end

% brocken egg parts:
if any(chcs)
    set_visible(hia,brocken_eggs{chclr});
end


