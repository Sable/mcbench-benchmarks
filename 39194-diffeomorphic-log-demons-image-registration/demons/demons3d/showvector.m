%% Display vector field
%  Changed: Dec 11th, 2011
%
function showvector(ux,uy,uz,downsample,scale,lim)

    if nargin<3; downsample = 1; end;
    
    sizex = size(ux,1);
    sizey = size(ux,2);
    sizez = size(ux,3);
    
    % Use mid slice as image
    slice = ceil(sizez/2);
    ux = ux(:,:,slice);
    uy = uy(:,:,slice);
    
    ux  = ux(1:downsample:end, 1:downsample:end);
    uy  = uy(1:downsample:end, 1:downsample:end);
    
    if nargin<5; scale = 3;                     end; % Scale vector to show small ones
    if nargin<6; lim   = [0 sizex-1 0 sizey-1 0 sizez-1]; end; % Display whole image

    [y,x] = ndgrid((1:downsample:sizex)+downsample/2, (1:downsample:sizey)+downsample/2); % coordinate image
    quiver(x,y,ux,uy,scale);                  % show vectors
    daspect([1 1 1]);
    axis([lim(3)-0.5 lim(4)+0.5 lim(1)-0.5 lim(2)+0.5]);      % which vector to show
    set(gca,'YDir','reverse');
    
end

