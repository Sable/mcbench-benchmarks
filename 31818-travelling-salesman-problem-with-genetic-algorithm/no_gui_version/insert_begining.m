function gch=insert_begining_slow(g1,g2,cp)
% insert begining from g2 (g2(1:cp)) to geging of g1 (g1(1:cp))
% return modified g1 in such way

    
for cpc=1:cp
    if g2(cpc)~=g1(cpc) % if not same
        ind=find(g1==g2(cpc)); % then where where is it
        
        % swap:
        g1(ind)=g1(cpc); % send to that place
        g1(cpc)=g2(cpc);
    end
end
gch=g1;