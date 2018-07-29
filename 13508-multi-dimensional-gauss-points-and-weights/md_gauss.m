function [point c] = md_gauss(n,dimension,symbolic,type)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Program:    Multi-dimensional gauss points calculator with weight
%               functions
%   Author:     Brent Lewis
%               rocketlion@gmail.com
%   History:    Originally written: 10/30/2006
%               Revision for symbolic logic:  1/2/2007
%   Purpose:    Program calculates the gauss points for 1-D,2-D,3-D along
%               with their weights for use in numerical integration.  
%               Originally written for a Finite Element Program so has the
%               capability to give integration points for a 6-node Triangle
%               element
%   Input:      n:          Number of gauss points(Must be integer 0<n<22
%               dimension:  Dimension of space for gauss points(optional)
%               symbolic:   Logical statement for return values in symbolic
%                           form(optional)
%               type:       Type of finite element(optional)
%   Output:     point:      Gauss points in either vector or matrix form
%                           depeding on dimensions
%               c:          Weighting values for Gaussian integration
%   Example:    [point c] = md_gauss(2)
%               Returns the point = +/-sqrt(1/3) and c = 1 1 which are the
%               gauss points and integration weights for 2 Gauss point rule
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Multiple Levels of Input with default values
if nargin == 1
    dimension = 1;
    type = 'QUAD4';
    symbolic = 0;
elseif nargin == 2
    type = 'QUAD4';
    symbolic = 0;
elseif nargin == 3
    type = 'QUAD4';
end

if strcmp(upper(symbolic),'TRUE')
    symbolic = 1;
else
    symbolic = 0;
end

% Error determination
if n < 1 || n > 21
    error('Number of gauss points must be 0<n<21.')     % Factorial only accurate to n = 21
elseif mod(n,1) ~= 0
    error('Points must be integer value')               % Check for non-integer points
elseif dimension < 1 || dimension > 3
    error('Dimension error:  0<Dimension<4')            % Dimension check
end

if strcmp(upper(type), 'QUAD4') || strcmp(upper(type), 'QUAD8') || strcmp(upper(type), 'QUAD9')
    syms x
    if n == 1
        point_1D = 0;
        c_1D = 2;
    else
        P = 1/(2^n*factorial(n))*diff((x^2-1)^n,n);  % Rodrigues' Formula
        point_1D = double(solve(P));
        % Weight Function described in Numerical Analysis book 8th edition-
        % Richard Burden page 223
        for i = 1 : length(point_1D)
            prod = 1;
            for j = 1 : length(point_1D)
                if i == j
                    continue
                else
                    prod = prod*(x-point_1D(j))/(point_1D(i)-point_1D(j));
                end
            end
            c_1D(i,1) = double(int(sym(prod),-1,1));
        end
    end

    if dimension == 1
        point = point_1D;
        c = c_1D;
    elseif dimension == 2
        k = 1;
        for i = 1:n
            for j = 1:n
                point(k,:) = [point_1D(i),point_1D(j)];
                c(k,1) = c_1D(i)*c_1D(j);
                k = k+1;
            end
        end
    elseif dimension == 3
        m = 1;
        for i = 1 : n
            for j = 1 : n
                for k = 1 : n
                    point(m,:) = [point_1D(i),point_1D(j),point_1D(k)];
                    c(m,1) = c_1D(i)*c_1D(j)*c_1D(k);
                    m = m+1;
                end
            end
        end
    end
elseif strcmp(upper(type), 'TRI6')
    if n == 1
        point = ones(3,1)/3;
        c = 1;
    elseif n == 3
        point = ones(3)/3+eye(3)/3;
        c = ones(3,1)/3;
    elseif n == -3
        point = ones(3)/2-eye(3)/2;
        c = ones(3,1)/3;
    elseif n == 6
        g1 = (8-sqrt(10)+sqrt(38-44*sqrt(2/5)))/18;
        g2 = (8-sqrt(10)-sqrt(38-44*sqrt(2/5)))/18;
        point = [ones(3)*g1+eye(3)*(1-3*g1);ones(3)*g2+eye(3)*(1-3*g2)];
        c = ones(6,1)*(213125-53320*sqrt(10))/3720;
    elseif n == -6
        point = [ones(3)/6+eye(3)/2;ones(3)/2-eye(3)/2];
        c = [ones(3,1)*3/10;ones(3,1)/30];
    elseif n == 7
        g1 = (6-sqrt(15))/21;
        g2 = (6+sqrt(15))/21;
        point = [ones(3)*g1+eye(3)*(1-3*g1);ones(3)*g2+eye(3)*(1-3*g2);ones(1,3)/3];
        c = [ones(3,1)*(155-sqrt(15))/1200;ones(3,1)*(155+sqrt(15))/1200;9/40];
    end
elseif strcmp(upper(type), 'TRI3')
    point =[];
    c = [];
end

if symbolic == 1
    point = sym(point);
    c = sym(c);
end