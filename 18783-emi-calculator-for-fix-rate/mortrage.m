function mortrage()
clc;clear all; close all;
% definitions
% P = principle amount
% J = Monthly intrest rate
% R = Total monthly payment
% R = J*P+ amount applied to principle
% new principle amount
% P+j*P-R => P(1+J)-R => P*m-R: m=1+J


% inputs
pri=input('Principle amount ');
Yr=input(' No of Year ' );
rate=input('Annual percentage rate ' );
peryear=1/12;
percent=1/100;
ttl_mnt=Yr*12;
syms m J P R A N;

% the principal after n payments can be written as
% P = A?mn ? R? (mn ? 1)/(m? 1).
solve(A*m^N - R*(m^N - 1)/(m - 1), R);
R = subs(ans, m, J + 1);
format bank; 
 disp( '     Interest Rate      Payment')
%for rate= 6:0.2:12   
    disp([rate, double(subs(R, [A, N, J], [pri, ttl_mnt, rate*percent*peryear]))])
%end
ttl_payment=subs(R, [A, N, J], [pri, ttl_mnt, rate*percent*peryear])*ttl_mnt;
disp('total amunt paid =')
disp(ttl_payment)