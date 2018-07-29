%-fanDTasia ToolBox------------------------------------------------------------------
% This Matlab script is part of the fanDTasia ToolBox: a Matlab library for Diffusion 
% Weighted MRI (DW-MRI) Processing, Diffusion Tensor (DTI) Estimation, High-order 
% Diffusion Tensor Analysis, Diffusion Kurtosis Imaging (DKI) Estimation,
% Tensor ODF estimation, Visualization and more.
%
% A Matlab Tutorial on DW-MRI can be found in:
% http://www.cise.ufl.edu/~abarmpou/lab/fanDTasia/tutorial.php
%
%-CITATION---------------------------------------------------------------------------
% If you use this software please cite the following papers on 4th-order tensors:
% 1) A. Barmpoutis et al. "Diffusion Kurtosis Imaging: Robust Estimation from DW-MRI 
%    using Homogeneous Polynomials", In the Proceedings of ISBI, 2011, pp. 262-265.
% 2) A. Barmpoutis and B.C. Vemuri, "A Unified Framework for Estimating Diffusion 
%    Tensors of any order with Symmetric Positive-Definite Constraints", 
%    In the Proceedings of ISBI, 2010, pp. 1385-1388.
%
%-DESCRIPTION------------------------------------------------------------------------
% This demo script shows how to compute the Diffusion Kurtosis Coefficients from a given 
% Diffusion-Weighted MRI dataset. The method guarantees that the estimated diffusivity as
% well as the Diffusion Tensor are positive semi-definite, using the method
% in Sec. 4.2 of the ISBI'11 paper. Here the given demo dataset consists of 5 voxels,
% 30 gradient directions x 2 b-values from the real brain dataset used in the ISBI'11 paper.
%
%-USE--------------------------------------------------------------------------------
% [D,W]=DEMO_DKI_Estimation_Method2_v2;
%
% D: is a vector with the computed Unique Coefficients of the 2nd-order Diffusion Tensor
% W: is a vector with the computed Unique Coefficients of the 4th-order Kurtosis Tensor
%
%-DISCLAIMER-------------------------------------------------------------------------
% You can use this source code for non commercial research and educational purposes 
% only without licensing fees and is provided without guarantee or warrantee expressed
% or implied. You cannot repost this file without prior written permission from the 
% authors. If you use this software please cite the following papers:
% 1) A. Barmpoutis et al. "Diffusion Kurtosis Imaging: Robust Estimation from DW-MRI 
%    using Homogeneous Polynomials", In the Proceedings of ISBI, 2011.
% 2) A. Barmpoutis and B.C. Vemuri, "A Unified Framework for Estimating Diffusion 
%    Tensors of any order with Symmetric Positive-Definite Constraints", 
%    In the Proceedings of ISBI, 2010, pp. 1385-1388.
%
%-AUTHOR-----------------------------------------------------------------------------
% Angelos Barmpoutis, PhD
% Digital Worlds Institute
% University of Florida, Gainesville, FL 32611, USA
% angelbar at ufl dot edu
%------------------------------------------------------------------------------------
function [DKI_D,DKI_W]=DEMO_DKI_Estimation_Method2_v2

%%% DATA OPENING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%open data files
[S,B]=openFDT('real_data_5voxels.fdt');

%S0 signal, no diffusion weighting
S0=S(:,:,:,1);

%acquisition shell 1, 30 orientations
S_1real=S(:,:,:,[2:31]);
GradientOrientations_1=B([2:31],[1:3]);
BValue_1=B(2,4);

%acquisition shell 2, 30 orientations
S_2real=S(:,:,:,[32:61]);
GradientOrientations_2=B([32:61],[1:3]);
BValue_2=B(32,4);



%%% OPTIONAL: ADD RICIAN NOISE TO THE DATA FOR QUANTITATIVE EVALUATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%

stdv=input('Do you want to add Rician noise to the data for validation? \n If yes, then give the Std. Dev. (e.g: 0.1), otherwise type 0.\n STD.DEV.:');
S_1=S_1real;
for i=1:size(S_1real,4)
    S_1(:,:,:,i)=sqrt((S_1real(:,:,:,i)+stdv*S0.*randn(size(S_1real,1),size(S_1real,2),size(S_1real,3))).^2+(stdv*S0.*randn(size(S_1real,1),size(S_1real,2),size(S_1real,3))).^2);
