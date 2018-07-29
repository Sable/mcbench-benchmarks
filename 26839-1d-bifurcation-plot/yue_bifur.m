function mat = yue_bifur(fun,x0,a0,a1,N,L,p_siz)
% -------------------------------------------------
% By Yue Wu
% ECE Dept, Tufts University
% 03/03/2010
% All copyrights reserved
% -------------------------------------------------
% Function yue_bifur: plots 1D bifurcation figure
% Input: fun = some function @(x,para)
%        x0 = initial value of x
%        a0 = the start value of parameter a
%        a1 = the end value of parameter a
%         N = the number of intervals for parameter
%         L = the number of iterations for each initial pair 
%               of (x0,parameter a)
%        p_siz = the marker size, default 1
% Output: mat = bifucation matrix with size N by L
%               which stores a length L sequence 
%               for each pair of (x0,parameter a)
%                
% -------------------------------------------------
% Demo: 
% fun = @(x,r) r*x*(1-x); 
% x0 = .4; a0 = 0; a1 = 4; N = 100; L = 50;
% mat = yue_bifur(fun,x0,a0,a1,N,L);
% ---------------------------------------------------

% default settings
if ~exist('p_siz','var')
    p_siz = 1;
end

% initialization
mat = zeros(N,L);
a = linspace(a0,a1,N);

% main loop
format long
for i = 1:N
    ca = a(i); % pick one parameter value at each time
    for j = 1:L % generate a sequence with length L
        if j == 1 
            pre = x0; % assign initial value
            for k = 1:500 % throw out bad data
               nxt = fun(pre,ca); 
               pre = nxt;
            end
        end
        nxt = fun(pre,ca); % generate sequence
        mat(i,j) = nxt; % store in mat
        pre = nxt; % use latest value as the initial value for the next round
    end
end

% plot 
dcolor = [0,0,1]; % Marker color setting: blue        
[r,c] = meshgrid(1:L,a); % associated cooridate data 
surf(r,c,mat,'Marker','*','MarkerSize',p_siz,'FaceColor','None','MarkerEdgeColor', dcolor,'EdgeColor','None')
view([90,0,0]) % change camera direction
ylim([a0,a1]) % fit to data

