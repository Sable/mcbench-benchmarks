function [M,D,K] = MDK(m,k,m_con,k_con,alpha,beta)
%%  Help
%   Name:       Mass-Dampening-Stiffness Matrix Setup for EOM
%   Author:     Brent Lewis
%               University of Colorado-Boulder
%               rocketlion@gmail.com
%   Purpose:    Set up Mass-Dampening-Stiffness Matrices for a
%               proportionally damped system of mass springs
%               M*d2x/dt^2+D*dx/dt+K*x=F
%   Input:      m:      Mass value vector of system
%                       [m1 m2 m3 m4 m5 m6 ...]
%               k:      Stiffness value vector of system
%                       [k1 k2 k3 k4 k5 k6 ...]
%               m_con:  Cell containing which springs are attached to each
%                       mass-Must be cell format to accomodate masses with
%                       different numbers of springs attached.  Length will
%                       be equal to the number of masses in the system
%                       {[1,3],1,...}-Mass 1 has springs 1 and 3 attached,
%                       Mass 2 has spring 1 attached,...
%               k_con:  Cell containing which masses are attached to which 
%                       springs-Must be cell format to accomodate masses 
%                       with different numbers of springs attached. Length
%                       will be equal to the number of springs in the
%                       system
%                       {[1,2],3,...}-Spring 1 is attached to masses 1 and
%                       2, spring 2 is attached to mass 3
%               alpha:  Proportional Dampening term of the stiffness matrix
%                       for the dampening term
%               beta:   Proportional Dampening term of the mass matrix
%                       for the dampening term
%   Output:     M:      Mass Matrix
%               D:      Proportional dampening matrix
%                       D=alpha*K+beta*M
%               K:      Stiffness Matrix
%%  Mass Matrix
M = diag(m);                %   Mass Matrix Set
%%  Stiffness Matrix
K = zeros(size(M));         %   Stiffness Matrix Initialization
if ~isnumeric(k)            %   Symbolic Stiffness Matrix Ability
    K = sym(K);
end
for i = 1 : length(m)
    K(i,i) = sum(k(m_con{i}(:)));   %   Diagonal Matrix Elements
    for j = 1 : length(k)
        if sum(k_con{j} == i) ~= 0
            for m = 1 : length(k_con{j})
                if i ~= k_con{j}(m)
                    K(i,k_con{j}(m)) = -k(j);   %   Off Diagonal Terms
                end
            end
        end
    end
end
%%  Dampening Matrix
D = alpha*K + beta*M;       %   Proportional Dampening Matrix