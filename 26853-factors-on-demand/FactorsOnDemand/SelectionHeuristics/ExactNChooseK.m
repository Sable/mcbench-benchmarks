function [Who, g]=ExactNChooseK(OutOfWho,K,M)

Combos = nchoosek(OutOfWho,K);
L=size(Combos,1);
a=zeros(1,L);
for l=1:L
    a(l)=Goodness(Combos(l,:),M);
end
[g, Pick]=max(a);
Who=Combos(Pick,:);
