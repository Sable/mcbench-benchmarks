% Run this sample will cost you less than 5 minutes

% By Suicheng Gu at Peking University, Jan. 5, 2009
% Email: gusuch@gmail.com
% The images has been pre-processed by Laplacian Smoothing Transform (LST).
% Using LST + SVDA, we obtained test error rates of 5.45% (Fisherface: 7.3%)  
% and 0.00% (Fisherface: 0.6%) on cropped and full face images, respectively.

load('yale_lst.mat');
total=oneoutsvnn(fea(:,1:80),gnd,14);
fprintf('Test error rate under leave-one-out strategy\n on cropped Yale face database is:');
fprintf('%5.2f', total/1.65);
fprintf('%%.\n');

load('yale_full.mat');
totalf=oneoutsvnn(normlst(:,1:80),gnd,14);
fprintf('Test error rate under leave-one-out strategy\n on Full Yale face database is:');
fprintf('%5.2f', totalf/1.65);
fprintf('%%.\n');