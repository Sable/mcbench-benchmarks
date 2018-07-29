function opa=decimate_optimums(z,op,opv)
% z  zeros
% op optimums from d/dt=0
% opv optimums values
Lz=length(z);
Lop=length(op);
zop=[z; op];
zopv=[zeros(size(z)); opv]; % values
[zops ind]=sort(zop);
zopsv=zopv(ind);
isz=(ind<=Lz); % if zero in zops list
iszind=find(isz);
L1=length(iszind);
opa=[];
opva=[];
wasused=false(size(zops)); % what optimums was already used
for c=1:L1-1
    ind1=iszind(c);
    z1=zops(ind1);
%     if z1>1.47e4
%         'here'
%     end
    ind2=iszind(c+1);
    z2=zops(ind2);
    %ii=ind1+1:ind2-1;
    
    if (ind2+1)<=length(isz)
        inOnePlace=(~isz(ind2+1))&&(zops(ind2)==zops(ind2+1));
    else
        inOnePlace=false;
    end
    
    if inOnePlace
        % optimum and zero in one place
        ii=ind1+1:ind2+1;
    else
        ii=ind1+1:ind2;
    end
    wasused1=wasused(ii);
    
    ii=ii(~wasused1);
    
%     isz1=isz(ii);
%     isz2=~isz1; % what is optimums
%     isz3=isz2&(~wasused1); % optimums that was not used
%     %if all(isz(ii))
%     if any(isz3) % if any optimums that was not used
%         
%     else
%         % case when zeros and maximum are same
%         ii=ind1+1:ind2+1;
%     end
    if ~isempty(ii)
        opt=zops(ii); % optimums between z1 and z2
        optv=zopsv(ii); % values
        [mx mxi]=max(abs(optv));
        opa=[opa; opt(mxi)];
        opva=[opva; optv(mxi)];
        wasused(ii(mxi))=true;
    end
end

mdf=0.005;

% detete optimums that to smaller in compare to bigest optimum:
bo=max(abs(opva));
indo=find(abs(opva)>=mdf*bo);
opa=opa(indo);

% delete repeated points:
opa=unique(opa);