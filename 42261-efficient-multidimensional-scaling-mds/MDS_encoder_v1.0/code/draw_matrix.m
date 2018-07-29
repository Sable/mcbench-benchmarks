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


% Visualize the confusion matrix. 

function draw_matrix(CM)
% CM: confusion matrix

figure;
imagesc(1-CM,[0 1]);
colormap gray;
N=size(CM,1);
for i=1:N
    for j=1:N
        if CM(i,j)>0.5
            the_color=[1 1 1];
        else
            the_color=[0 0 0];
        end
        text(j-0.2,i,[num2str(CM(i,j)*100,'%.2f') '%'],...
            'Color',the_color,'FontSize',15);
    end
end
title('confusion matrix');
xlabel('predicted label');
ylabel('true label');
