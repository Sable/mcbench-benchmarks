function G = image_jacobian(gx, gy, jac, nop)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%G = IMAGE_JACOBIAN(GX, GY, JAC, NOP)
% This function computes the jacobian G of the warped image wrt parameters. 
% This matrix depends on the gradient of the warped image, as 
% well as on the jacobian JAC of the warp transform wrt parameters. 
% For a detailed definition of matrix G, see the paper text.
%
% Input variables:
% GX:           the warped image gradient in x (horizontal) direction,
% GY:           the warped image gradient in y (vertical) direction,
% JAC:            the jacobian matrix J of the warp transform wrt parameters,
% NOP:          the number of parameters.
%
% Output:
% G:            The jacobian matrix G.
%--------------------------------------
% $ Ver: 1.1, 7/1/2012,  released by Georgios D. Evangelidis.
% For any comment, please contact evagelid@ceid.upatras.gr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[h,w]=size(gx);

if nargin<4
    error('Not enough input arguments');
end

gx=repmat(gx,1,nop);
gy=repmat(gy,1,nop);

G=gx.*jac(1:h,:)+gy.*jac(h+1:end,:);
G=reshape(G,h*w,nop);