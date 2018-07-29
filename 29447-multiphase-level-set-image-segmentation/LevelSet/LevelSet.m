

% Description:
% 
% This Matlab/C code performs level set image segmentation using 
% 
%  (1) Several multiphase (or multiregion) methods, including a fast scheme which results
%      in a significant reduction in the computational load (the complexity grows linearly
%      as a function of the number of regions).
% 
%  (2) Several region-based image descriptions more complex than the standard piecewise 
%      constant Chan-Vese model, including
% 
%      - A Gamma description that is applicable to image data corrupted with a multiplicative
%        noise, e.g., data of the type SAR (synthetic aperture radar) in remote sensing, and of
%        the type ultrasound, in medical imaging.
%  
%      - A kernel-mapping description that is flexible enough to be applicable to a variety of 
%        real images and noise types, including medical, satellite and natural images.
% 
% 
% Before using this script, the user need to compile the C files by running compiler.m in Matlab 
% 
% These functions were tested on the following versions of MATLAB and C
%    MATLAB version: 7.7.0.471 (R2008b)
%    C compiler: Lcc-win32 C 2.4.1 
% 
% This software can be used only for research purposes, and is provided "as is", without warranty
% of any kind. Please cite the papers and book mentioned below in any resulting publication.
% Formal and complete details on the implementations as well as on the derivation of the level set
% evolution equations for the various energy functional types used in the software can be found in 
% the book "Variational and Level Set Methods in Image Segmentation" 
% by Amar Mitiche and Ismail Ben Ayed 2010, Springer, 1st edition.



% The users need to enter the inputs here (a full description of the meaning of these inputs 
% will follow)
input_image='Images/brain.tif';
output_image='Images/Result.tif';
nb_regions='3';
nb_iterations='50';
curvature='20';
time_step='0.001';
display_frequency='5';
initialization='1';
segmentation_method='clust';

% Description of the inputs

% a) input_image: the image to be segmented

% b) output_image: the segmentation result

% c) output_image: the segmentation result

% d) nb_regions: the number of segmentation regions

% e) nb_iterations: the number of iterations

% f) curvature: the weight of the curvature velocity (or  smoothness term).
%    The higher the weight, the smoother the segmentation boundaries. Noisy images (e.g., SAR data) 
%    often require a high smoothness weight, e.g., curvature='2000'.

% g) time_step: the gradient-descent time step of curve evolution. a large step yields faster 
%    evolution but lesser stability. Typical values of this parameter are in between 0.0001 and
%    0.001. 
%   
% h) display_frequency:  the frequency of display of the active curve during the evolution. 
%    For instance, when display_frequency='20', the active curve is superimposed on the image each
%    20 iterations.

% i) initialization: this option defines the initial curves which can be either circles centered
%    about the middle of the image (initialization='1') or small circles all over the input 
%    image (initialization='1'). 

% j) segmentation_method: this variable defines the image model and/or the multiphase method. 
%     The following lists and explains the possible options for this variable:
      
%      - segmentation method =  'gamma'
      
%      This function implements level set image segmentation by minimizing a data term which measures
%      the conformity of image data within each region to the Gamma model. It is usefull for image 
%      data corrupted with a multiplicative noise such as in radar and ultrasound data. Please cite 
%      the following paper in any resulting publication:

%      [1] I.  Ben Ayed, A. Mitiche, and Z. Belhadj, “Multiregion level set partitioning on synthetic 
%          aperture radar images,” IEEE Transactions on Pattern Analysis and Machine Intelligence, 
%          vol. 27, no. 5, pp. 793–800, 2005.
  
%       Note that this gamma segmentation function requires a small time step, e.g., time_step='0.0001'.

%      - segmentation method =  'ker'

%      This  method implements a kernel function which maps implicitly the original image data into data
%      of a higher dimension so that the piecewise constant model becomes applicable to images corrupted 
%      with various noise models. This leads to a flexible alternative to complex modeling of the image 
%      data. The function is applicable to a variety of real images such as medical, satellite and natural 
%      images. Please cite the following paper in any resulting publication:
%   
%      [2] M. Ben Salah, A. Mitiche and I. Ben Ayed, Effective Level Set Image Segmentation with a Kernel 
%          Induced Data Term, IEEE Transactions on Image processing, vol. 19, no 1, pp. 220-232, 2010. 

