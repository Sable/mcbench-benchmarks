function [W, p, t] = build4(im, angles)
t_s = toc;
%Pad image
[im_pad,D] = impad(im,'diag',0);
sz = size(im);
m = sz(1); %rows
n = sz(2); %cols
n_proj = length(angles);
N = m*n; %number of unknown variables
M = D*n_proj; %number of equations
W_c = cell(n_proj,1);
%proj_info = zeros(M,2); %[theta No.]
p = zeros(M,1); %projection vector
ix = false(M,1);
rc = [m;n]/2+0.5;
%cnt = 0;
fprintf('Building Weight Matrix...\r')
% for kp = 1:n_proj
%     im_rot = imrotate(im_pad,-angles(kp),'bilinear','crop');
%     projmat(kp,:) = sum(im_rot,1);
%     t = -angles(kp)/180*pi;
%     R = [cos(t) -sin(t);sin(t) cos(t)];
%     %L = m*abs(sin(t))+n*abs(cos(t));
%     %offset = ceil((D-L)/2);
%     fprintf('\nAngle No.%d(%d Degree)\r',kp,angles(kp))
%     for kn = 1:N
%         [x,y] = ind2sub(sz,kn);
%         xy_rot = R*([x;y]-rc)+D/2+0.5;
%         idx = round(xy_rot(2));%#
%         %corresponding indice in W and p matrix
%         ixM = D*(kp-1)+idx;
%         W(ixM,kn) = 1;
%         %W(D*(kp-1)+idx,kn) = 1;
%         %W(cnt+idx-offset,kn) = 1;
%         %p(cnt+idx-offset) = projmat(kp,idx);%#
%         if ~ix(ixM)
%             p(ixM) = projmat(kp,idx);
%             ix(ixM) = true;
%         end
%         %p(D*(kp-1)+idx) = projmat(kp,idx);
%         %proj_info(cnt+idx-offset,:) = [kp,idx];
%     end
%     %cnt = cnt+(D-2*offset);
%     %fprintf('%d equations built.\r',D-2*offset)
% end
% %
[x,y] = ind2sub(sz,1:N);
%xy = [x;y]; %x,y coordinate
%x,y coordinate with respect to rotation center
xy_c = [x;y]-repmat(rc,1,N);
for kp = 1:n_proj
    try
        W_c{kp} = zeros(D,N); %weighting factor matrix
    catch expr
        fprintf(['Build W{%d}...\n' expr.message '\nGenerate a sparse.\r'],kp)
        W_c{kp} = sparse(D,N);
    end
    im_rot = imrotate(im_pad,-angles(kp),'bilinear','crop');
    pvec = sum(im_rot,1);
    t = -angles(kp)/180*pi;
    R = [cos(t) -sin(t);sin(t) cos(t)];
    fprintf('\nAngle No.%d(%d Degree)\r',kp,angles(kp))
    xy_rot = R*xy_c+D/2+0.5;
    idx = round(xy_rot(2,:));
    ixM = D*(kp-1)+idx; %corresponding indice in W and p matrix
    for kn = 1:N
        W_c{kp}(idx(kn),kn) = 1;
        p(ixM(kn)) = pvec(idx(kn));
        ix(ixM(kn)) = true;
    end
end
% %
%Convert cell to matrix
% try
%     W = zeros(M,N);
% catch expr
%     fprintf([expr.message '\nGenerate a sparse.\r'])
%     W = sparse(M,N);
% end
W = sparse(M,N);
for kp = 1:n_proj
    W((D*(kp-1)+(1:D)),:) = W_c{kp};
end

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
