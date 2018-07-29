% Chapter 12 - Bifurcation Theory.
% Programs_12a - Animation of a Simple Curve.
% Copyright Birkhauser 2013. Stephen Lynch.

% The curve y=mu-x^2, for mu from -4 to +4.
clear
axis tight
% Record the movie
x=-4:.1:4;
for n = 1:9 
    plot(x,(n-5)-x.^2,x,0);
    M(n) = getframe;
end
% Use the movieviewer to watch the animation.
movieview(M)

% End of Programs_12a.