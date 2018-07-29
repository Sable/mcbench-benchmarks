function [plrpiece] = reqmark(h)
  plrpiece=h.plrpiece;
if rem(h.fpr+h.fpc,2)==0   %if even....means white background
    if h.plrmark==-1
        plrpiece=h.whitepawn2;
    elseif h.plrmark==1
        plrpiece=h.blackpawn2;
    elseif h.plrmark==-2
        plrpiece=h.whiterook2;
    elseif h.plrmark==2
        plrpiece=h.blackrook2;
    elseif h.plrmark==-3
        plrpiece=h.whiteknight2;
    elseif h.plrmark==3
        plrpiece=h.blackknight2;
    elseif h.plrmark==-4
        plrpiece=h.whitebishop2;
    elseif h.plrmark==4
        plrpiece=h.blackbishop2;
    elseif h.plrmark==-5
        plrpiece=h.whitequeen2;
    elseif h.plrmark==5
        plrpiece=h.blackqueen2;
    elseif h.plrmark==-10
        plrpiece=h.whiteking2;
    elseif h.plrmark==10
        plrpiece=h.blackking2;
    end
elseif rem(h.fpr+h.fpc,2)~=0   %if odd ... means black background
    if h.plrmark==-1
        plrpiece=h.whitepawn1;
    elseif h.plrmark==1
        plrpiece=h.blackpawn1;
    elseif h.plrmark==-2
        plrpiece=h.whiterook1;
    elseif h.plrmark==2
        plrpiece=h.blackrook1;
    elseif h.plrmark==-3
        plrpiece=h.whiteknight1;
    elseif h.plrmark==3
        plrpiece=h.blackknight1;
    elseif h.plrmark==-4
        plrpiece=h.whitebishop1;
    elseif h.plrmark==4
        plrpiece=h.blackbishop1;
    elseif h.plrmark==-5
        plrpiece=h.whitequeen1;
    elseif h.plrmark==5
        plrpiece=h.blackqueen1;
    elseif h.plrmark==-10
        plrpiece=h.whiteking1;
    elseif h.plrmark==10
        plrpiece=h.blackking1;
    end
% if rem(h.fpr+h.fpc,2)==0   %if even....means white background     
%     if h.plrpiece==h.whitepawn1
%         plrpiece=h.whitepawn2;
%     elseif h.plrpiece==h.blackpawn1
%         plrpiece=h.blackpawn2;
%     elseif h.plrpiece==h.whiterook1
%         plrpiece=h.whiterook2;
%     elseif h.plrpiece==h.blackrook1
%         plrpiece=h.blackrook2;
%     elseif h.plrpiece==h.whiteknight1
%         plrpiece=h.whiteknight2;
%     elseif h.plrpiece==h.blackknight1
%         plrpiece=h.blackknight2;
%     elseif h.plrpiece==h.whitebishop1
%         plrpiece=h.whitebishop2;
%     elseif h.plrpiece==h.blackbishop1
%         plrpiece=h.blackbishop2;
%     elseif h.plrpiece==h.whitequeen1
%         plrpiece=h.whitequeen2;
%     elseif h.plrpiece==h.blackqueen1
%         plrpiece=h.blackqueen2;
%     elseif h.plrpiece==h.whiteking1
%         plrpiece=h.whiteking2;
%     elseif h.plrpiece==h.blackking1
%         plrpiece=h.blackking2;
%     end
%     
% elseif rem(h.fpr+h.fpc,2)~=0   %if odd ... means black background
%     if h.plrpiece==h.whitepawn2
%         plrpiece=h.whitepawn1;
%     elseif h.plrpiece==h.blackpawn2
%         plrpiece=h.blackpawn1;
%     elseif h.plrpiece==h.whiterook2
%         plrpiece=h.whiterook1;
%     elseif h.plrpiece==h.blackrook2
%         plrpiece=h.blackrook1;
%     elseif h.plrpiece==h.whiteknight2
%         plrpiece=h.whiteknight1;
%     elseif h.plrpiece==h.blackknight2
%         plrpiece=h.blackknight1;
%     elseif h.plrpiece==h.whitebishop2
%         plrpiece=h.whitebishop1;
%     elseif h.plrpiece==h.blackbishop2
%         plrpiece=h.blackbishop1;
%     elseif h.plrpiece==h.whitequeen2
%         plrpiece=h.whitequeen1;
%     elseif h.plrpiece==h.blackqueen2
%         plrpiece=h.blackqueen1;
%     elseif h.plrpiece==h.whiteking2
%         plrpiece=h.whiteking1;
%     elseif h.plrpiece==h.blackking2
%         plrpiece=h.blackking1;
%     end
%     
else
    plrpiece=h.plrpiece;
end