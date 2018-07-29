% Filename: ora_foc.m
% Oustaloup-Recursive-Approximation for fractional order differentiator
% Reference
% [1] Oustaloup, A.; Levron, F.; Mathieu, B.; Nanot, F.M.; "Frequency-band 
%     complex noninteger differentiator: characterization and synthesis". 
%     EEE Transactions on Circuits and Systems I: Fundamental Theory and 
%     Applications, I , Volume: 47 Issue: 1, Jan. 2000, Page(s): 25 -39
% [2] D. Xue, Y.Q. Chen and D. Atherton. "Linear feedback control - 
%     analysis and design with Matlab 6.5". Textbook draft. Chapter 9
%     "Fractional order control - An introduction". PDF available upon
%     request. Send request email to "yqchen@ieee.org".
% by YangQuan Chen. Nov. 2001. 
% Utah State University. http://www.csois.usu.edu/people/yqchen/
% FOC web http://mechatronics.ece.usu.edu/foc/
%
% Input variables:
%       r: the fractional order as in s^r, r is a real number
%       N: order of the finite TF approximation for both (num/den)
%           (Note: 2N+1 recursive z-p pairs)
%       w_L: low frequency limit of the range of the frequency of interest
%       w_H: upper freq. limit of the range of the frequency of interest
% Output: 
%       sys_foc: continuous time transfer function system object (TF)
% Sample values: w_L=0.1;w_H=1000;  r=0.5;  N=4;   
% Existing problem: Be careful when doing "c2d", I met some problems.
function [sys_foc]=ora_foc(r,N,w_L,w_H)
w_L=w_L*0.1;w_H=w_H*10; % enlarge the freq. range of interest for goodness
mu=w_H/w_L;                %
w_u=sqrt(w_H*w_L);
alpha=(mu)^(r/(2*N+1));   
eta=(mu)^((1-r)/(2*N+1));     
k=-N:N;
w_kp=(mu).^( (k+N+0.5-0.5*r)/(2*N+1) )*w_L;
w_k=(mu).^( (k+N+0.5+0.5*r)/(2*N+1) )*w_L;
D_N_K=(w_u/w_H)^r * prod(w_k) / prod(w_kp);
D_N_P=-w_k;D_N_Z=-w_kp;
[num,den]=zp2tf(D_N_Z',D_N_P',D_N_K); 
sys_foc=tf(num,den);
