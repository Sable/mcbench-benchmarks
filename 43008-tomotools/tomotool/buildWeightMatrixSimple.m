function [W, p, D, projmat] = buildWeightMatrixSimple(im, angles)
%BUILDWEIGHTMATRIXSIMPLE   Build wieghting factor matrix W, the projection
%   vector p, and projection matrix projmat.
%   Reconstruct the image from equation W*f == p.
%
%   Phymhan
%   10-Aug-2013 13:43:16 -Accelerates computation
%

%Timer
try
    t1 = toc;
catch expr
    fprintf([expr.message '\nCalling TIC to start a stopwatch timer...\r'])
    tic
    t1 = toc;
end
%Pad image
[im_pad,D] = impad(im,'diag',0);
sz = size(im);
m = sz(1); %rows
n = sz(2); %cols
n_p = length(angles);
N = m*n; %number of unknown variables
M = D*n_p; %number of equations
%Weighting Factor Matrix
try
    W = zeros(M,N);
    method = 'matrix';
catch expr
    fprintf([expr.message '\nGenerating a sparse...\r'])
    W = sparse(M,N);
    method = 'sparse';
end
%proj_info = zeros(M,2); %[theta No.]
projmat = zeros(n_p,D); %%projection matrix
p = zeros(M,1); %projection vector
ix = false(M,1);
rc = [m;n]/2+0.5;
%cnt = 0;
fprintf('Building Weight Matrix...\r')
%% SLOW
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

%% FAST
[x,y] = ind2sub(sz,1:N);
%xy = [x;y]; %x,y coordinate
%x,y coordinate with respect to rotation center
xy_c = [x;y]-repmat(rc,1,N);
if strcmp(method,'sparse')
    try
        A = zeros(D,N);
    catch expr
        fprintf(['Building A...\n' ...
            expr.message '\nGenerating a sparse...\r'])
        A = sparse(D,N);
    end
    for kp = 1:n_p
        A(:) = 0; %#
        im_rot = imrotate(im_pad,-angles(kp),'bilinear','crop');
        pvec = sum(im_rot,1);
        projmat(kp,:) = pvec;
        t = -angles(kp)/180*pi;
        R = [cos(t) -sin(t);sin(t) cos(t)];
        fprintf('\nAngle %d(%d Degree)\n%.1f%% completed.\r',...
            kp,angles(kp),100*kp/n_p)
        xy_rot = R*xy_c+D/2+0.5;
        idx = round(xy_rot(2,:));
        ixM = D*(kp-1)+idx; %corresponding indice in W and p matrix
        for kn = 1:N
            A(idx(kn),kn) = 1;
            %if ~ix(ixM(kn))
            %    p(ixM(kn)) = pvec(idx(kn));
            %    ix(ixM(kn)) = true;
            %end
            p(ixM(kn)) = projmat(kp,idx(kn));
            ix(ixM(kn)) = true;
        end
        W((D*(kp-1)+(1:D)),:) = A; %#
    end
else
    for kp = 1:n_p
        im_rot = imrotate(im_pad,-angles(kp),'bilinear','crop');
        pvec = sum(im_rot,1);
        projmat(kp,:) = pvec;
        t = -angles(kp)/180*pi;
        R = [cos(t) -sin(t);sin(t) cos(t)];
        fprintf('\nAngle %d(%d Degree)\n%.1f%% completed.\r',...
            kp,angles(kp),100*kp/n_p)
        xy_rot = R*xy_c+D/2+0.5;
        idx = round(xy_rot(2,:));
        ixM = D*(kp-1)+idx; %corresponding indice in W and p matrix
        for kn = 1:N
            W(ixM(kn),kn) = 1;
            %if ~ix(ixM(kn))
            %    p(ixM(kn)) = pvec(idx(kn));
            %    ix(ixM(kn)) = true;
            %end
            p(ixM(kn)) = projmat(kp,idx(kn));
            ix(ixM(kn)) = true;
        end
    end
end

%% Delete all-zero rows in W
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
figure('name','Sparsity pattern of matrix W','numbertitle','off');
spy(W)
t2 = toc;
fprintf('\nTotal elapsed time: %f seconds\n\r',t2-t1);
end
