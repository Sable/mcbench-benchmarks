function [Who, Num, G]=RejectByS(OutOfWho,S,M)

Who=OutOfWho;
Num=length(Who);
G=Goodness(Who,M);
while length(Who)>1
    Drop = nchoosek(Who,S);
    L=size(Drop,1);
    a=zeros(1,L);
    for l=1:L
        a(l)=Goodness(setdiff(Who,Drop(l,:)),M);
    end
    [g, Pick]=max(a);
    Who=setdiff(Who,Drop(Pick,:));
    G=[G g];
    Num=[Num length(Who)];
end