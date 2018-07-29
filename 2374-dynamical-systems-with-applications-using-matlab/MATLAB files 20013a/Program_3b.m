% Chapter 3 - Complex Iterative Maps.
% Program 3b - The Mandelbrot Set.
% Thanks to Steve Lord from The MathWorks for his help.
% Copyright Birkhauser 2013. Stephen Lynch.

% Vectorized program.
% Plot the Mandelbrot set in black and white (Figure 3.2).
Nmax = 50; scale = 0.005;
xmin = -2.4; xmax  = 1.2;
ymin = -1.5; ymax  = 1.5;

% Generate x and y coordinates and z complex values
[x,y]=meshgrid(xmin:scale:xmax,ymin:scale:ymax);
z = x+1i*y;

% Generate w accumulation matrix and k counting matrix
w = zeros(size(z));
k = zeros(size(z));

N = 0;
while N<Nmax && ~all(k(:))
    w = w.^2+z;
    N = N+1;
    k(~k & abs(w)>4) = N;
end
k(k==0) = Nmax;
figure
s = pcolor(x, y, mod(k, 2));
colormap([0 0 0;1 1 1])
set(s,'edgecolor','none')

axis([xmin xmax -ymax ymax])
fsize=15;
set(gca,'XTick',xmin:0.4:xmax,'FontSize',fsize)
set(gca,'YTick',-ymax:0.5:ymax,'FontSize',fsize)
xlabel('Re z','FontSize',fsize)
ylabel('Im z','FontSize',fsize)
% End of Program 3b

