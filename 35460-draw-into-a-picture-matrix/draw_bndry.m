function fig = draw_bndry(fig, bndryy, bndryx, clr)
% fig = draw_bndry(fig, bndryy, bndryx, clr)
% draws specified points (boundaries) into picture matrix (figure)

    bndryy = round(bndryy);
    bndryx = round(bndryx);
    c = size(fig, 1);
    d = size(fig, 2);
    e = size(fig, 3);
    % draw only pixel that are in the image region
    draw = bndryy >= 1 & bndryy <= c & bndryx >= 1 & bndryx <= d; 

    % Manipulate Figure
    ind = sub2ind([c,d], bndryy(draw), bndryx(draw));
    for j = 1:e
        fig(ind) = clr(j);
        ind = ind + c*d;
    end
end