end
S_2=S_2real;
for i=1:size(S_2real,4)
    S_2(:,:,:,i)=sqrt((S_2real(:,:,:,i)+stdv*S0.*randn(size(S_2real,1),size(S_2real,2),size(S_2real,3))).^2+(stdv*S0.*randn(size(S_2real,1),size(S_2real,2),size(S_2real,3))).^2);
end
%your data can have as many shells and bvalues you want



%%% INITIALIZATION - COMPUTING AUXILIARY DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Construct a constant set of polynomial coefficients C
C_order2=constructSetOf81Polynomials(2)'; %computes C from section 5.1 (ISBI'10)
C_order4=constructSetOf321Polynomials(4)'; %computes C from section 5.1 (ISBI'10)
A_1=D4toDKImatrix(BValue_1);A_1=[A_1(:,[1:6])*C_order2 A_1(:,6+[1:15])];%Computes the matrix A from Table 1 (ISBI'11)
A_2=D4toDKImatrix(BValue_2);A_2=[A_2(:,[1:6])*C_order2 A_2(:,6+[1:15])];%Computes the matrix A from Table 1 (ISBI'11)

%shell 1
G_1_order2=constructMatrixOfMonomials(GradientOrientations_1, 2); %computes G from section 5.1 (ISBI'10)
G_1_order4=constructMatrixOfMonomials(GradientOrientations_1, 4); %computes G from section 5.1 (ISBI'10)
Gbig_1=[-BValue_1*G_1_order2 BValue_1*BValue_1/6*G_1_order4];  %all the monomials for orders 2 and 4.

%shell 2
G_2_order2=constructMatrixOfMonomials(GradientOrientations_2, 2); %computes G from section 5.1 (ISBI'10)
G_2_order4=constructMatrixOfMonomials(GradientOrientations_2, 4); %computes G from section 5.1 (ISBI'10)
Gbig_2=[-BValue_2*G_2_order2 BValue_2*BValue_2/6*G_2_order4];  %all the monomials for orders 2 and 4.

%your data can have as many shells and bvalues you want
Gbig=[Gbig_1; Gbig_2]; %all the monomials for orders 2 and 4 and bvalues b1 and b2.




%%%%%% MAIN LOOP - METHOD: LINEAR FITTING - NO CONSTRAINTS %%%%%%%%%%%%%%%%%%%%%%%%%
for x=1:size(S,1)
    for y=1:size(S,2)
        for z=1:size(S,3)
            
            logS_1=log(squeeze(S_1(x,y,z,:))/S0(x,y,z));
            logS_2=log(squeeze(S_2(x,y,z,:))/S0(x,y,z));
                     
            %The following 2 steps implement the method in Sec. 4.2 of the ISBI'11 paper.
            %Step 1: Compute a positive-definite 4th-order tensor for each b-value
            D4_1=C_order4*lsqnonneg(-G_1_order4*C_order4, logS_1);%computes a positive-definite tensor for b1
            D4_2=C_order4*lsqnonneg(-G_2_order4*C_order4, logS_2);%computes a positive-definite tensor for b2

            %Step 2: Compute DKI from the positive definite 4th-order tensors.
            x1=zeros(size(C_order2,2),1); %the initialization is the zero vector
            x2=zeros(15,1); %the initialization is the zero vector
            for i=1:100 %we perform a kind of gradient descent for a number of iterations
                x1=lsqnonneg([A_1(:,[1:size(C_order2,2)]);A_2(:,[1:size(C_order2,2)])],[D4_1;D4_2]-[A_1(:,[size(C_order2,2)+1:size(A_1,2)]);A_2(:,[size(C_order2,2)+1:size(A_1,2)])]*x2);
                x2_new=pinv([A_1(:,[size(C_order2,2)+1:size(A_1,2)]);A_2(:,[size(C_order2,2)+1:size(A_1,2)])]) * ([D4_1;D4_2]-[A_1(:,[1:size(C_order2,2)]);A_2(:,[1:size(C_order2,2)])]*x1);
                %sum(abs(x2-x2_new)) %I just put this here for convergence check
                x2=x2_new;
            end
            dki=[C_order2*x1;x2];         

            %Optional Validation if user adds noise to the data
            if stdv>0
                logS_1=log(squeeze(S_1real(x,y,z,:))/S0(x,y,z));
                logS_2=log(squeeze(S_2real(x,y,z,:))/S0(x,y,z));
                err(:,x,y,z)=abs(Gbig*dki-[logS_1; logS_2]);
            end
            
            %Store the data
            DKI_D(:,x,y,z)=dki([1:6]); %The 6 unique coefficients of the diffusion tensor D
            %If you want you can put the result in the form of a 3x3 matrix
            %D=[dki(6) dki(5)/2 dki(4)/2
            %   dki(5)/2 dki(3) dki(2)/2
            %   dki(4)/2 dki(2)/2 dki(1)];
            
            DKI_W(:,x,y,z)=dki([7:21]); %The 15 unique coefficients of the kurtosis tensor W
            %You can see which coefficient is which you can use the function: printTensor(DKI_W(:,x,y,z),4)
            % or if you want to plot a tensor or a tensor field as spherical functions
            % you have to download the plotTensors.m function developed by Angelos Barmpoutis, Ph.D.
            % and then uncomment the following lines.
            % 
            % plotTensors(DKI_D(:,1,1,1),1,[321 1]); %3D ellipsoidal plot of D
            % plotTensors(DKI_W(:,1,1,1),1,[321 1]); %3D ellipsoidal plot of W
            
            %Optional Calculation of Dapp and Kapp
            Dapp(:,x,y,z) = G_1_order2*dki(1:6);
            Kapp(:,x,y,z) = (G_1_order4*dki(7:21))./((G_1_order2*dki(1:6)).^2);
            
        end
    end
end


%%%%%% OPTIONAL: PRINT RESULTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all_err=[];
all_Dapp=[];
all_Kapp=[];
counter=0;
meanD=zeros(6,1);
meanW=zeros(15,1);
for x=1:size(S,1)
    for y=1:size(S,2)
        for z=1:size(S,3)
            if stdv>0
               all_err=[all_err; err(:,x,y,z)];
            end
            all_Dapp=[all_Dapp; Dapp(:,x,y,z)];
            all_Kapp=[all_Kapp; Kapp(:,x,y,z)];
            meanD=meanD+DKI_D(:,x,y,z);
            meanW=meanW+DKI_W(:,x,y,z);
            counter=counter+1;
        end
    end
end
meanD=meanD/counter;
meanW=meanW/counter;

fprintf(1,'\n-----RESULTS:-----\n\n');
fprintf('Number of fitted voxels: %d\n',counter);
if stdv>0
    fprintf(1,'Fitting Error: %.4f (std. dev. %.4f)\n',mean(all_err),std(all_err));
end
fprintf(1,'Mean Dapp: %.4f (std. dev. %.4f)\n',mean(all_Dapp),std(all_Dapp));
fprintf(1,'Mean Kapp: %.4f (std. dev. %.4f)\n',mean(all_Kapp),std(all_Kapp));
fprintf(1,'\nMean Diffusion Tensor D:\n');
printTensor(meanD,2);
fprintf(1,'\nMean Kurtosis Tensor W:\n');
printTensor(meanW,4);

% If you want to plot a Diffusion or Kurtosis tensor as spherical functions
% you have to download the plotTensors.m function developed by Angelos Barmpoutis, Ph.D.
% and then uncomment the following lines.
%
% subplot(1,2,1)
% plotTensors(meanD,1,[321 1]);
% title('Mean Diffusion Tensor');
% subplot(1,2,2);
% plotTensors(meanW,1,[321 1]);
% title('Mean Kurtosis Tensor');


fprintf(1,'\nIf you use this software please cite the following papers on DKI and DTI estimation:\n');
fprintf(1,'1) A. Barmpoutis et al. "Diffusion Kurtosis Imaging: Robust Estimation from DW-MRI\n'); 
fprintf(1,'   using Homogeneous Polynomials", In the Proceedings of ISBI, 2011, pp. 262-265.\n');
fprintf(1,'2) A. Barmpoutis and B.C. Vemuri, "A Unified Framework for Estimating Diffusion Tensors\n'); 
fprintf(1,'   of any order with Symmetric Positive-Definite Constraints",\n');
fprintf(1,'   In the Proceedings of ISBI, 2010, pp. 1385-1388.\n');
