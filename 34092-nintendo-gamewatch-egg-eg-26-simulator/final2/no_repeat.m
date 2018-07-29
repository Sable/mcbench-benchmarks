function orv_new=no_repeat(orv)
uo=unique(orv);


uu=false(size(uo)); % was used, no one used
orv_new=[];
for uc=1:length(orv)
    o1=orv(uc); % current of orv
    oind=find(o1==uo); % index in unique
    if ~uu(oind) % if was not used
        uu(oind)=true;
        orv_new=[orv_new o1];
    end
    
end