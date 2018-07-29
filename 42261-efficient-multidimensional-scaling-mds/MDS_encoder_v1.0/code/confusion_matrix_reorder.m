% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>, 
% Signal Analysis and Machine Perception Laboratory, 
% Department of Electrical, Computer, and Systems Engineering, 
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA
% 
% You are free to use this software for academic purposes if you cite our paper: 
% Quan Wang and Kim L. Boyer. 
% Feature Learning by Multidimensional Scaling and its Applications in Object Recognition.
% 2013 26th SIBGRAPI Conference on Graphics, Patterns and Images (Sibgrapi). IEEE, 2013.
% 
% For commercial use, please contact the authors. 


% Reorder columns of the confusion matrix, so that large values are on 
% the diagonal. 

function CM=confusion_matrix_reorder(CM)
% CM: confusion matrix

N=size(CM,1);
for row=1:N
    eval=CM(row,row:N);
    [~, index]=max(eval);
    index=index+row-1;
    if index~=row
        CM(:,[row index])=CM(:,[index row]);
    end
end