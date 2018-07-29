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
%   Contours for Image Segmentation. (Accepted by CVIU,2013, DOI http://dx.doi.org/10.1016/j.cviu.2013.05.003 )
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Note: 
% The parameters of both ADF(weights,iter,sigma,deltat) and active contour 
% internal energy (ITER,alpha,beta,gamma,kappa) are set according to different images. 
% Please see MyADF function.
%--------------------------------------------------------------------------


% ==== Example 1: concavity image ====  
% Read an image,a synthetic image which is a concavity of
% 3-pixel width and 150-pixel depth

    filename = 'conv3-150';
    if ~isdir(['.\ResultsImage\' filename])
        mkdir(['.\ResultsImage\' filename]);
    end
    
    disp('--------------------------------------------------')
    disp('open an image')
    G = imread(['image\' filename '.bmp']);
    [row,col,t]=size(G);
    if t>1
    G=G(:,:,1);
    end
    I=double(G);
    figure(1);
    imdisp(I);
    title('Original image');

% Compute its edge map f
    disp('--------------------------------------------------')
    disp('streamline image')
    I0=1-I/255;  
    f=I0;
    figure(2)
    imdisp(f);
    title('streamline Edge map');
   
  % Compute the ADF of the edge map   
    disp('--------------------------------------------------')
    disp('display AGVF force field')  
    [u,v] = MyADF(f,[0 0.1],300,0.15,.5,'null','ns');
%   [u,v] = MyADF(f, weights,iter,sigma,deltat,fil,show)
    mag = sqrt(u.*u+v.*v);
    px = u./(mag+1e-10); py = v./(mag+1e-10); 
    figure(3);
    imdisp(I);
    hold on
    quiver(px,py,'r','LineWidth',1);
    title('Adaptive GVF field');
    F = getframe(gca);%  save results
    Newfilename=strcat('ResultsImage\', filename, '\forcefiled');
    imwrite(F.cdata,[Newfilename,'.bmp']);
    hold off
   
% initialization
      figure(4);
      imdisp(I);
      [x,y]=snakeinit2(1);%initialization by hand
      [x,y] = snakeinterp(x,y,1,0.2); 
      hold on, 
      plot([x;x(1,1)],[y;y(1,1)],'r--','LineWidth',3);
      hold off
%-------------------------
      F = getframe(gca);%  save results
      Newfilename=strcat('ResultsImage\',filename, '\evolution0');
      imwrite(F.cdata,[Newfilename,'.bmp']);
 

%% snake deformation
ITER=120;
alpha=0.1;
beta=0.06;
gamma=1;
kappa=1;

figure(5),
imdisp(I); 
hold on,
plot([x;x(1,1)],[y;y(1,1)],'r--','LineWidth',3)
hold off
    for i=1:ITER
        [x,y] = snakedeform(x,y,alpha,beta,gamma,kappa,px,py,5);
        [x,y] = snakeinterp(x,y,1,0.5);
        hold on
        x = x(:); y = y(:);
        plot([x;x(1,1)],[y;y(1,1)],'r','LineWidth',1);
        
       F = getframe(gca);%  save results
       Newfilename=strcat('ResultsImage\',filename, '\evolution');
       imwrite(F.cdata,[Newfilename,num2str(i*5),'.bmp']);
       hold off   
       title(['Deformation in progress,  iter = ' num2str(i*5)]);
       pause(0.5);
        

                    
    end  
      hold on, 
    plot([x;x(1,1)],[y;y(1,1)],'LineWidth',3,'Color','r');
    hold off
    F = getframe(gca);%  save results
    Newfilename=strcat('ResultsImage\',filename, '\evolution');
    imwrite(F.cdata,[Newfilename,num2str(i*5),'.bmp']);

   %% save the ultimate result
    figure(6),
    imdisp(I),
    title('Result');
    hold on, plot([x;x(1,1)],[y;y(1,1)],'LineWidth',3,'Color','r');
    F = getframe(gca);%  save results
    Newfilename=strcat('ResultsImage\',filename, '\evolution1111');
    imwrite(F.cdata,[Newfilename,'.bmp']); 
   
