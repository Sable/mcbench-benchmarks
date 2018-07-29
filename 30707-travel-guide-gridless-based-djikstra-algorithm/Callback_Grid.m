function Callback_Grid(handy,varargin)

global hand travel pt1 pt2 Adj_Mat counts cord1 cord2 lnhd;

mm=varargin{2};

if travel,
    set(handy,'color','m','FontSize',25);    
    if isempty(pt1),
        pt1=get(handy,'position');
        pt1=pt1(1:2);
        cord1=mm;
    else
        pt2=get(handy,'position');
        pt2=pt2(1:2);
        cord2=mm;
        travel=0;
        [shortpath,flag]=ShortDist(cord1,cord2,Adj_Mat);
        if ~flag,
            msg={'Undefined Route between selected Points!!!'};     
            msghand=msgbox(msg,'Try Again!!!','warn');
            pause(2);
            close(msghand);
            TravelGuide('Travel');
        else
            for kk=1:length(shortpath)-1,
                pt1=get(hand(shortpath(kk)),'position');
                pt1=pt1(1:2);
                pt2=get(hand(shortpath(kk+1)),'position');
                pt2=pt2(1:2);
                p=pt1(1); q=pt1(2); r=pt2(1); s=pt2(2);
                counts=counts+1;
                lnhd(counts)=line([p r],[q s],'color','m','LineWidth',2);
            end   
        end
    end
end