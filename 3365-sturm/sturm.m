function y = sturm(X,BC,F,G,R)
% STURM  Solve the Sturm-Liouville equation:
%        d( F*dY/dX )/dX - G*Y = R using linear finite elements.
%
%        Y = STURM(X,BC,'F','G','R')
%
%        INPUT:
%        X  - a one-dimensional grid-point array of length N.
%        BC - is a 2 by 3 matrix [A1, B1, C1 ; An, Bn, Cn]
%             specifying the boundary conditions, which are of
%             the form: A1*Y'(1) + B1*Y(1) = C1 and
%             An*Y'(n) + Bn*Y(n) = Cn. Dirichlet boundary
%             conditions can be applied by setting A1 and/or An
%             to zero.
%        F(X), G(X) and R(X) are user-supplied functions. These
%        must be provided as separate M-files (F.M, G.M and R.M),
%        and must return an array of same shape and length as X.
%
%        The result can be displayed by: plot(X,Y).
%
% Alex Pletzer: pletzer@pppl.gov (Aug. 97/July 99).
%

[n1,n2] = size(X);
x = X(:);
n=length(x);    % # of f e
n1 = n-1;
x = sort(x);
xmin = x(1); xmax = x(n);
dx = diff(x); x = x(1:n1);

% boundary conditions

[nbc1,nbc2] = size(BC);
if ([nbc1 nbc2] ~= [2 3]),
        disp('Error calling STURM: Wrong format for BC specification')
        disp('the second argument must be a 2 times 3 matrix')
        disp('Homgeneous Dirichlet boundary conditions assumed')
        BC = [0 1 0;0 1 0]
end

if (BC(1,:) == [0 0 0]) | (BC(2,:) == [0 0 0]),
        disp('Error calling STURM: Null BC specification')
        BC
        disp('Homgeneous Dirichlet boundary conditions assumed')
        BC = [0 1 0;0 1 0]
end

a1 = BC(1,1); b1 = BC(1,2); c1 = BC(1,3);
an = BC(2,1); bn = BC(2,2); cn = BC(2,3);

% 3pt gauss' grid

abcis = [-0.77459666924148,0.0,+0.77459666924148];
abcis = (abcis+1)/2;
weigh = [0.5555555555556,0.88888888888889,0.55555555555556];
weigh = weigh/2;

x1 = x + dx*abcis(1);
x2 = x + dx*abcis(2);
x3 = x + dx*abcis(3);

xg = reshape( [conj(x1');conj(x2');conj(x3')],1,3*n1);

% f, g  and s functions

fg = feval(F,xg);
gg = feval(G,xg);
sg = feval(R,xg);


% construct matrices

fg = conj(reshape(fg,3,n1)');
gg = conj(reshape(gg,3,n1)');
sg = conj(reshape(sg,3,n1)');
g1 = gg(:,1); g2 = gg(:,2); g3 = gg(:,3);

% "kinetic"

k1 = (fg*weigh')./dx;
k1 = [0;k1]; k2 = k1(2:n);
k2 = [k2;0];
kd = k2 + k1;   % diagonal
ko = - k1(2:n); % diagonal-1
k = sparse( diag(kd) + diag(ko,-1) + diag(ko,+1) );

% "potential"

v1 = ( gg*conj(weigh.*abcis.^2)'         ).*dx; % / * /

v2 = ( gg*conj(weigh.*abcis.*(1-abcis))' ).*dx; % / * \

v3 = ( gg*conj(weigh.*(1-abcis).^2)'     ).*dx; % \ * \

v1 = [0;v1]; v3 = [v3;0];

vd = v1 + v3;
vo = v2;
v = sparse( diag(vd) + diag(vo,-1) + diag(vo,+1) );

% total

w = k + v;

% source

s1 = - ( sg*conj(weigh.*abcis)'         ).*dx; % /
s2 = - ( sg*conj(weigh.*(1-abcis))'     ).*dx; % \
s1 = [0;s1]; s2 = [s2;0];
s = s2 + s1;

% boundary conditions

        % left endpoint
        if a1 == 0,
                disp('Dirichlet BC at left endpoint:')
                disp(['y(1) = ',num2str(c1/b1)])
                w(1,:) = zeros(1,n); w(1,1)=1; s(1)=c1/b1;
        else
                disp('General BC at left endpoint:')
                disp(['y_x(1) + ',num2str(b1/a1),' y(1) = ',num2str(c1/a1)])
                w(1,1) = w(1,1) - b1/a1; s(1) = s(1) - c1/a1;
        end

        % right endpoint
        if an == 0,
                disp('Dirichlet BC at right endpoint:')
                disp(['y(n) = ',num2str(cn/bn)])
                w(n,:) = zeros(1,n); w(n,n)=1; s(n)=cn/bn;
        else
                disp('General BC at right endpoint:')
                disp(['y_x(n) + ',num2str(bn/an),' y(n) = ',num2str(cn/an)])
                w(n,n) = w(n,n) + bn/an; s(n) = s(n) + cn/an;
        end

% solve linear system

y=w\s;

[m1,m2] = size(y);
if (m1 == n2) & (m2 == n1), y = conj(y'); end
