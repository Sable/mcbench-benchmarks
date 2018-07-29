function out = deconvtv(g, H, mu, opts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% out = deconvtvl1(g, H, mu, opts)
% deconvolves image g by solving the following TV minimization problem
%
% min  mu  || Hf - g ||_1 + ||f||_TV
% min mu/2 || Hf - g ||^2 + ||f||_TV
%
% where ||f||_TV = sum_{x,y,t} sqrt( a||Dxf||^2 + b||Dyf||^2 + c||Dtf||^2),
% Dxf = f(x+1,y, t) - f(x,y,t)
% Dyf = f(x,y+1, t) - f(x,y,t)
% Dtf = f(x,y, t+1) - f(x,y,t)
%
% Input:      g      - the observed image, can be gray scale, color, or video
%             H      - point spread function
%            mu      - regularization parameter
%     opts.method    - either 'l1' or {'l2'}
%     opts.rho_r     - initial penalty parameter for ||u-Df||   {2}
%     opts.rho_o     - initial penalty parameter for ||Hf-g-r|| {50}
%     opts.beta      - regularization parameter [a b c] for weighted TV norm {[1 1 0]}
%     opts.gamma     - update constant for rho_r {2}
%     opts.max_itr   - maximum iteration {20}
%     opts.alpha     - constant that determines constraint violation {0.7}
%     opts.tol       - tolerance level on relative change {1e-3}
%     opts.print     - print screen option {false}
%     opts.f         - initial  f {g}
%     opts.y1        - initial y1 {0}
%     opts.y2        - initial y2 {0}
%     opts.y3        - initial y3 {0}
%     opts.z         - initial  z {0}
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
% Copyright 2011
% University of California, San Diego
%
% Last Modified:
% 30 Apr, 2010 (deconvtvl2)
%  4 May, 2010 (deconvtvl2)
%  5 May, 2010 (deconvtvl2)
%  4 Aug, 2010 (deconvtvl1)
% 20 Jan, 2011 (deconvtv)
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
path(path,genpath(pwd));

if nargin<3
    error('not enough inputs, try again \n');
elseif nargin==3
    opts = [];
end

if ~isnumeric(mu)
    error('mu must be a numeric value! \n');
end

[rows cols frames] = size(g);
memory_condition = memory;
max_array_memory = memory_condition.MaxPossibleArrayBytes/16;
if rows*cols*frames>0.1*max_array_memory
    fprintf('Warning: possible memory issue \n');
    reply = input('Do you want to continue? [y/n]: ', 's');
    if isequal(reply, 'n')
        out.f = 0;
        return
    end
end

if ~isfield(opts,'method')
    method = 'l2';
else
    method = opts.method;
end

switch method
    case 'l2'
        out = deconvtvl2(g,H,mu,opts);
    case 'l1'
        out = deconvtvl1(g,H,mu,opts);
    otherwise
        error('unknown method \n');
end

