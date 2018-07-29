function J = warp_jacobian(nx, ny, warp, transform)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%J = WARP_JACOBIAN(NX, NY, WARP, TRANSFORM)
% This function computes the jacobian J of warp transform with respect 
% to parameters. In case of homography/euclidean transform, the jacobian depends on
% the parameter values, while in affine/translation case is totally invariant.
%
% Input variables:
% NX:           the x-coordinate values of the horizontal side of ROI (i.e. [xmin:xmax]),
% NY:           the y-coordinate values of vertical side of ROI (i.e. [ymin:ymax]),
% WARP:         the warp transform (used only in homography and euclidean case),
% TRANSFORM:    the type of adopted transform
% {'affine''homography','translation','euclidean'}
% 
% Output:
% J:            The jacobian matrix J
%--------------------------------------
% $ Ver: 1.3, 13/5/2012,  released by Georgios D. Evangelidis, INRIA, FRANCE
% Email: georgios.evangelidis@inria.fr
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

snx=length(nx);
sny=length(ny);

Jx=nx(ones(1,sny),:);
Jy=ny(ones(1,snx),:)';
J0=0*Jx;
J1=J0+1;


switch lower(transform)
    case 'homography'

    xy=[Jx(:)';Jy(:)';ones(1,snx*sny)];


    %3x3 matrix transformation
    A = warp;
    A(3,3) = 1;

    % new coordinates
    xy_prime = A * xy;



    % division due to homogeneous coordinates
    xy_prime(1,:) = xy_prime(1,:)./xy_prime(3,:);
    xy_prime(2,:) = xy_prime(2,:)./xy_prime(3,:);

    den = xy_prime(3,:)';

    Jx(:) = Jx(:) ./ den;
    Jy(:) = Jy(:) ./ den;
    J1(:) = J1(:) ./ den;

    Jxx_prime = Jx;
    Jxx_prime(:) = Jxx_prime(:) .* xy_prime(1,:)';
    Jyx_prime = Jy;
    Jyx_prime(:) = Jyx_prime(:) .* xy_prime(1,:)';

    Jxy_prime = Jx;
    Jxy_prime(:) = Jxy_prime(:) .* xy_prime(2,:)';
    Jyy_prime = Jy;
    Jyy_prime(:) = Jyy_prime(:) .* xy_prime(2,:)';


    J = [Jx, J0, -Jxx_prime, Jy, J0, - Jyx_prime, J1, J0;...
        J0, Jx, -Jxy_prime, J0, Jy, -Jyy_prime, J0, J1];

        case 'affine'


    J = [Jx, J0, Jy, J0, J1, J0;... 
        J0, Jx, J0, Jy, J0, J1];
    case 'translation'

    J = [J1, J0;...
        J0, J1];

    case 'euclidean'
        
        mycos = warp(1,1);
        mysin = warp(2,1);
        
        Jx_prime = -mysin*Jx - mycos*Jy;
        Jy_prime =  mycos*Jx - mysin*Jy;

        J = [Jx_prime, J1, J0;...
            Jy_prime, J0, J1];
        
    otherwise
        error('function WARP_JACOBIAN: Unknown transform!');
end




