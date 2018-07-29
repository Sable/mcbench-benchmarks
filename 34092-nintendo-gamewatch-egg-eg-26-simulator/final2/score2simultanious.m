function ns=score2simultanious(score,game_type)
if score>1000
    score=mod(score,1000);
    nsadd=1;
else
    nsadd=0;
end
sc=[-1  5  10  50  100  140  190  200  230  280  300  320  370  400  410  460  500  550  600  640  690  700  730  780  800  820  870  900  910  960];
ind=find(score>=sc);
i1=ind(end);
nsa=[2  2  3  4  3  4  5  3  4  5  3  4  5  3  4  5  4  4  4  5  6  4  5  6  4  5  6  4  5  6];
ns=nsa(i1)+nsadd;

if game_type~=1
    ns=ns+1;
end