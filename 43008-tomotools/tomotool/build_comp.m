clear
clc
im = testmat(96);
a = 0:6:179;
[~,~,t1] = build1(im,a);
[~,~,t2] = build2(im,a);
[~,~,t4] = build4(im,a);
[~,~,t5] = build5(im,a);
[~,~,t6] = build6(im,a);
ixstr = {'build1','build2','build4','build5','build6'};
[tmin,ix] = min([t1,t2,t4,t5,t6]);
fprintf(['\nElapsed time:\nbuild1 %f seconds\nbuild2 %f seconds'...
    '\nbuild4 %f seconds\nbuild5 %f seconds\nbuild6 %f seconds\r'],...
    t1,t2,t4,t5,t6);
fprintf(['\nBest Method: ' ixstr{ix} ', %f seconds\r'],tmin)
% NOTE:
% build1: compute [x,y] in a for-loop
% build2: compute [x,y] in a matrix
% build4: store W in cell
% build5: if W is small, W is a matrix, else W is a sparse
% build6: combine matrix and sparse
