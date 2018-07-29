function [W, p, t] = build1(im, angles)
t_s = toc;
%Pad image
[im_pad,D] = impad(im,'diag',0);
sz = size(im);
m = sz(1); %rows
n = sz(2); %cols
n_proj = length(angles);
N = m*n; %number of unknown variables
M = D*n_proj; %number of equations
try
    W = zeros(M,N); %weighting factor matrix
catch expr
    fprintf([expr.message '\nGenerates a sparse.\r'])
    W = sparse(M,N);
end
%proj_info = zeros(M,2); %[theta No.]
p = zeros(M,1); %projection vector
ix = false(M,1);
rc = [m;n]/2+0.5;
%cnt = 0;
fprintf('Building Weight Matrix...\r')
for kp = 1:n_proj
    im_rot = imrotate(im_pad,-angles(kp),'bilinear','crop');
    pvec = sum(im_rot,1);
    t = -angles(kp)/180*pi;
    R = [cos(t) -sin(t);sin(t) cos(t)];
    %L = m*abs(sin(t))+n*abs(cos(t));
    %offset = ceil((D-L)/2);
    fprintf('\nAngle No.%d(%d Degree)\r',kp,angles(kp))
    for kn = 1:N
        [x,y] = ind2sub(sz,kn);
        xy_rot = R*([x;y]-rc)+D/2+0.5;
        idx = round(xy_rot(2));%#
        %corresponding indice in W and p matrix
        ixM = D*(kp-1)+idx;
        W(ixM,kn) = 1;
        %W(D*(kp-1)+idx,kn) = 1;
        %W(cnt+idx-offset,kn) = 1;
        %p(cnt+idx-offset) = projmat(kp,idx);%#
        if ~ix(ixM)
            p(ixM) = pvec(idx);
            ix(ixM) = true;
        end
        %p(D*(kp-1)+idx) = projmat(kp,idx);
        %proj_info(cnt+idx-offset,:) = [kp,idx];
    end
    %cnt = cnt+(D-2*offset);
    %fprintf('%d equations built.\r',D-2*offset)
end
% %
W = sparse(W);

%Delete all-zero rows in W
fprintf('\nDelete all-zero rows in W...\r')
%ix = sum(W,2)==0;
W(~ix,:) = [];
p(~ix) = [];
n_eq = size(W,1);
fprintf('\nFinish building A. \n%d equations in total.\r',n_eq);
figure('name','Sparsity pattern of matrix W');
spy(W)
t_e = toc;
t = t_e-t_s;
fprintf('\nTotal: %f seconds\n\r',t);
end