%       Note that this kernel segmentation function requires a small time step, e.g., time_step='0.0001'.
  
%       - Segmentation method =  'mean'

%       This function implements level set image segmentation by minimizing the classical Chan-Vese data 
%       term which measures the conformity of image data within each region to the piecewise constant model. 

%       - Segmentation method =  'Gaussian'
%         This function implements a Gaussian generalization of the classical  piecewise constant model.
    
%     Note that the case of a number of regions more than 2 (the multiphase case) uses several curves which 
%   can intersect. Therefore, a two-region formulation cannot be generalized directly by assigning a region
%   to the interior of each curve because region membership becomes ambiguous when the curves intersect.  
%   The following lists the possible options to evolve multiple curves so that, at convergence, the curves
%   define a partition of the image domain:

%       - Segmentation method = 'clust'

%         This method embeds directly a simple partition constraint in the curve evolution equations. 
%         Starting from an arbitrary initial  partition, the constraints implements the rule that if 
%         a point leaves a region, it is claimed by a single other region. The scheme is fast, and 
%         results in a significant reduction in the computational load (the complexity grows linearly
%         as a function of the number of regions). Please cite the following papers in any resulting
%         publication:

%         [3] I. Ben Ayed, A. Mitiche, and Z. Belhadj, Polarimetric image segmentation via maximum 
%             likelihood approximation and efficient multiphase level sets,” IEEE Transactions on Pattern 
%             Analysis and Machine Intelligence, vol. 28, no. 9, pp. 1493–1500, 2006. 

%         [4] I. Ben Ayed and A. Mitiche: A Partition Constrained Minimization Scheme for Efficient 
%             Multiphase Level Set Image Segmentation. IEEE ICIP 2006, pp. 1641-1644

%         [5] I. Ben Ayed and A. Mitiche, “A region merging prior for variational level set image 
%             segmentation,” IEEE Transactions on Image Processing, vol. 17, no. 12, pp. 2301–2313, 2008. 

%        - Segmentation method = 'part'

%         This method implements a systematic general mapping between the segmentation regions and the 
%         regions defined by the curves and their intersections. The mapping guarantees, by definition,
%         a partition at all times during curve evolution. Please cite the following paper in any resulting 
%         publication:

%         [6] A. Mansouri, A. Mitiche, and C. Vazquez, “Multiregion competition: A level set extension of 
%             region competition to multiple region partioning,”  Computer Vision and Image Understanding, vol. 
%             101, no. 3, pp. 137–150, 2006.

%        - Segmentation method = 'ker_part'

%          This option implements the kernel method in [2] with the multiphase method in [6]. Please cite these
%          two papers in any resulting publication. 


%     Note that when Segmentation method = 'gamma',  'ker', 'mean' or 'gaussian' and when the number of regions is 
%  more than 2 (nb_regions> 2), the default multiphase method is the one described in the following papers: 
   
%         [7] C. Vazquez, A. Mitiche, Ismail Ben Ayed, “Image segmentation as regularized clustering: a fully 
%             global curve evolution method,” IEEE ICIP 2004, pp. 3467-3470.

%      This multiphase method views image segmentation as spatially regularized image data clustering, leading to the 
%      simultaneous minimization of N ?1 functionals to segment an image into N regions, each minimization involving 
%      a single region and its complement. Please cite [7] in any resulting publication.

M=imread(input_image);

global x_iteration;
x_iteration=nb_iterations;
global x_frequency;
x_frequency=display_frequency;
global x_region;
x_region=nb_regions;

curvature = num2str(str2double(curvature) * str2double(time_step));
structure(1).in= input_image;
structure(1).out= output_image;
structure(1).sf= segmentation_method;
structure(1).Nls= nb_iterations;
structure(1).N= nb_regions;
structure(1).nb= display_frequency;
structure(1).var= '0';
structure(1).K= curvature;
structure(1).dt= time_step;
structure(1).start= initialization;
structure(1).vect= 'no';

Seg2_Stim(22, structure);