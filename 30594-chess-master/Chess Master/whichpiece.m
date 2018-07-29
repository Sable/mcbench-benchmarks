function [plrmark] = whichpiece(h)
    if h.plrpiece==h.whitepawn1
        plrmark=-1;
    elseif h.plrpiece==h.blackpawn1
        plrmark=1;
    elseif h.plrpiece==h.whiterook1
        plrmark=-2;
    elseif h.plrpiece==h.blackrook1
        plrmark=2;
    elseif h.plrpiece==h.whiteknight1
        plrmark=-3;
    elseif h.plrpiece==h.blackknight1
        plrmark=3;
    elseif h.plrpiece==h.whitebishop1
        plrmark=-4;
    elseif h.plrpiece==h.blackbishop1
        plrmark=4;
    elseif h.plrpiece==h.whitequeen1
        plrmark=-5;
    elseif h.plrpiece==h.blackqueen1
        plrmark=5;
    elseif h.plrpiece==h.whiteking1
        plrmark=-10;
    elseif h.plrpiece==h.blackking1
        plrmark=10;
    elseif h.plrpiece==h.whitepawn2
        plrmark=-1;
    elseif h.plrpiece==h.blackpawn2
        plrmark=1;
    elseif h.plrpiece==h.whiterook2
        plrmark=-2;
    elseif h.plrpiece==h.blackrook2
        plrmark=2;
    elseif h.plrpiece==h.whiteknight2
        plrmark=-3;
    elseif h.plrpiece==h.blackknight2
        plrmark=3;
    elseif h.plrpiece==h.whitebishop2
        plrmark=-4;
    elseif h.plrpiece==h.blackbishop2
        plrmark=4;
    elseif h.plrpiece==h.whitequeen2
        plrmark=-5;
    elseif h.plrpiece==h.blackqueen2
        plrmark=5;
    elseif h.plrpiece==h.whiteking2
        plrmark=-10;
    elseif h.plrpiece==h.blackking2
        plrmark=10;
    end
    



end