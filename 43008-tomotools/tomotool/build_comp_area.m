clear
clc
im = testmat(109,105);
a = 0:17:179;
[W5,p5,t5] = build5(im,a);
[W7,p7,t7] = build7(im,a);
[W8,p8,t8] = build8(im,a);
fprintf(['\nElapsed time:\nbuild5 %f seconds'...
    '\nbuild7 %f seconds\nbuild8 %f seconds\r'],...
    t5,t7,t8);
%Variance
% var_78 = var(W7(:)-W8(:));
% fprintf('\nVariance8: %f\r',var_78);
