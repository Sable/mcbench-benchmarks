close;
clear;

load models.mat;
scale_rat = 10;
NN_Number = 5;

%[ img1_desc_types, detectedPts1, locations1,pts1 ] = create_mesh_sift_features(vertex1, faces1, scale_rat);
[ img1_desc_types, ~, ~,pts1 ] = create_mesh_spin_features(vertex1, faces1,5,scale_rat);

%[ img2_desc_types, detectedPts2, locations2,pts2] = create_mesh_sift_features(vertex2, faces2, scale_rat);
[ img2_desc_types, ~, ~,pts2] = create_mesh_spin_features(vertex2, faces2,5,scale_rat);

DescrData = pdist2(img1_desc_types,img2_desc_types);

[~,NN_Data]=sort(DescrData,2,'ascend');
NN_Data=NN_Data(:,1:NN_Number);
