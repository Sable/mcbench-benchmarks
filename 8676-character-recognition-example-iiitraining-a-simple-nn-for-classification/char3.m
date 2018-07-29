%% Character Recognition Example (III):Training a Simple NN for
%% classification

%% Read the image
I = imread('sample.bmp');

%% Image Preprocessing
img = edu_imgpreprocess(I);
for cnt = 1:50
    bw2 = edu_imgcrop(img{cnt});
    charvec = edu_imgresize(bw2);
    out(:,cnt) = charvec;
end

%% Create Vectors for the components (objects)
P = out(:,1:40); 
T = [eye(10) eye(10) eye(10) eye(10)];
Ptest = out(:,41:50);

%% Creating and training of the Neural Network
net = edu_createnn(P,T);

%% Testing the Neural Network
[a,b]=max(sim(net,Ptest));
disp(b);


