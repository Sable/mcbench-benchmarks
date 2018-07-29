function B=ferrofluid(n)

% This function simulates a particular case of ferrofluid manifestation
% however it is not based on ferrofluid equation, but provides a similar
% behavior 
% Input :  n : parameter that controls the length of the matrix H, n<10.

% (c), KHMOU Youssef, Applied Mathematics 2013 

m=cell2mat(arrayfun(@(x) x:-1:1,1:n,'UniformOutput',0));

H=m'*m;
H=H./max(H(:));
k=3;
H2=rot90(H,k);
H3=rot90(H);
H4=rot90(H2,k);
B=[H H2;H3 H4];
[x]=size(B);
R=x(1)/2;
for ii=1:x(1)
    for jj=1:x(2)
        
        m=sqrt(((ii-R).^2)+((jj-R).^2));
        if (m>=R)
            B(ii,jj)=0;
        end
    end
end
close all

figure, surf(B), shading interp, 
xlabel('Pseudo Bx intensity','Fontsize',12);
ylabel('Pseudo By intensity','Fontsize',12);
zlabel('Pseudo Bz intensity','FontSize',12);
title('Ferrofluid shape simulation','Fontsize',12);
%axis([0 p1 0 p2 0 1]);
colorbar 
colormap gray
theta=-38;
phi=52;
view(theta,phi)

