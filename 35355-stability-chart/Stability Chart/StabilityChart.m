% To plot the stability chart or strut diagram for the Mathieu's Equation
% Mathieu Equation is x''+(d-2ecos(2t))x = 0
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Warning : On running this the workspace memory will be deleted. Save if
% any data present before running the code !!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%--------------------------------------------------------------------------
% Code written by : Siva Srinivas Kolukula                                |
%                   Senior Research Fellow                                |
%                   Structural Mechanics Laboratory                       |
%                   Indira Gandhi Center for Atomic Research              |
%                   India                                                 |
% E-mail : allwayzitzme@gmail.com                                         |
%--------------------------------------------------------------------------
% Version 1 : 28 Feb 2012

% Version 2: 24 July 2013
% Made code to plot stability chart in few seconds
%
clc ; clear all ;
N = 30 ;                    % Order of the Hill's Determinant
T = cell(1,4) ;             % Cell array to store Hill determinant matrices
EE = cell(1,4) ;
epsilon = -20:0.05:20 ;
for i = 1:length(epsilon)
    e = epsilon(i) ;
    a = e*ones(N,1) ;       % Sub diagonal elements
    c = e*ones(N,1) ;       % Super diagonal elements
    % Hill determinants for odd sine and cosine coefficients 
    ndeto = 2*N+1 ;     
    bo = (1:2:ndeto).^2 ;   % Diagonal elements
    T1 = diag(a,-1)+diag(bo)+diag(c,+1) ; 
    T1(1,1) = 1+e ;
    T{1} = T1 ;             % Odd cosine determinant matrix
    T1(1,1) = 1-e ;
    T2 = T1 ;
    T{2} = T2 ;             % Odd sine determinant matrix
    % Hill determinants for even sine and cosine coefficients
    ndete = 2*(N+1) ;
    be = (2:2:ndete).^2 ;   % Diagonal elements
    T3 = diag(a,-1)+diag(be)+diag(c,+1) ;
    T{3} = T3 ;             % Even cosine determinant matrix
    T4 = zeros(size(T3)) ;
    T4(1,1) = 0 ;T4(1,2) = e ;T4(2,1) = 2*e ;
    T4(2:end,2:end)=T3(1:end-1,1:end-1) ;
    T{4} = T4 ;             % Even sine determinant matrix
    % Calculate the Eigenvalues of the Determinant matrices
    for j = 1:4
        E = eig(T{j}) ;
%         plot(E,e,'.','Markersize',4.5,'Color','r') ;
        EE{j}(:,i) = E ;
    end
end
epsilon = epsilon' ;
E1 = EE{1}' ;
E2 = EE{2}' ;
E3 = EE{3}';
E4 = EE{4}' ;
E = [E1 E2 E3 E4] ;
figure ;
plot(E,epsilon,'b','Linewidt',1.5)
title('Strut diagram for Mathieu Equation')
xlabel('\delta') ;
ylabel('\epsilon') ;
hold on ;
axis([-10,45,-20,20])
PlotAxisAtOrigin 
