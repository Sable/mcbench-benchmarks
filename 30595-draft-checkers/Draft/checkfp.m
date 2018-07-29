function [check,box] = checkfp(ha,plr,box,ipx,ipy,fpx,fpy,dblbox,blank)
    if plr==1
        otherplr=2;
    elseif plr==2
        otherplr=1;
    end
    %at initial position there should be own piece
    %and at final there should be blank space
    if box(fpx,fpy)~=0
        check=0;
    %     back step is not allowed till the palyer has choose doubled piece
    elseif fpx<=ipx && plr==1 && dblbox(ipx,ipy)==0
        check=0;
    elseif fpx>=ipx && plr==2 && dblbox(ipx,ipy)==0
        check=0;
    %only diagonal movement is allowed
    elseif (fpx==ipx+1 && fpy==ipy+1) || (fpx==ipx-1 && fpy==ipy+1) || ...
            (fpx==ipx+1 && fpy==ipy-1) || (fpx==ipx-1 && fpy==ipy-1)
        check=1;
    %if approach to kill a single piece and opponent piece is
    %there....its a good move .. so let the player play it..killing will
    %include that specific box=0 and string=blank
    elseif (fpx==ipx+2 && fpy==ipy+2) && ( box(ipx+1,ipy+1)==otherplr )
            check=1;
            box(ipx+1,ipy+1)=0;
            xy=(ipx+1)*10+(ipy+1);
            set(ha(xy),'CData',blank);
    elseif (fpx==ipx-2 && fpy==ipy-2) && ( box(ipx-1,ipy-1)==otherplr )
            check=1;     
            box(ipx-1,ipy-1)=0;
            xy=(ipx-1)*10+(ipy-1);
            set(ha(xy),'CData',blank);
    elseif (fpx==ipx+2 && fpy==ipy-2) && ( box(ipx+1,ipy-1)==otherplr )
            check=1;     
            box(ipx+1,ipy-1)=0;  
            xy=(ipx+1)*10+(ipy-1);
            set(ha(xy),'CData',blank);
    elseif (fpx==ipx-2 && fpy==ipy+2) && ( box(ipx-1,ipy+1)==otherplr )
            check=1;     
            box(ipx-1,ipy+1)=0;  
            xy=(ipx-1)*10+(ipy+1);
            set(ha(xy),'CData',blank);
    %if approach to kill two pieces together lets check
    elseif (fpx==ipx+4 && fpy==ipy+4) && ( box(ipx+1,ipy+1)==otherplr) && (box(ipx+2,ipy+2)==0) && (box(ipx+3,ipy+3)==otherplr)
        check=1;     
        box(ipx+1,ipy+1)=0;  
        box(ipx+3,ipy+3)=0;  
        xy=(ipx+1)*10+(ipy+1);
        set(ha(xy),'CData',blank);
        xy=(ipx+3)*10+(ipy+3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx+4 && fpy==ipy-4) && ( box(ipx+1,ipy-1)==otherplr) && (box(ipx+2,ipy-2)==0) && (box(ipx+3,ipy-3)==otherplr)
        check=1;     
        box(ipx+1,ipy-1)=0;  
        box(ipx+3,ipy-3)=0;  
        xy=(ipx+1)*10+(ipy-1);
        set(ha(xy),'CData',blank);
        xy=(ipx+3)*10+(ipy-3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx-4 && fpy==ipy+4) && ( box(ipx-1,ipy+1)==otherplr) && (box(ipx-2,ipy+2)==0) && (box(ipx-3,ipy+3)==otherplr)
        check=1;     
        box(ipx-1,ipy+1)=0;  
        box(ipx-3,ipy+3)=0;  
        xy=(ipx-1)*10+(ipy+1);
        set(ha(xy),'CData',blank);
        xy=(ipx-3)*10+(ipy+3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx-4 && fpy==ipy-4) && ( box(ipx-1,ipy-1)==otherplr) && (box(ipx-2,ipy-2)==0) && (box(ipx-3,ipy-3)==otherplr)
        check=1;     
        box(ipx-1,ipy-1)=0;  
        box(ipx-3,ipy-3)=0;  
        xy=(ipx-1)*10+(ipy-1);
        set(ha(xy),'CData',blank);
        xy=(ipx-3)*10+(ipy-3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx+4 && fpy==ipy) && ( box(ipx+1,ipy+1)==otherplr) && (box(ipx+2,ipy+2)==0) && (box(ipx+3,ipy+1)==otherplr)
        check=1;     
        box(ipx+1,ipy+1)=0;  
        box(ipx+3,ipy+1)=0;  
        xy=(ipx+1)*10+(ipy+1);
        set(ha(xy),'CData',blank);
        xy=(ipx+3)*10+(ipy+1);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx+4 && fpy==ipy) && ( box(ipx+1,ipy-1)==otherplr) && (box(ipx+2,ipy-2)==0) && (box(ipx+3,ipy-1)==otherplr)
        check=1;     
        box(ipx+1,ipy-1)=0;  
        box(ipx+3,ipy-1)=0;  
        xy=(ipx+1)*10+(ipy-1);
        set(ha(xy),'CData',blank);
        xy=(ipx+3)*10+(ipy-1);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx-4 && fpy==ipy) && ( box(ipx-1,ipy+1)==otherplr) && (box(ipx-2,ipy+2)==0) && (box(ipx-3,ipy+1)==otherplr)
        check=1;     
        box(ipx-1,ipy+1)=0;  
        box(ipx-3,ipy+1)=0;  
        xy=(ipx-1)*10+(ipy+1);
        set(ha(xy),'CData',blank);
        xy=(ipx-3)*10+(ipy+1);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx-4 && fpy==ipy) && ( box(ipx-1,ipy-1)==otherplr) && (box(ipx-2,ipy-2)==0) && (box(ipx-3,ipy-1)==otherplr)
        check=1;     
        box(ipx-1,ipy-1)=0;  
        box(ipx-3,ipy-1)=0;  
        xy=(ipx-1)*10+(ipy-1);
        set(ha(xy),'CData',blank);
        xy=(ipx-3)*10+(ipy-1);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx && fpy==ipy+4) && ( box(ipx+1,ipy+1)==otherplr) && (box(ipx+2,ipy+2)==0) && (box(ipx+1,ipy+3)==otherplr)
        check=1;     
        box(ipx+1,ipy+1)=0;  
        box(ipx+1,ipy+3)=0;  
        xy=(ipx+1)*10+(ipy+1);
        set(ha(xy),'CData',blank);
        xy=(ipx+1)*10+(ipy+3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx && fpy==ipy+4) && ( box(ipx-1,ipy+1)==otherplr) && (box(ipx-2,ipy+2)==0) && (box(ipx-1,ipy+3)==otherplr)
        check=1;     
        box(ipx-1,ipy+1)=0;  
        box(ipx-1,ipy+3)=0;  
        xy=(ipx-1)*10+(ipy+1);
        set(ha(xy),'CData',blank);
        xy=(ipx-1)*10+(ipy+3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx && fpy==ipy-4) && ( box(ipx+1,ipy-1)==otherplr) && (box(ipx+2,ipy-2)==0) && (box(ipx+1,ipy-3)==otherplr)
        check=1;     
        box(ipx+1,ipy-1)=0;  
        box(ipx+1,ipy-3)=0;  
        xy=(ipx+1)*10+(ipy-1);
        set(ha(xy),'CData',blank);
        xy=(ipx+1)*10+(ipy-3);
        set(ha(xy),'CData',blank);
    elseif (fpx==ipx && fpy==ipy-4) && ( box(ipx-1,ipy-1)==otherplr) && (box(ipx-2,ipy-2)==0) && (box(ipx-1,ipy-3)==otherplr)
        check=1;     
        box(ipx-1,ipy-1)=0;  
        box(ipx-1,ipy-3)=0;  
        xy=(ipx-1)*10+(ipy-1);
        set(ha(xy),'CData',blank);
        xy=(ipx-1)*10+(ipy-3);
        set(ha(xy),'CData',blank); 
    else
        check=0;
    end
end