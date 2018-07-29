function warp_out=param_update(warp_in,delta_p,transform)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% WARP_OUT=PARAM_UPDATE(WARP_IN,DELTA_P,TRANSFORM)
% This function updates the parameter values by adding the correction values
% of DELTA_P to the current warp values in WARP_IN.
%
% Input variables:
% WARP_IN:      the current warp transform,
% DELTA_P:      the current correction parameter vector,
% TRANSFORM:    the type of adopted transform, accepted strings:
%               {'translation','euclidean','affine','homography'}.
% Output:
% WARP:         the new (updated) warp transform
%--------------------------------------
% $ Ver: 1.4, 12/2/2013,  released by Georgios D. Evangelidis.
% Email: georgios.evangelidis@inria.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(transform,'homography')
    delta_p=[delta_p; 0];
    warp_out=warp_in + reshape(delta_p, 3, 3);
    warp_out(3,3)=1;
end

if strcmp(transform,'affine')

    warp_out(1:2,:)=warp_in(1:2,:)+reshape(delta_p, 2, 3);
    warp_out=[warp_out;zeros(1,3)];
    warp_out(3,3)=1;
end

if strcmp(transform,'translation')
    warp_out =warp_in + delta_p;
end

if strcmp(transform, 'euclidean')
    
    theta = acos(warp_in(1,1))+delta_p(1);
    tx = warp_in(1,3)+delta_p(2);
    ty = warp_in(2,3)+delta_p(3);
    warp_out = [cos(theta) -sin(theta) tx;...
                sin(theta) cos(theta) ty;...
                    0         0        1];
                
end
