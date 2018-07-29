function [W, p, t] = build7(im, angles)
t_s = toc;
%Pad image
[im_pad,D] = impad(im,'diag',1);
sz = size(im);
m = sz(1); %rows
n = sz(2); %cols
n_proj = length(angles);
N = m*n; %number of unknown variables
M = D*n_proj; %number of equations
%Weighting Factor Matrix
try
    W = zeros(M,N);
catch expr
    fprintf([expr.message '\nGenerates a sparse.\r'])
    W = sparse(M,N);
end
%proj_info = zeros(M,2); %[theta No.]
p = zeros(M,1); %projection vector
ix = false(M,1);
rc = [m;n]/2+0.5;
fprintf('Building Weight Matrix...\r')
[x,y] = ind2sub(sz,1:N);
%xy = [x;y]; %x,y coordinate
%x,y coordinate with respect to rotation center
xy_c = [x;y]-repmat(rc,1,N);
d = 1; %side length of square
A0 = d^2;
H = @heaviside;
try
    A = zeros(D,N);
catch expr
    fprintf(['Building A...\n' ...
        expr.message '\nGenerating a sparse...\r'])
    A = sparse(D,N);
end
for kp = 1:n_proj
    A(:) = 0; %#
    im_rot = imrotate(im_pad,-angles(kp),'bilinear','crop');
    pvec = sum(im_rot,1);
    t = -angles(kp)/180*pi;
    R = [cos(t) -sin(t);sin(t) cos(t)];
    fprintf('\nAngle No.%d(%d Degree)\r',kp,angles(kp))
    xy_rot = R*xy_c+D/2+0.5;
    idx = round(xy_rot(2,:));
    ixM = D*(kp-1)+idx; %corresponding indice in W and p matrix
    %Calculate Area
    x1 = d*min(abs([sin(t) cos(t)]))+eps;
    x2 = d*max(abs([sin(t) cos(t)]))-eps;
    l = x1+x2;
    h = d^2/x2;
    %A0 = d^2;
    A1 = x1*h/2;
    G1 = @(x) H(x)-H(x-x1);
    G2 = @(x) H(x-x1)-H(x-x2);
    G3 = @(x) H(x-x2)-H(x-l);
    f_A = @(x) (x/x1).^2*A1.*G1(x)+...
        (A1+h*(x-x1)).*G2(x)+...
        (A0-((l-x)/x1).^2.*A1).*G3(x)+...
        A0*H(x-l);
    x0 = xy_rot(2,:)-l/2;
    S1 = f_A((idx-0.5)-x0);
    S2 = f_A((idx+0.5)-x0);
    for kn = 1:N
        A(idx(kn)-1,kn) = S1(kn);
        A(idx(kn)  ,kn) = S2(kn)-S1(kn);
        A(idx(kn)+1,kn) = 1-S2(kn);
        p(ixM(kn)) = pvec(idx(kn));
        ix(ixM(kn)) = true;
    end
    W((D*(kp-1)+(1:D)),:) = A; %#
end
% %
%Delete all-zero rows in W
fprintf('\nDelete all-zero rows in W...\r')
%ix = sum(W,2)==0;
try
    W(~ix,:) = [];
catch expr
    fprintf([expr.message '\nConverting to sparse...\r'])
    W = sparse(W);
    W(~ix,:) = [];
end
p(~ix) = [];
n_eq = size(W,1);
fprintf('\nFinish building A. \n%d equations in total.\r',n_eq);
figure('name','Sparsity pattern of matrix W');
spy(W)
t_e = toc;
t = t_e-t_s;
fprintf('\nTotal: %f seconds\n\r',t);
end
