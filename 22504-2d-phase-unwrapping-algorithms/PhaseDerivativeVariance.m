%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PhaseDerivativeVariance creates a phase quality map by 
% computing the variance of the partial derivatives of the 
% locally unwrapped phase. This is then used
% to guide the phase unwrapping path. Uses only the 4 nearest 
% neighbours. The user may also input a binary mask.
% Created by B.S. Spottiswoode on 18/10/2004
% Last modified on 06/12/2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function derivative_variance=PhaseDerivativeVariance(IM_phase, varargin);

[r_dim,c_dim]=size(IM_phase);
if nargin>=2                                    %Has a mask been included? If so crop the image to the mask borders to save computational time
    IM_mask=varargin{1};
    [maskrows,maskcols]=find(IM_mask);          %Identify coordinates of the mask
    minrow=min(maskrows)-1;                     %Identify the limits of the mask 
    maxrow=max(maskrows)+1;
    mincol=min(maskcols)-1;
    maxcol=max(maskcols)+1;
    width=maxcol-mincol;                        %Now ensure that the cropped area is square
    height=maxrow-minrow;
    if height>width
        maxcol=maxcol + floor((height-width)/2) + mod(height-width,2);
        mincol=mincol - floor((height-width)/2);
    elseif width>height
        maxrow=maxrow + floor((width-height)/2) + mod(width-height,2);
        minrow=minrow - floor((width-height)/2);
    end
    if minrow<1 minrow=1; end
    if maxrow>r_dim maxrow=r_dim; end
    if mincol<1 mincol=1; end
    if maxcol>c_dim maxcol=c_dim; end
    IM_phase=IM_phase(minrow:maxrow, mincol:maxcol);        %Crop the original image to save computation time
end
    
[dimx, dimy]=size(IM_phase);
dx=zeros(dimx,dimy);
p=unwrap([IM_phase(:,1) IM_phase(:,2)],[],2);
dx(:,1)=(p(:,2) - IM_phase(:,1))./2;                    %Take the partial derivative of the unwrapped phase in the x-direction for the first column
p=unwrap([IM_phase(:,dimy-1) IM_phase(:,dimy)],[],2);
dx(:,dimy)=(p(:,2) - IM_phase(:,dimy-1))./2;            %Take the partial derivative of the unwrapped phase in the x-direction for the last column
for i=2:dimy-1
    p=unwrap([IM_phase(:,i-1) IM_phase(:,i+1)],[],2);
    dx(:,i)=(p(:,2) - IM_phase(:,i-1))./3;              %Take partial derivative of the unwrapped phase in the x-direction for the remaining columns
end

dy=zeros(dimx,dimy);
q=unwrap([IM_phase(1,:)' IM_phase(2,:)'],[],2);
dy(1,:)=(q(:,2)' - IM_phase(1,:))./2;                   %Take the partial derivative of the unwrapped phase in the y-direction for the first row
p=unwrap([IM_phase(dimx-1,:)' IM_phase(dimx,:)'],[],2);
dy(dimx,:)=(q(:,2)' - IM_phase(dimx-1,:))./2;           %Take the partial derivative of the unwrapped phase in the y-direction for the last row
for i=2:dimx-1
    q=unwrap([IM_phase(i-1,:)' IM_phase(i+1,:)'],[],2);
    dy(i,:)=(q(:,2)' - IM_phase(i-1,:))./3;             %Take the partial derivative of the unwrapped phase in the y-direction for the remaining rows
end

dx_centre=dx(2:dimx-1, 2:dimy-1);
dx_left=dx(2:dimx-1,1:dimy-2); 
dx_right=dx(2:dimx-1,3:dimy);
dx_above=dx(1:dimx-2,2:dimy-1);
dx_below=dx(3:dimx,2:dimy-1);
mean_dx=(dx_centre+dx_left+dx_right+dx_above+dx_below)./5;

dy_centre=dy(2:dimx-1, 2:dimy-1);
dy_left=dy(2:dimx-1,1:dimy-2); 
dy_right=dy(2:dimx-1,3:dimy);
dy_above=dy(1:dimx-2,2:dimy-1);
dy_below=dy(3:dimx,2:dimy-1);
mean_dy=(dy_centre+dy_left+dy_right+dy_above+dy_below)./5;

stdvarx=sqrt( (dx_left - mean_dx).^2 + (dx_right - mean_dx).^2 + ...
              (dx_above - mean_dx).^2 + (dx_below - mean_dx).^2 + (dx_centre - mean_dx).^2 ); 
stdvary=sqrt( (dy_left - mean_dy).^2 + (dy_right - mean_dy).^2 + ...
              (dy_above - mean_dy).^2 + (dy_below - mean_dy).^2 + (dy_centre - mean_dy).^2 ); 
derivative_variance=100*ones(dimx, dimy);                         %Ensure that the border pixels have high derivative variance values
derivative_variance(2:dimx-1, 2:dimy-1)=stdvarx + stdvary;

if nargin>=2                                                      %Does the image have to be padded back to the original size?
    [orig_rows, orig_cols]=size(IM_mask);
    temp=100*ones(orig_rows, orig_cols);
    temp(minrow:maxrow, mincol:maxcol)=derivative_variance;       %Pad the remaining pixels with poor phase quality values
    derivative_variance=temp;
end

