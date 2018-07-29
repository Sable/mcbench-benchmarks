load('history_734829708443');


r=hisrr(1,:,:);
hp=plot(r(1,:,1),r(1,:,2),'k.');
hold on;
hpr=plot(r(1,:,1),r(1,:,2),'r.'); % to plot close points
hprm=plot(NaN,NaN,'gd');
axis equal;
b=1;
bg=5;
ht=title(' ');
fhisr=find(hisr);
dfhisr=diff(fhisr);
fhisrt=find(hisrt);
for lc=1:10:size(hisrr,1)
    r=hisrr(lc,:,:);
    v=hisrv(lc,:,:);
    tt=hisrt(fhisrt(lc));
    %hisrt(fhisr(lc));
    
    % deifne biggest cluster:
    dr=bsxfun(@minus,permute(r,[2 1 3]),r);
    drn=sum(dr.^2,3);
    drn(1:n+1:end)=inf;
    C=drn<(0.5*d)^2;
    [i1 i2]=find(C);
    [lbs rts]=graph_connected_components(C);
    lbsl=zeros(1,max(lbs));
    for c=1:max(lbs)
        ind=find(lbs==c);
        lbsl(c)=length(ind);
    end
    
    [tmp mx1]=max(lbsl);
    bgi=find(lbs==mx1); % biggest
    
    
    %ii=[i1;i2];
    ii=bgi;
    
    if ~isempty(ii)
        rm=mean(r(1,ii,:),2);
    else
        rm(1,1,1)=0;
        rm(1,1,2)=0;
    end
        
    
    
    
    %dv=bsxfun(@minus,permute(v,[2 1 3]),v); % velociti diferencies
    %dvn=sum(dv.^2,3);
    
    %hp=plot(r(1,:,1),r(1,:,2),'k.');
    set(hp,'Xdata',r(1,:,1),'Ydata',r(1,:,2));
    set(hpr,'Xdata',r(1,ii,1),'Ydata',r(1,ii,2));
    %set(hprm,'Xdata',rm(1,1,1),'Ydata',rm(1,1,2));
    
    % limits to bigest cluster:
    if lc>2000
        xlim(rm(1,1,1)+[-b; b]);
        ylim(rm(1,1,2)+[-b; b]);
    else
        xlim([-bg; bg]);
        ylim([-bg; bg]);
    end
    set(ht,'string',['time: ' num2str(tt)]);
    drawnow;
end