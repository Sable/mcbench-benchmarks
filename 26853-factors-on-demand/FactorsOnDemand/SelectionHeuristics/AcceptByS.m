function [Who, Num, G]=AcceptByS(OutOfWho,S,M)

N=length(OutOfWho);

Who=[];
Num=[];
G=[];
while length(Who)<N

    Candidates=setdiff(OutOfWho,Who);
    Combos = nchoosek(Candidates,S);
    L=size(Combos,1);
    a=zeros(1,L);
    for l=1:L
        a(l)=Goodness([Who Combos(l,:)],M);
    end
    [g, Pick]=max(a);
    Who=[Who Combos(Pick,:)];
    G=[G g];
    Num=[Num length(Who)];

end