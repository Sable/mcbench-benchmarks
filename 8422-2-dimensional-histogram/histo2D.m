% function H = histo2D(D,[Xlo Xhi],Xn,[Ylo Yhi],Yn,Xlab,Ylab,Title)
% 
% 2 Dimensional Histogram (size(H) == [Yn Xn])
% Counts number of points in the bins defined by 
% X = linspace(Xlo,Xhi,Xn) and
% Y = linspace(Ylo,Yhi,Yn) 

function H = histo2D(D,Xrange,Xn,Yrange,Yn,Xlab,Ylab,Title)

Xlo = Xrange(1) ; Xhi = Xrange(2) ; 
Ylo = Yrange(1) ; Yhi = Yrange(2) ; 
X = linspace(Xlo,Xhi,Xn)' ;
Y = linspace(Ylo,Yhi,Yn)' ;

Dx = D(:,1) ; Dy = D(:,2) ;
n = length(D) ;

H = zeros(Yn,Xn) ;

for i = 1:n
    x = dsearchn(X,Dx(i)) ;
    y = dsearchn(Y,Dy(i)) ;
    H(y,x) = H(y,x) + 1 ;
end ;

figure , pcolor(X,Y,H) ;
% Xmid = 0.5*(X(1:end-1)+X(2:end)) ;
% Ymid = 0.5*(Y(1:end-1)+Y(2:end)) ;
% figure , pcolor(Xmid,Ymid,H) ; 
colorbar ; shading flat ; axis square tight ; grid on ; 
xlabel(Xlab) ; xlabel(Ylab) ; title(Title) ;