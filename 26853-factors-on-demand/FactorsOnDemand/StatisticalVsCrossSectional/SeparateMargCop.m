function [W,F,U]=SeparateMargCop(V)

[J,K]=size(V);
F=0*V;

[W,C]=sort(V);
for k=1:K
    x=C(:,k);
    y=[1:J];
    xi=[1:J];
    yi = interp1(x,y,xi);
    U(:,k)=yi/(J+1);
    F(:,k)=[1:J]'/(J+1);
end