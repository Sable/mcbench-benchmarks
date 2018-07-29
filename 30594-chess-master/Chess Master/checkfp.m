function [check,h] = checkfp(ha,h)
%-------------------------------------------------------------------------        
%   logic for movement of pawns
    if (h.plrmark==1) && ((h.fpr==h.ipr+1) || (h.ipr==2 && h.fpr==4)) && ...
       (  (h.fpc==h.ipc && h.box(h.fpr,h.fpc)==0)  || ...   %if moved straight one step
          (h.fpc==h.ipc+1 && h.box(h.fpr,h.fpc)<0) || ...   %or diagonally to right and opponent is present  
          (h.fpc==h.ipc-1 && h.box(h.fpr,h.fpc)<0)  )       %or diagonally to left and opponent is present 
       check=1;
    elseif (h.plrmark==-1) && ((h.fpr==h.ipr-1) || (h.ipr==7 && h.fpr==5)) && ...
       (  (h.fpc==h.ipc && h.box(h.fpr,h.fpc)==0)  || ...
          (h.fpc==h.ipc+1 && h.box(h.fpr,h.fpc)>0) || ...     
          (h.fpc==h.ipc-1 && h.box(h.fpr,h.fpc)>0)  )
       check=1;
%-------------------------------------------------------------------------        
%   logic for movement of horses     
    elseif ( (h.plrmark==3 && h.box(h.fpr,h.fpc)<=0 ) || (h.plrmark==-3 && h.box(h.fpr,h.fpc)>=0)  ) && ...
        (   ( h.fpr==h.ipr+2 && h.fpc==h.ipc+1 ) || ...
            ( h.fpr==h.ipr+2 && h.fpc==h.ipc-1 ) || ...
            ( h.fpr==h.ipr-2 && h.fpc==h.ipc+1 ) || ...
            ( h.fpr==h.ipr-2 && h.fpc==h.ipc-1 ) || ...
            ( h.fpr==h.ipr+1 && h.fpc==h.ipc+2 ) || ...
            ( h.fpr==h.ipr+1 && h.fpc==h.ipc-2 ) || ...
            ( h.fpr==h.ipr-1 && h.fpc==h.ipc+2 ) || ...
            ( h.fpr==h.ipr-1 && h.fpc==h.ipc-2 )  )
        check=1;
%-------------------------------------------------------------------------        
%   logic for movement of bishop
%   similar logic applicable to queen also.
    elseif ( h.plrmark==4 && h.box(h.fpr,h.fpc)<=0 || ...
           ( h.plrmark==-4 && h.box(h.fpr,h.fpc)>=0) )
        check=1;
