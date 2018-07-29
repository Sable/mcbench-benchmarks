%--------------------------------------------------------------------------
% by Yuwei Wu
%
%Media Computing and Intelligent Systems Lab
%BeiJing Insititute of Technology
%100081,P.R.C
%email:wuyuwei@bit.edu.cn
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%Acknowledgement:
% Basic framework  comes from GVF.m develped by Mr Xu C. and Prince J. 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%  Ref.
%  [1]  Yuwei Wu, Yunde Jia, Yuanquan Wang, ¡°Adaptive Diffusion Flow for
%  Parametric Active Contours¡±£¬20th International Conference on Pattern
%  Recognition (ICPR),2010, PP.2788-2791.
%   [2]  Yuwei Wu, Yuanquan Wang, Yunde Jia. Adaptive Diffusion Flow Active
%   Contours for Image Segmentation. (Accepted by CVIU 2013, DOI http://dx.doi.org/10.1016/j.cviu.2013.05.003 )
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Note: 
% The parameters of both ADF(weights,iter,sigma,deltat) and active contour 
% internal energy (ITER,alpha,beta,gamma,kappa) are set according to different images. 
% Please see MyADF function.
%--------------------------------------------------------------------------

% ==== Example 3: noisy image ====  
% To evaluate the noise sensitivity of the ADF snake model,
% varying amounts of impulse noise is
% added to the simple harmonic curves.

filename = 'clover0.4';
if ~isdir(['.\ResultsImage\' filename])
    mkdir(['.\ResultsImage\' filename]);
end

disp('--------------------------------------------------')
disp('open an image')    
% Read in the cardiac image
G = imread(['image\' filename '.bmp']);
[row,col,t]=size(G);
if t>1
G=G(:,:,1);
end
I=double(G);
figure(1);
imdisp(I);
title('Original image');

% Compute its edge map
     disp(' Compute edge map ...');
     I0 = gaussianBlur(I,2);
     II=1-I0/255;  
     [u1,v1] = gradient(II); %---------- Compute its edge map
     f =sqrt(u1.^2+v1.^2); 
     figure(2)
     imdisp(f);
     title('Step Edge map');
     F = getframe(gca);%  save results
     Newfilename=strcat('ResultsImage\',filename,'\edgemap');
     imwrite(F.cdata,[Newfilename,'.bmp']);

   % Compute the GVF of the edge map f
disp('--------------------------------------------------')
     disp('display AGVF force field')  
     [u,v]  = MyADF(f,[0 0.05],10,4,0.5,'nul','ns');
%    [u,v] = MyADF(f, weights,iter,sigma,deltat,fil,show)
     mag = sqrt(u.*u+v.*v);
         px = u./(mag+1e-10); py = v./(mag+1e-10); 
         
         % display the GVF 
         figure(3);
         imdisp(I);
          hold on
         quiver(px,py,'r','LineWidth',1);
          title('Adaptive GVF field');
        F = getframe(gca);%  save results
        Newfilename=strcat('ResultsImage\',filename,'\forcefiled');
        imwrite(F.cdata,[Newfilename,'.bmp']);
hold off

% initialization
  figure(4);
  imdisp(I);
         t = 0:0.05:6.28;
         x = 64 + 15*cos(t);
         y = 64 + 15*sin(t);
    [x,y] = snakeinterp(x,y,1,0.2);
  hold on, plot([x;x(1,1)],[y;y(1,1)],'w--','LineWidth',2);
 hold off
 pause(1);
     
%% snake deformation
ITER=10;
alpha=0.5;
beta=0.5;
gamma=1;
kappa=1;

 figure(5),
 imdisp(I); 
hold on, plot([x;x(1,1)],[y;y(1,1)],'w--','LineWidth',2)
    for i=1:ITER
        [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,5);
        [x,y] = snakeinterp(x,y,1,0.5);
       hold on
       x = x(:); y = y(:);
       plot([x;x(1,1)],[y;y(1,1)],'w','LineWidth',1);
       F = getframe(gca);%  save results
       Newfilename=strcat('ResultsImage\',filename,'\evolution');
       imwrite(F.cdata,[Newfilename,num2str(i*5),'.bmp']);
       hold off   
        title(['Deformation in progress,  iter = ' num2str(i*5)]);
       pause(0.5);
                    
    end  
    
    hold on, plot([x;x(1,1)],[y;y(1,1)],'LineWidth',3,'Color','w');
        F = getframe(gca);%  save results
        Newfilename=strcat('ResultsImage\',filename,'\evolution');
        imwrite(F.cdata,[Newfilename,num2str(i*5),'.bmp']);
%% save the ultimate result     
    figure(6),
     imdisp(I),
    title('Result');
    hold on, plot([x;x(1,1)],[y;y(1,1)],'LineWidth',3,'Color','w');
%-------------------
   F = getframe(gca);%  save results
   Newfilename=strcat('ResultsImage\',filename,'\evolution1111');
   imwrite(F.cdata,[Newfilename,'.bmp']);  
   


