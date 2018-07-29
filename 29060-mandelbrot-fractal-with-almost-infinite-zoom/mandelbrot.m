function mandelbrot
% Plots a Mandelbrot fractal which is updated after you zoom in

% Define options, all options are stored in OPT structure
OPT.mm            =   700; % number of pixels (detail) in x direction
OPT.nn            =   400; % number of pixels (detail) in y direction
OPT.max_iteration =   500; % higher number makes calculation slower, but up
                           % to 1e5 calculation time is still acceptable
OPT.colorFcn      = @() jet; 
OPT.plotFcn       = @(c) mod(c',100); 
OPT.updateTime    = 0.5; % interval at which to update drawing;
% OPT.plotFcn       = @c) log(c')*10; % some examples for scaling of the colors
% OPT.plotFcn       = @(c) c'; % no scaling

% make base figure
c       = zeros(OPT.nn,OPT.mm)*64; % c is variable with color information
OPT.hf  = imagesc([-2.5 1],[-1 1],c); 
OPT.hfp = get(OPT.hf,'parent');
set(OPT.hfp,'YDir','reverse')
set(OPT.hfp,'DataAspectRatio',[1 1 1])
colormap(OPT.colorFcn());

% update with base fractal
updateDrawing([],[],OPT)

% set function to do update when zooiming in
z = zoom(gcf);
set(z,'ActionPostCallback',{@updateDrawing,OPT});
set(z,'Enable','on');

function updateDrawing(~,~,OPT)
% extract data and settings from figure
c       = get(OPT.hf ,'CData')';
x_lim   = get(OPT.hfp,'XLim' );
y_lim   = get(OPT.hfp,'YLim' );
x_lim_c = get(OPT.hf ,'XData');
y_lim_c = get(OPT.hf ,'YData');

% interpolate c to new boundaries
[X,Y] = meshgrid(...
    linspace(x_lim_c(1),x_lim_c(2),OPT.mm),...
    linspace(y_lim_c(1),y_lim_c(2),OPT.nn));
[XI,YI] = meshgrid(...
    linspace(x_lim(1),x_lim(2),OPT.mm),...
    linspace(y_lim(1),y_lim(2),OPT.nn));
c = interp2(X,Y,c',XI,YI,'nearest')';

% draw the new c data
set(OPT.hf,'CData',OPT.plotFcn(c),'XData',x_lim,'YData',y_lim)
drawnow

% calculate scaling variables
xa = (x_lim(2)-x_lim(1));
xb = x_lim(1);
ya = (y_lim(2)-y_lim(1));
yb = y_lim(1);
max_iteration = OPT.max_iteration;

tic
for ii = 1:OPT.mm 
    % make a parfor here, but you have to disable the firgure updateing for
    % parallelization to work
    
    x0 = (ii/OPT.mm)*xa+xb; 
    tempc = nan(1,OPT.nn);
    for jj = 1:OPT.nn
        y0 = (jj/OPT.nn)*ya+yb;
        x = 0;
        y = 0;
        iteration = 0;
        
        % do the actual fractal calculation
        while x*x + y*y <= 4 && iteration < max_iteration
            xtemp = x*x - y*y + x0;
            y = 2*x*y + y0;
            x = xtemp;
            iteration = iteration + 1;
        end
        
        tempc(jj) = iteration;
    end
    c(ii,:) = tempc;
    % disable below for parallelization
    if toc>OPT.updateTime 
        set(OPT.hf,'CData',OPT.plotFcn(c));
        drawnow
        tic
    end
end

set(OPT.hf,'CData',OPT.plotFcn(c))
drawnow
