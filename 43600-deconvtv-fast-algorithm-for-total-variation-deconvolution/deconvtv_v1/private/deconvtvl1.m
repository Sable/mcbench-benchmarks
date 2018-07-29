function out = deconvtvl1(g, H, mu, opts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% out = deconvtvl1(g, H, mu, opts)
% deconvolves image g by solving the following TV minimization problem
%
% min (mu/2) || Hf - g ||_1 + ||f||_TV
%
% where ||f||_TV = sqrt( a||Dxf||^2 + b||Dyf||^2 c||Dtf||^2),
% Dxf = f(x+1,y, t) - f(x,y,t)
% Dyf = f(x,y+1, t) - f(x,y,t)
% Dtf = f(x,y, t+1) - f(x,y,t)
%
% Input:      g      - the observed image, can be gray scale, or color
%             H      - point spread function
%            mu      - regularization parameter
%     opts.rho_r     - initial penalty parameter for ||u-Df||   {2}
%     opts.rho_o     - initial penalty parameter for ||Hf-g-r|| {50}
%     opts.beta      - regularization parameter [a b c] for weighted TV norm {[1 1 2.5]}
%     opts.gamma     - update constant for rho_r {2}
%     opts.max_itr   - maximum iteration {20}
%     opts.alpha     - constant that determines constraint violation {0.7}
%     opts.tol       - tolerance level on relative change {1e-3}
%     opts.print     - print screen option {false}
%     opts.f         - initial f  {g}
%     opts.y1        - initial y1 {0}
%     opts.y2        - initial y2 {0}
%     opts.y3        - initial y3 {0}
%     opts.z         - initial z {0}
%     ** default values of opts are given in { }.
%
% Output: out.f      - output video
%         out.itr    - total number of iterations elapsed
%         out.relchg - final relative change
%         out.Df1    - Dxf, f is the output video
%         out.Df2    - Dyf, f is the output video
%         out.Df3    - Dtf, f is the output video
%         out.y1     - Lagrange multiplier for Df1
%         out.y2     - Lagrange multiplier for Df2
%         out.y3     - Lagrange multiplier for Df3
%         out.rho_r  - final penalty parameter
%
% Stanley Chan
% Copyright 2010
% University of California, San Diego
%
% Last Modified:
% 30 Apr, 2010 (deconvtv)
%  4 May, 2010 (deconvtv)
%  5 May, 2010 (deconvtv)
%  4 Aug, 2010 (deconvtv_L1)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[rows cols frames] = size(g);

% Check inputs
if nargin<3
    error('not enough input, try again \n');
elseif nargin==3
    opts = [];
end

if ~isnumeric(mu)
    error('mu must be a numeric value! \n');
end


% Check defaults
if ~isfield(opts,'rho_o')
    opts.rho_o = 50;
end
if ~isfield(opts,'rho_r')
    opts.rho_r = 2;
end
if ~isfield(opts,'gamma')
    opts.gamma = 2;
end
if ~isfield(opts,'max_itr')
    opts.max_itr = 20;
end
if ~isfield(opts,'tol')
    opts.tol = 1e-3;
end
if ~isfield(opts,'alpha')
    opts.alpha = 0.7;
end
if ~isfield(opts,'print')
    opts.print = false;
end
if ~isfield(opts,'f')
    opts.f = g;
end
if ~isfield(opts,'y1')
    opts.y1 = zeros(rows, cols, frames);
end
if ~isfield(opts,'y2')
    opts.y2 = zeros(rows, cols, frames);
end
if ~isfield(opts,'y3')
    opts.y3 = zeros(rows, cols, frames);
end
if ~isfield(opts,'z')
    opts.z = zeros(rows, cols, frames);
end
if ~isfield(opts,'beta')
    opts.beta = [1 1 0];
end


% initialize
max_itr   = opts.max_itr;
tol       = opts.tol;
alpha     = opts.alpha;
beta      = opts.beta;
gamma     = opts.gamma;
rho_r     = opts.rho_r;
rho_o     = opts.rho_o;
f         = opts.f;
y1        = opts.y1;
y2        = opts.y2;
y3        = opts.y3;
z         = opts.z;


eigHtH      = abs(fftn(H, [rows cols frames])).^2;
eigDtD      = abs(beta(1)*fftn([1 -1],  [rows cols frames])).^2 + abs(beta(2)*fftn([1 -1]', [rows cols frames])).^2;
if frames>1
    d_tmp(1,1,1)= 1; d_tmp(1,1,2)= -1;
    eigEtE  = abs(beta(3)*fftn(d_tmp, [rows cols frames])).^2;
else
    eigEtE = 0;
end

Htg         = imfilter(g, H, 'circular');
[D,Dt]      = defDDt(beta);

[Df1 Df2 Df3] = D(f);
w       = imfilter(f, H, 'circular') - g;
rnorm   = sqrt(norm(Df1(:))^2 + norm(Df2(:))^2 + norm(Df3(:))^2);

out.relchg = [];
out.objval = [];




if opts.print==true
    fprintf('Running deconvtv (L1 version)  \n');
    fprintf('mu =   %10.2f \n\n', mu);
    fprintf('itr        relchg        ||Hf-g||_1       ||f||_TV         Obj Val            rho_r   \n');
end

for itr = 1:max_itr
    
    % u-subproblem
    v1 = Df1+(1/rho_r)*y1;
    v2 = Df2+(1/rho_r)*y2;
    v3 = Df3+(1/rho_r)*y3;
    v  = sqrt(v1.^2 + v2.^2 + v3.^2);
    v(v==0) = 1e-6;
    v  = max(v - 1/rho_r, 0)./v;
    u1 = v1.*v;
    u2 = v2.*v;
    u3 = v3.*v;
    
    % r-subproblem
    r = max(abs(w + 1/rho_o*z)-mu/rho_o, 0).*sign(w+1/rho_o*z);
    
    % f-subproblem
    f_old = f;
    rhs  = rho_o*Htg + imfilter(rho_o*r-z, H, 'circular') + Dt(rho_r*u1-y1, rho_r*u2-y2, rho_r*u3-y3);
    eigA = rho_o*eigHtH + rho_r*eigDtD + rho_r*eigEtE;
    f    = real(ifftn(fftn(rhs)./eigA));
    
    % y and z -update
    [Df1 Df2 Df3] = D(f);
    w    = imfilter(f, H, 'circular') - g;
    
    y1   = y1 - rho_r*(u1 - Df1);
    y2   = y2 - rho_r*(u2 - Df2);
    y3   = y3 - rho_r*(u3 - Df3);
    z    = z  - rho_o*(r - w);

    
    if (opts.print==true)
        r1norm     = sum(abs(w(:)));
        r2norm     = sum(sqrt(Df1(:).^2 + Df2(:).^2 + Df3(:).^2));
        objval     = mu*r1norm+r2norm;
    end
    
    rnorm_old  = rnorm;
    rnorm      = sqrt(norm(Df1(:)-u1(:), 'fro')^2 + norm(Df2(:)-u2(:), 'fro')^2 + norm(Df3(:)-u3(:), 'fro')^2);
    
    if rnorm>alpha*rnorm_old
        rho_r  = rho_r * gamma;
    end
    
    
    % relative change
    relchg = norm(f(:)-f_old(:))/norm(f_old(:));
    out.relchg(itr) = relchg;
    if (opts.print==true)
        out.objval(itr) = objval;
    end
    
    % print
    if (opts.print==true)
        fprintf('%3g \t %6.4e \t %6.4e \t %6.4e \t %6.4e \t %6.4e\n ', itr, relchg, r1norm, r2norm, objval, rho_r);
    end
    
    % check stopping criteria
    if relchg < tol
        break
    end
end

out.f    = f;
out.itr  = itr;
out.y1   = y1;
out.y2   = y2;
out.y3   = y3;
out.z    = z;
out.rho_r  = rho_r;
out.Df1  = Df1;
out.Df2  = Df2;
out.Df3  = Df3;


if (opts.print==true)
    fprintf('\n');
end

end


function [D,Dt] = defDDt(beta)
D  = @(U) ForwardD(U, beta);
Dt = @(X,Y,Z) Dive(X,Y,Z, beta);
end

function [Dux,Duy,Duz] = ForwardD(U, beta)
frames = size(U, 3);
Dux = beta(1)*[diff(U,1,2), U(:,1,:) - U(:,end,:)];
Duy = beta(2)*[diff(U,1,1); U(1,:,:) - U(end,:,:)];
Duz(:,:,1:frames-1) = beta(3)*diff(U,1,3);
Duz(:,:,frames)     = beta(3)*(U(:,:,1) - U(:,:,end));
end

function DtXYZ = Dive(X,Y,Z, beta)
frames = size(X, 3);
DtXYZ = [X(:,end,:) - X(:, 1,:), -diff(X,1,2)];
DtXYZ = beta(1)*DtXYZ + beta(2)*[Y(end,:,:) - Y(1, :,:); -diff(Y,1,1)];
Tmp(:,:,1) = Z(:,:,end) - Z(:,:,1);
Tmp(:,:,2:frames) = -diff(Z,1,3);
DtXYZ = DtXYZ + beta(3)*Tmp;
end