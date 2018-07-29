
% Program_3c - The Mandelbrot Set in Color.
% Program supplied by Steve Lord from The MathWorks.
% Copyright Birkhauser 2013.

% Define parameters
Nmax = 50;   scale = 0.005;
xmin = -2.4; xmax  = 1.2;
ymin = -1.5;  ymax  = 1.5;

% Generate X and Y coordinates and Z complex values
[x,y]=meshgrid(xmin:scale:xmax, ymin:scale:ymax);
z = x+1i*y;

% Generate w accumulation matrix and k counting matrix
w = zeros(size(z));
k = zeros(size(z));

% Start off with the first step ...
N = 0;

% While N is less than Nmax and any k's are left as 0 
while N<Nmax && ~all(k(:))
    % Square w, add z
    w = w.^2+z;
    % Increment iteration count
    N = N+1;
    % Any k locations for which abs(w)>4 at this iteration and no
    % previous iteration get assigned the value of N
    k(~k & abs(w)>4) = N;
end

% If any k's are equal to 0 (i.e. the corresponding w's never blew up) set
% them to the final iteration number
k(k==0) = Nmax;

% Open a new figure
figure

% Display the matrix as a surface
s=pcolor(x,y,k);

% If you truly want the Mandelbrot curve in B&W, comment the above line and
% uncomment these two
% s = pcolor(x, y, mod(k, 2));
% colormap([0 0 0;1 1 1])

% Turn off the edges of the surface (because the cells are so small, the
% edges would drown out any useful information if we left them black)
set(s,'edgecolor','none')

% Adjust axis limits, ticks, and tick labels
axis([xmin xmax -ymax ymax])
fontsize=15;
set(gca,'XTick',xmin:0.4:xmax,'FontSize',fontsize)
set(gca,'YTick',-ymax:0.5:ymax,'FontSize',fontsize)
xlabel('Re z','FontSize',fontsize)
ylabel('Im z','FontSize',fontsize)

keyboard
figure

% End of Probgram_3c.