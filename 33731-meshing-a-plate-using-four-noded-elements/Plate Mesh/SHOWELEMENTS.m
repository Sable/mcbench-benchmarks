function SHOWELEMENTS(ShowElements,ShowNodes,coordinates,X,Y,nel,nodes,nnode)
%--------------------------------------------------------------------------
%   Purpose:
%           To display and undisplay the Element numbers
%--------------------------------------------------------------------------
ShowElements = get(ShowElements,'Value') ;
ShowNodes = get(ShowNodes,'Value') ;  
% Diaply only Element Numbers
if ShowElements==1 && ShowNodes==0  
    cla(gcf) ;
    patch(X,Y,'w') ;
    for i = 1:nel
        EX = coordinates(nodes(i,:),1) ;EY = coordinates(nodes(i,:),2) ;
        pos = [sum(EX)/4,sum(EY)/4] ;
        text(pos(1),pos(2),int2str(i),'fontsize',8, 'fontweight','bold','color','b');
    end
end
% Display only Node Numbers
if ShowElements==0 && ShowNodes==1
    cla(gcf) ;
    patch(X,Y,'w')
    for i = 1:nnode
        text(coordinates(i,1),coordinates(i,2),int2str(i),'fontsize',8,....
            'fontweight','bold','Color','r'); 
    end    
end
% Display both Element Numbers and Node Numbers
if ShowElements==1 && ShowNodes==1
    cla(gcf) ;
    patch(X,Y,'w') ;
    for i = 1:nel
        EX = coordinates(nodes(i,:),1) ;EY = coordinates(nodes(i,:),2) ;
        pos = [sum(EX)/4,sum(EY)/4] ;
        text(pos(1),pos(2),int2str(i),'fontsize',8, 'fontweight','bold','color','b');
    end
    for i = 1:nnode
        text(coordinates(i,1),coordinates(i,2),int2str(i),'fontsize',8,....
            'fontweight','bold','Color','r'); 
    end   
end
% Display None
if ShowElements==0 && ShowNodes==0
    cla(gcf) ;
    patch(X,Y,'w')
end
return