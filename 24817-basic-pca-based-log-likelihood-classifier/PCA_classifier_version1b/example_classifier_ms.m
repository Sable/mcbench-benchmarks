% Example application of two class log likelihood classifier based on PCA
% Detects Multiple Scelerosis Lesions

% Compile the c-code
mex get_feature_vectors.c -v

% Read training data of patient 1
I_FLAIR=im2double(imread('TrainingData/patient1_FLAIR.png'));
I_T1=im2double(imread('TrainingData/patient1_T1.png'));
I_T2=im2double(imread('TrainingData/patient1_T2.png'));
% Combine the data to one image (Like a color image)
I_patient1=zeros([size(I_FLAIR) 4]);
I_patient1(:,:,1)=I_FLAIR./mean(I_FLAIR(I_FLAIR(:)>0)); 
I_patient1(:,:,2)=I_T1./mean(I_T1(I_T1(:)>0)); 
I_patient1(:,:,3)=I_T2./mean(I_T2(I_T2(:)>0));
% also add a gradient image
[fy,fx]=gradient(I_FLAIR);
I_patient1(:,:,4)=fx.^2+fy.^2;

% The Multiple Sclerosis Lesions marked by an expert
I_lesions_patient1=im2double(imread('TrainingData/patient1_lesion.png'));

% Show the trainingdata set from this patient
figure, 
subplot(2,2,1),imshow(I_FLAIR,[]); title('FLAIR of Training set patient 1');
subplot(2,2,2),imshow(I_T1,[]); title('MRI T1');
subplot(2,2,3),imshow(I_T2,[]); title('MRI T2');
I_comb(:,:,1)=I_FLAIR+double(I_lesions_patient1>0.5); I_comb(:,:,2)=I_FLAIR; I_comb(:,:,3)=I_FLAIR;
subplot(2,2,4),imshow(I_comb,[]); title('Lesions annotated by expert');


% Read training data of patient 2
I_FLAIR=im2double(imread('TrainingData/patient2_FLAIR.png'));
I_T1=im2double(imread('TrainingData/patient2_T1.png'));
I_T2=im2double(imread('TrainingData/patient2_T2.png'));
% Combine the data to one image
I_patient2=zeros([size(I_FLAIR) 4]);
I_patient2(:,:,1)=I_FLAIR./mean(I_FLAIR(I_FLAIR(:)>0)); 
I_patient2(:,:,2)=I_T1./mean(I_T1(I_T1(:)>0)); 
I_patient2(:,:,3)=I_T2./mean(I_T2(I_T2(:)>0));
[fy,fx]=gradient(I_FLAIR);
I_patient2(:,:,4)=fx.^2+fy.^2;

% The Multiple Sclerosis Lesions marked by an expert
I_lesions_patient2=im2double(imread('TrainingData/patient2_lesion.png'));

% Show the trainingdata set from this patient
figure, 
subplot(2,2,1),imshow(I_FLAIR,[]); title('FLAIR of Training set patient 1');
subplot(2,2,2),imshow(I_T1,[]); title('MRI T1');
subplot(2,2,3),imshow(I_T2,[]); title('MRI T2');
I_comb(:,:,1)=I_T1+double(I_lesions_patient2>0.5); I_comb(:,:,2)=I_T1; I_comb(:,:,3)=I_T1;
subplot(2,2,4),imshow(I_comb,[]); title('Lesions annotated by expert');


% Make a matrix with the training data feature vectors from the lesion
% pixels, the featurvectors are local intensity patches
[x1_ms,y1_ms]=find(I_lesions_patient1>0.5); x1_ms=x1_ms(:);  y1_ms=y1_ms(:);
[x2_ms,y2_ms]=find(I_lesions_patient2>0.5); x2_ms=x2_ms(:);  y3_ms=y2_ms(:);
sizepatch=[17 17];
L1=get_feature_vectors(I_patient1,x1_ms,y1_ms,sizepatch);
L2=get_feature_vectors(I_patient2,x2_ms,y2_ms,sizepatch);
% The MS training feature vectors
L=[L1 L2];

% Make a matrix with the training data feature vectors from the NON lesion 
% pixels (don't use the black boundary pixels, data must be gaussian
% and keep only 5% to save memory).
[x1_non_ms,y1_non_ms]=find((I_lesions_patient1<0.5)&(I_patient1(:,:,1)>0.1));
[x2_non_ms,y2_non_ms]=find((I_lesions_patient2<0.5)&(I_patient2(:,:,1)>0.1));
x1_non_ms=x1_non_ms(1:20:end);y1_non_ms=y1_non_ms(1:20:end); 
x2_non_ms=x2_non_ms(1:20:end);y2_non_ms=y2_non_ms(1:20:end);
G1=get_feature_vectors(I_patient1,x1_non_ms,y1_non_ms,sizepatch);
G2=get_feature_vectors(I_patient2,x2_non_ms,y2_non_ms,sizepatch);
% The non-MS training feature vectors
G=[G1 G2];

% Train/Make a PCA log likelihood model
[Lmean,Gmean,Cgppca,invCgppca,Vtot]=train_model(L,G);

% Read the test data of patient 3
I_FLAIR=im2double(imread('TestData/patient3_FLAIR.png'));
I_T1=im2double(imread('TestData/patient3_T1.png'));
I_T2=im2double(imread('TestData/patient3_T2.png'));
% Combine the data to one image
I_patient3=zeros([size(I_FLAIR) 3]);
I_patient3(:,:,1)=I_FLAIR./mean(I_FLAIR(I_FLAIR(:)>0));
I_patient3(:,:,2)=I_T1./mean(I_T1(I_T1(:)>0)); 
I_patient3(:,:,3)=I_T2./mean(I_T2(I_T2(:)>0));
[fy,fx]=gradient(I_FLAIR);
I_patient3(:,:,4)=fx.^2+fy.^2;

LogLikelihood=zeros(size(I_FLAIR));
x=1:size(I_FLAIR,1);
for y=1:size(I_FLAIR,2)
    % Get the feature vectors from a column of pixels in the test image
    T=get_feature_vectors(I_patient3,x,y*ones(size(x)),sizepatch);
    
    % Apply the PCA log likelihood model on the test data.
    [distanceL,distanceG,LogLikelihood_column]=apply_model(T,Lmean,Gmean,Cgppca,invCgppca,Vtot);
    LogLikelihood(:,y)=LogLikelihood_column;
end

% Reshape result to image
LogLikelihood=reshape(LogLikelihood,size(I_FLAIR));

% show results
figure, 
subplot(2,2,1),imshow(I_FLAIR,[]); title('FLAIR of test set patient 3');
subplot(2,2,2),imshow(I_T1,[]); title('MRI T1');
subplot(2,2,3),imshow(I_T2,[]); title('MRI T2');
I_comb(:,:,1)=I_FLAIR+double(LogLikelihood>-10); I_comb(:,:,2)=I_FLAIR; I_comb(:,:,3)=I_FLAIR;
subplot(2,2,4),imshow(I_comb); title('Tresholded log-likelihood on pixels');






