% function F = det_F_algebraic(x1,x2,L_COST,NORMALIZE)
% Determines the F by iteratively minimizing the Algebraic error
% Algorithm 11.2 in Hartley & Zisserman, Multiple View Geometry in Computer Vision
% Inputs:
%           x           3xN coordinates of matched points in image 1(homogeneous)
%           xp          3xN coordinates of matched points in image 2(homogeneous)
%           L_COST      1x1 (optional) controls penalization scheme
%                           for the cost function: L_COST 1 leads to L_1 minimization of
%                           the norm of the algebraic error (the one mentioned in the book)
%           NORMALIZE   1x1 (optional) determines if the algorithm should use the normalized points
% Outputs:
%           F           3x3 the fundamental matrix 
% 
% Author: Omid Aghazadeh, KTH(Royal Institute of Technology), 2010/05/09
function F = det_F_algebraic(x1,x2,L_COST,NORMALIZE)
if sum(size(x1)~=size(x2)), error('size of correspondences do not match!'), end
if size(x1,1) ~= 3, error('invalid points'), end
if nargin<3; L_COST = 1; end;
if nargin<4; NORMALIZE = 1; end
global A F_I EPSILON_I L_e TOL_X TOL_FUN MAX_FUN_EVAL MAX_ITER;
if NORMALIZE
    nmat1 = get_normalization_matrix(x1); % isotropic normalization (translation/scaling)
    nmat2 = get_normalization_matrix(x2);
    x1n = nmat1*x1; 
    x2n = nmat2*x2;
    x1n = x1n./repmat(x1n(3,:),3,1); x2n = x2n./repmat(x2n(3,:),3,1); % normalizing points so their last coordinate is 1
else
    nmat1 = eye(3); nmat2 = eye(3); x1n = x1; x2n = x2;
end
F_0 = det_F_normalized_8point(x1n,x2n);

F_0 = F_0/norm(F_0(:));
F_0T = reshape(F_0',9,1); % f corresponds to F_0 in row order
F_I = [F_0T];
A = [(repmat(x2n(1,:),3,1).*x1n)',(repmat(x2n(2,:),3,1).*x1n)',x1n']; % the data matrix

EPSILON_I = norm(A*F_0T)^L_COST; %initial cost

%% (i) finding an initial estimate of the epipole from an initial estimate of F
[e_0,eprime_0] = get_epipole(F_0);
it=0;
L_e = e_0;

e_i = lsqnonlin(@(e)costAlgebraic(A,L_COST,e),e_0,[],[],optimset('Display','off','TolX',TOL_X,'TolFun',TOL_FUN,'MaxFunEval',MAX_FUN_EVAL,'MaxIter',MAX_ITER,'Algorithm',{'levenberg-marquardt' 0.01}));

F = reshape(F_I,3,3)';
F = nmat2'*F*nmat1;
end


%% function x = const_min_subject_span_space(A,G,r)
% finds the vector x that maximizes ||A x|| subject to the constraint ||x||=1 and x=G x_hat
% where G has rank r
function x = const_min_subject_span_space(A,G,r)
[u_g,s_g,v_g] = svd(G);
u_prime = u_g(:,1:r);

[u_a,s_a,v_a] = svd(A*u_prime);
x_p = v_a(:,end);

x = u_prime * x_p;
end

%% epsilon_cost_i = costAlgebraic(A,L_COST,e_i)
% the cost function for LM algorithm. The goal is to minimize || epsilon_i || by varying e_i
function epsilon_cost_i = costAlgebraic(A,L_COST,e_i)
global F_I EPSILON_I L_e;
%% (ii) find f_i that minimizes ||A f_i|| subject to ||f_i|| = 1
e_cross = get_x_cross(e_i);
E = [e_cross zeros(3) zeros(3); zeros(3) e_cross zeros(3); zeros(3) zeros(3) e_cross];
f_i = const_min_subject_span_space(A,E,6);

%% (iii) compute epsilon_i = A f_i and correct its sign
pos_sign = double(sign(e_i'*L_e));
f_i = f_i * pos_sign;

epsilon_i = A*f_i;
epsilon_cost_i = (norm(epsilon_i))^L_COST;

if epsilon_cost_i < EPSILON_I
    EPSILON_I = epsilon_cost_i;
    F_I = f_i;
    L_e = e_i;
end
end

