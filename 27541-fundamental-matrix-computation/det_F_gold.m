% function F = det_F_gold(x1,x2,L_COST,SAMPSON_APPROXIMATION,NORMALIZE)
% Determines the F by iteratively minimizing the geometric error
% Algorithm 11.2 in Hartley & Zisserman, Multiple View Geometry in Computer
% Vision
% Inputs:
%           x1                      3xN coordinates of matched points in image 1(homogeneous)
%           x2                      3xN coordinates of matched points in image 2(homogeneous)
%           L_COST                  1x1 (optional) controls penalization scheme
%                                       for the cost function: L_COST 1 leads to L_1 minimization of
%                                       the average geometric cost (the one mentioned in the book)
%           SAMPSON_APPROXIMATION   1x1 (optional) if enabled,
%                                       approximates the geometric mean with the sampson cost
%           NORMALIZE               1x1 (optional)determines if the algorithm 
%                                       should use the normalized points
% Outputs:
%           F                       3x3 the fundamental matrix 
% 
% Author: Omid Aghazadeh, KTH(Royal Institute of Technology), 2010/05/09
function F = det_F_gold(x1,x2,L_COST,SAMPSON_APPROXIMATION,NORMALIZE)
if sum(size(x1)~=size(x2)), error('size of correspondences do not match!'), end
if size(x1,1) ~= 3, error('invalid points'), end
global MAX_FUN_EVAL MAX_ITER TOL_X TOL_FUN;
if nargin<3, L_COST = 1; end;
if nargin<4, SAMPSON_APPROXIMATION = 0; end
if nargin<5, NORMALIZE = 1; end;
if NORMALIZE
    nmat1 = get_normalization_matrix(x1); % isotropic normalization (translation/scaling)
    nmat2 = get_normalization_matrix(x2);
    x1n = nmat1*x1; 
    x2n = nmat2*x2;
else
    nmat1 = eye(3); nmat2 = eye(3); x1n = x1; x2n = x2;
end
x1n = x1n./repmat(x1n(3,:),3,1); x2n = x2n./repmat(x2n(3,:),3,1); % normalizing points so their last coordinate is 1
F_0 = det_F_normalized_8point(x1n,x2n);
%% (ii)

[e,e_prime] = get_epipole(F_0);
e_prime_cross = get_x_cross(e_prime);
P2 = [e_prime_cross*F_0 e_prime];

%% (iii) minimze the cost

if ~ SAMPSON_APPROXIMATION
    [P2] = lsqnonlin(@(p2)costGold(x1n,x2n,p2,L_COST),P2,[],[],optimset('Display','off','TolX',TOL_X,'TolFun',TOL_FUN,'MaxFunEval',MAX_FUN_EVAL,'MaxIter',MAX_ITER,'Algorithm',{'levenberg-marquardt' 0.01}));
else
    [P2] = lsqnonlin(@(p2)costSampson(x1n,x2n,p2),P2,[],[],optimset('Display','off','TolX',TOL_X,'TolFun',TOL_FUN,'MaxFunEval',MAX_FUN_EVAL,'MaxIter',MAX_ITER,'Algorithm',{'levenberg-marquardt' 0.01}));
end

Fhat = get_x_cross(P2(:,4))*P2(:,1:3);

F= nmat2' * Fhat* nmat1; % denormalization

end

%% function scost = costGold(x1,x2,P2,L_COST)
% this is the cost function for the Gold Standard algoritghm. The
% triangulation method is the inhomogeneous one(chapter 12 of the book)
function scost = costGold(x1,x2,P2,L_COST)
Xhat = triangulate(x1,x2,P2,1);
xhat1 = Xhat(1:3,:)./repmat(Xhat(3,:),3,1); % the first camera is assumed to be [I|0]
xhat2 = P2 * Xhat;
xhat2 = xhat2./repmat(xhat2(3,:),3,1);
cost = ((x1(:)-xhat1(:)).^2 + (x2(:)-xhat2(:)).^2);
scost = sqrt(sum(cost))^L_COST;
end

%% function scost = costSampson(x1,x2,P2)
% this is the cost function for the sampson approximation. It implements an
% over-parametrization of F, however the minimal solution can be easily
% integrated here.
function scost = costSampson(x1,x2,P2)
F = get_x_cross(P2(:,4))*P2(:,1:3);
Fx1 = F*x1;
Ftx2 = F'*x2;
num = sum(x2 .* Fx1,1).^2;
denum= sum(Fx1(1:2,:).^2,1) + sum(Ftx2(1:2,:).^2,1);
cost = num./denum;
scost = sqrt(sum(cost));
end
