function [c ceq gradc gradceq] = constraints(x)
% =========================================================================
% This function deals with the constraint set used in the optimization
% procedure.
% The possible contact set confuguration is:
%               'surfaces'          % surfaces only       a)
%               'normals_cross'     % n1 x n2             b)
%               'normals_cross+n1'  % n1 x n2 + n2.r12    c)
%               'normals_cross+n2'  % n1 x n2 + n2.r12    d)
%               'normals_dot'       % n1.n2               e)
%               'normals_dot+n1'    % n1.n2   + n1.r12    f)
%               'normals_dot+n2'    % n1.n2   + n2.r12    g)
%               'dist_n1_n2'        % n1.r12  + n2.r12    h)
%
% Credits:
% Ricardo Fontes Portal
% IDMEC - Instituto Superior Tecnico - Universidade Técnica de Lisboa
% ricardo.portal(at)dem(.)ist(.)utl(.)pt
%
% April 2009 original version
% March 2013 updated version

%% =========================================================================
% c are the inequality constraints and
% ceq are the equality constraints
global p1 p2 p3 p4 p5 p6 a1 a2 a3 a4 a5 a6 e1 e2 e3 e4 n1n n2n TRa TRb ConSet;
zro=1.0d-12;
%% Changing variables
p1s = p1; p2s = p2; p3s = p3; p4s = p4; p5s = p5; p6s = p6;
a1s = a1; a2s = a2; a3s = a3; a4s = a4; a5s = a5; a6s = a6;
e1s = e1; e2s = e2; e3s = e3; e4s = e4;

A=((x(1)-p1s)*TRa(1,1) + (x(2)-p2s)*TRa(2,1) +(x(3)-p3s)*TRa(3,1))/a1s;
B=((x(1)-p1s)*TRa(1,2) + (x(2)-p2s)*TRa(2,2) +(x(3)-p3s)*TRa(3,2))/a2s;
C=((x(1)-p1s)*TRa(1,3) + (x(2)-p2s)*TRa(2,3) +(x(3)-p3s)*TRa(3,3))/a3s;

D=((x(4)-p4s)*TRb(1,1) + (x(5)-p5s)*TRb(2,1) +(x(6)-p6s)*TRb(3,1))/a4s;
E=((x(4)-p4s)*TRb(1,2) + (x(5)-p5s)*TRb(2,2) +(x(6)-p6s)*TRb(3,2))/a5s;
F=((x(4)-p4s)*TRb(1,3) + (x(5)-p5s)*TRb(2,3) +(x(6)-p6s)*TRb(3,3))/a6s;
%% Surfaces' normals calculation
if ((abs(A)<zro) && (abs(B)<zro))
    n1p = 0;
    n1Caux = sign(C)*(C^2)^(1.0/e1s-0.5)/a3s;
    n1(1) = n1Caux*TRa(1,3);
    n1(2) = n1Caux*TRa(2,3);
    n1(3) = n1Caux*TRa(3,3);
else
    n1p  = (A^2)^(1.0/e2s)+(B^2)^(1.0/e2s);
    n1p2 = (n1p)^(e2s/e1s-1.0);
    n1Aaux = sign(A)*(A^2)^(1.0/e2s-0.5)/a1s;
    n1Baux = sign(B)*(B^2)^(1.0/e2s-0.5)/a2s;
    n1Caux = sign(C)*(C^2)^(1.0/e1s-0.5)/a3s;
    n1(1) = (2.0/e1s)*(n1p2 * (n1Aaux*TRa(1,1) + n1Baux*TRa(1,2)) + n1Caux*TRa(1,3));
    n1(2) = (2.0/e1s)*(n1p2 * (n1Aaux*TRa(2,1) + n1Baux*TRa(2,2)) + n1Caux*TRa(2,3));
    n1(3) = (2.0/e1s)*(n1p2 * (n1Aaux*TRa(3,1) + n1Baux*TRa(3,2)) + n1Caux*TRa(3,3));
end
n1norm = sqrt((n1(1))^2+(n1(2))^2+(n1(3))^2);
% n1norm = norm(n1);
n1n(1) = n1(1)/n1norm;
n1n(2) = n1(2)/n1norm;
n1n(3) = n1(3)/n1norm;

if ((abs(D)<zro) && (abs(E)<zro))
    n2p = 0;
    n2aux = sign(F)*(F^2)^(1.0/e3s-0.5)/a6s;
    n2(1) = n2aux*TRb(1,3);
    n2(2) = n2aux*TRb(2,3);
    n2(3) = n2aux*TRb(3,3);
