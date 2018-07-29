function [A,B,C,D]=era(h,n,N,Ts,def);

% Eigensystem Realization Algorithm (ERA)
%
% Author: Samuel da Silva - UNICAMP
% e-mail: samsilva@fem.unicamp.br
% Date: 2006/10/20
% 
% [A,B,C,D]=era(h,n,N,Ts,def);
% 
% Inputs:
%    h: discrete-time impulse response
%    n: order of the system
%    N: number of samples to assembly the Hankel matrix
%    Ts: sample time
%    def: if = 1: the output will be the discrete-time state-space model
%         if = 2: the output will be the continuous-time state-space model
%          
% Otputs:
%    [A,B,C,D]: state-space model
%  
% Note: For now, it works to SISO systems and it is necessary the control toolbox
%
% References: Juang, J. N. and Phan, M. Q. "Identification and Control of
% Mechanical Systems", Cambridge University Press, 2001

% Hankel matrix
H0 = hankel(h(2:N+1));            % k = 0
H1 = hankel(h(3:N+2));            % k = 1;

% Factorization of the Hankel matrix by use of SVD
[R,Sigma,S] = svd(H0);   
% R and S are orthonormal and Sigma is a rectangular matrix

Sigman = Sigma(1:n,1:n);            

Wo = R(:,1:n)*Sigman^0.5;           % observability matrix
Co = Sigman^.5*S(:,1:n)';           % controllability matrix

% The identified system matrix are:
A = Sigman^-.5*R(:,1:n)'*H1*S(:,1:n)*Sigman^-.5;            % dynamic matrix
B = Co(:,1);                    % input matrix
C = Wo(1,:);                    % output matrix
D = h(1);                       % direct-transmission matrix

sysdisc = ss(A,B,C,D,Ts);       % discrete-time system

if def == 2                            
    syscont = d2c(sysdisc,'zoh');       % Conversion of discrete LTI models to continuous time
    [A,B,C,D]=ssdata(syscont);          % continuous system
end

%--------------------------------------------------------------------------
