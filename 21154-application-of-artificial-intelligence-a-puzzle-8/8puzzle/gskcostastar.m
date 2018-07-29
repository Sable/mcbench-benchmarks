function [intv0h1,intv0h2] =  gskcostastar(pzstat,pzrstat)
% % % % Cost estimation....
% % h1 
intv0h1=sum(sum(~(pzstat ==pzrstat)));
% % h2
intv0h2 = 0;
for intv000 = 1 : 3
    for intv001 = 1 : 3
        intv002 = pzstat(intv000,intv001);
        [intv003 intv004] = find(pzrstat == intv002);
        intv0h2 = intv0h2 + abs(intv003 - intv000) + abs(intv004 - intv001);
    end
end