else
    n2p  = (D^2)^(1.0/e4s)+(E^2)^(1.0/e4s);
    n2p2 = (n2p)^(e4s/e3s-1.0);
    n2Daux = sign(D)*(D^2)^(1.0/e4s-0.5)/a4s;
    n2Eaux = sign(E)*(E^2)^(1.0/e4s-0.5)/a5s;
    n2Faux = sign(F)*(F^2)^(1.0/e3s-0.5)/a6s;
    n2(1) = (2.0/e3s)*(n2p2 * (n2Daux*TRb(1,1) + n2Eaux*TRb(1,2)) + n2Faux*TRb(1,3));
    n2(2) = (2.0/e3s)*(n2p2 * (n2Daux*TRb(2,1) + n2Eaux*TRb(2,2)) + n2Faux*TRb(2,3));
    n2(3) = (2.0/e3s)*(n2p2 * (n2Daux*TRb(3,1) + n2Eaux*TRb(3,2)) + n2Faux*TRb(3,3));
end
n2norm = sqrt((n2(1))^2+(n2(2))^2+(n2(3))^2);
% n2norm = norm(n2);
n2n(1) = n2(1)/n2norm;
n2n(2) = n2(2)/n2norm;
n2n(3) = n2(3)/n2norm;
%% norm of xB-xA
normBA = sqrt((x(4)-x(1))^2+(x(5)-x(2))^2+(x(6)-x(3))^2);
%% constraints
c = [];
switch lower(ConSet)
    case ('surfaces')%  apenas as superfícies
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0];
        
    case ('normals_dot')% n1.n2
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(1)*n2n(1) + n1n(2)*n2n(2)+n1n(3)*n2n(3)+1.0];
        
    case ('normals_dot+n1') % n1.n2 + n1.r12
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(1)*n2n(1)+n1n(2)*n2n(2)+n1n(3)*n2n(3)+1.0;
            n1n(1)*(x(4)-x(1))/normBA+n1n(2)*(x(5)-x(2))/normBA+n1n(3)*(x(6)-x(3))/normBA-1.0];
        
    case ('normals_dot+n2') % n1.n2 + n2.r12
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(1)*n2n(1)+n1n(2)*n2n(2)+n1n(3)*n2n(3)+1.0;
            n2n(1)*(x(1)-x(4))/normBA+n2n(2)*(x(2)-x(5))/normBA+n2n(3)*(x(3)-x(6))/normBA-1.0];
        
    case ('normals_cross') % n1 x n2
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(2)*n2n(3)-n1n(3)*n2n(2);
            n1n(3)*n2n(1)-n1n(1)*n2n(3);
            n1n(1)*n2n(2)-n1n(2)*n2n(1)];
        
    case ('normals_cross+n1') % n1 x n2 + n2.r12
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(2)*n2n(3)-n1n(3)*n2n(2);
            n1n(3)*n2n(1)-n1n(1)*n2n(3);
            n1n(1)*n2n(2)-n1n(2)*n2n(1);
            n1n(1)*(x(4)-x(1))/normBA+n1n(2)*(x(5)-x(2))/normBA+n1n(3)*(x(6)-x(3))/normBA-1.0];
        
    case ('normals_cross+n2') % n1 x n2 + n2.r12
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(2)*n2n(3)-n1n(3)*n2n(2);
            n1n(3)*n2n(1)-n1n(1)*n2n(3);
            n1n(1)*n2n(2)-n1n(2)*n2n(1);
            n2n(1)*(x(1)-x(4))/normBA+n2n(2)*(x(2)-x(5))/normBA+n2n(3)*(x(3)-x(6))/normBA-1.0];
        
    case ('dist_n1_n2') % n1.r12 + n2.r12
        ceq = [(n1p)^(e2s/e1s)+(C^2)^(1.0/e1s)-1.0;
            (n2p)^(e4s/e3s)+(F^2)^(1.0/e3s)-1.0;
            n1n(1)*(x(4)-x(1))/normBA+n1n(2)*(x(5)-x(2))/normBA+n1n(3)*(x(6)-x(3))/normBA-1.0;
            n2n(1)*(x(1)-x(4))/normBA+n2n(2)*(x(2)-x(5))/normBA+n2n(3)*(x(3)-x(6))/normBA-1.0];
    otherwise
        disp('No constraints used')
end

if nargout > 2
    gradc = [];
    gradceq = [];
end