%        check wheather there is another piece in between or not
       if (h.fpc-h.ipc)==(h.fpr-h.ipr) && h.fpc>h.ipc
                i=h.fpc-h.ipc-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr-i,h.fpc-i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.fpr-h.ipr) && h.fpc<h.ipc
                i=abs(h.fpc-h.ipc)-1;
                while i>0   
                    if h.box(h.fpr+i,h.fpc+i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.ipr-h.fpr) && h.fpc<h.ipc
                i=abs(h.fpc-h.ipc)-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr-i,h.fpc+i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.ipr-h.fpr) && h.fpc>h.ipc
                i=abs(h.fpc-h.ipc)-1;
                while i>0   
                    if h.box(h.fpr+i,h.fpc-i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
       else check=0;
       end
%-------------------------------------------------------------------------        
%   logic for movement of rook
%   similar logic applicable to queen also.
    elseif ( h.plrmark==2 && h.box(h.fpr,h.fpc)<=0 || ...
           ( h.plrmark==-2 && h.box(h.fpr,h.fpc)>=0) ) 
        check=1;
%        check wheather there is another piece in between or not
       if (h.fpc==h.ipc) && h.fpr>h.ipr
                i=h.fpr-h.ipr-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr-i,h.fpc)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc==h.ipc) && h.fpr<h.ipr
                i=abs(h.fpr-h.ipr)-1;
                while i>0   
                    if h.box(h.fpr+i,h.fpc)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif h.fpr==h.ipr && h.fpc>h.ipc
                i=(h.fpc-h.ipc)-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr,h.fpc-i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif h.fpr==h.ipr && h.fpc<h.ipc
                i=abs(h.fpc-h.ipc)-1;
                while i>0   
                    if h.box(h.fpr,h.fpc+i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        else check=0;
       end
%-------------------------------------------------------------------------        
%   similar logic applicable to queen also as for rook and bishop.
    elseif ( h.plrmark==5 && h.box(h.fpr,h.fpc)<=0 || ...
           ( h.plrmark==-5 && h.box(h.fpr,h.fpc)>=0) ) 
        check=1;
%        check wheather there is another piece in between or not
       if (h.fpc==h.ipc) && h.fpr>h.ipr
                i=h.fpr-h.ipr-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr-i,h.fpc)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc==h.ipc) && h.fpr<h.ipr
                i=abs(h.fpr-h.ipr)-1;
                while i>0   
                    if h.box(h.fpr+i,h.fpc)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif h.fpr==h.ipr && h.fpc>h.ipc
                i=(h.fpc-h.ipc)-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr,h.fpc-i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif h.fpr==h.ipr && h.fpc<h.ipc
                i=abs(h.fpc-h.ipc)-1;
                while i>0   
                    if h.box(h.fpr,h.fpc+i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.fpr-h.ipr) && h.fpc>h.ipc
                i=h.fpc-h.ipc-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr-i,h.fpc-i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.fpr-h.ipr) && h.fpc<h.ipc
                i=abs(h.fpc-h.ipc)-1;
                while i>0   
                    if h.box(h.fpr+i,h.fpc+i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.ipr-h.fpr) && h.fpc<h.ipc
                i=abs(h.fpc-h.ipc)-1;    % subtracted 1 b/c 5-3=2 but b/w 5 and 3 there is only one column that is 4
                while i>0   
                    if h.box(h.fpr-i,h.fpc+i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
        elseif (h.fpc-h.ipc)==(h.ipr-h.fpr) && h.fpc>h.ipc
                i=abs(h.fpc-h.ipc)-1;
                while i>0   
                    if h.box(h.fpr+i,h.fpc-i)~=0
                        check=0;
                        break
                    end
                    i=i-1;
                end
       else check=0;
       end
%-------------------------------------------------------------------------        
%   the great King moves one step to any side      
    elseif ( (h.plrmark==10 && h.box(h.fpr,h.fpc)<=0 ) || (h.plrmark==-10 && h.box(h.fpr,h.fpc)>=0)  ) && ...
         ( abs(h.fpr-h.ipr)==1 || abs(h.fpc-h.ipc)==1 ) 
        check=1;
%   king can also perform castling with rook
    elseif h.plrmark==10 && h.box(1,8)==2 && h.box(1,7)==0 && h.box(1,6)==0 && h.fpr==1 && h.fpc==7
        check=1;
        h.box(1,6)=2;
        h.box(1,8)=0;
        set(ha(16),'CData',h.blackrook1);
        set(ha(18),'CData',h.black);
    elseif h.plrmark==-10 && h.box(8,8)==-2 && h.box(8,7)==0 && h.box(8,6)==0 && h.fpr==8 && h.fpc==7
        check=1;
        h.box(8,6)=-2;
        h.box(8,8)=0;
        set(ha(86),'CData',h.whiterook2);
        set(ha(88),'CData',h.white);
    else
        check=0;
    end
%-------------------------------------------------------------------------        
%         when someone's pawn reaches its end line it is now
%         any piece of choice i have fixed it for queen for now.
    if h.plrmark==1 && h.fpr==8 % for player 01
        h.plrmark=5;
%         h.s=pawnupgrade();
%         if h.s==5
%             h.plrmark=5;
%         elseif h.s==4
%             h.plrmark=4;
%         elseif h.s==3
%             h.plrmakr=3;
%         elseif h.s==2
%             h.plrmark=2;
%         end
    elseif h.plrmark==-1 && h.fpr==1 %for player 02
        h.plrmark=-5;
%         h.s=pawnupgrade();
%         if h.s==5
%             h.plrmark=-5;
%         elseif h.s==4
%             h.plrmark=-4;
%         elseif h.s==3
%             h.plrmakr=-3;
%         elseif h.s==2
%             h.plrmark=-2;
%         end
    end
%-------------------------------------------------------------------------        
end