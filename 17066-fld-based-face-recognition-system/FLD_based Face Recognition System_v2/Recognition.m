function OutputName = Recognition(TestImage, m_database, V_PCA, V_Fisher, ProjectedImages_Fisher)
% Recognizing step....
%
% Description: This function compares two faces by projecting the images into facespace and 
% measuring the Euclidean distance between them.
%
% Argument:      TestImage              - Path of the input test image
%
%                m_database             - (M*Nx1) Mean of the training database
%                                         database, which is output of 'EigenfaceCore' function.
%
%                V_PCA                  - (M*Nx(P-1)) Eigen vectors of the covariance matrix of 
%                                         the training database

%                V_Fisher               - ((P-1)x(C-1)) Largest (C-1) eigen vectors of matrix J = inv(Sw) * Sb

%                ProjectedImages_Fisher - ((C-1)xP) Training images, which
%                                         are projected onto Fisher linear space
% 
% Returns:       OutputName             - Name of the recognized image in the training database.
%
% See also: RESHAPE, STRCAT

% Original version by Amir Hossein Omidvarnia, October 2007
%                     Email: aomidvar@ece.ut.ac.ir                  

Train_Number = size(ProjectedImages_Fisher,2);
%%%%%%%%%%%%%%%%%%%%%%%% Extracting the FLD features from test image
InputImage = imread(TestImage);
temp = InputImage(:,:,1);

[irow icol] = size(temp);
InImage = reshape(temp',irow*icol,1);
Difference = double(InImage)-m_database; % Centered test image
ProjectedTestImage = V_Fisher' * V_PCA' * Difference; % Test image feature vector

%%%%%%%%%%%%%%%%%%%%%%%% Calculating Euclidean distances 
% Euclidean distances between the projected test image and the projection
% of all centered training images are calculated. Test image is
% supposed to have minimum distance with its corresponding image in the
% training database.

Euc_dist = [];
for i = 1 : Train_Number
    q = ProjectedImages_Fisher(:,i);
    temp = ( norm( ProjectedTestImage - q ) )^2;
    Euc_dist = [Euc_dist temp];
end

[Euc_dist_min , Recognized_index] = min(Euc_dist);
OutputName = strcat(int2str(Recognized_index),'.jpg');
