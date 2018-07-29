% pdfbclassify_texture.m
% written by: Duncan Po
% Date: December 3, 2002
% perform texture classification based on contourlets 
% 
% Usage:    kld = pdfbclassify_texture(qimage, qformat, tdb, tdir, mdir, firsttime)
% Inputs:   qimage      - query texture image file name
%           qformat     - format of the query texture image file
%           tdb         - texture database: vector (using cell structure)
%                           of the names of all the texture images
%                           e.g. {'texture1', 'texture2', 'texture3'}
%           tdir        - texture directory: full path of the directory 
%                           that contains the texture images
%           mdir        - model directory: full path of the directory that 
%                           either contains the texture models, or that is
%                           for saving of the texture models
%           firsttime   - set to 1 if this is the first time that this
%                           algorithm is run and no model is available
%                           for the database images, set to 0 otherwise           
% Output:   kld         - the Kublick Liebler distance between the trees

function kld = pdfbclassify_texture(qimage, qformat, tdb, tdir, mdir, firsttime)

N = 8;
NN = 16;
if tdir(end) ~= '/'
    tdir = strcat(tdir, '/');
end;
if mdir(end) ~= '/'
    mdir = strcat(mdir, '/');
end;

mdir = strcat(mdir, '/');

[kld, kld2] = pdfbtestall_imagekld(qimage, qformat, tdb, tdir, mdir, N, firsttime);

[skld2, ind2] = sort(kld2);

ind2 = ind2(1:NN-1);
original = imread(qimage, qformat);
figure;
subplot(4,4,1);
imshow(original);

for ploti = 2:NN
    dbimagenum = floor((ind2(ploti-1)-1)/N)+1;
    dbimage = tdb{dbimagenum};
    dbimagenum = mod(ind2(ploti-1)-1, N)+1;
    file = sprintf('%s%s%02d', tdir, dbimage, dbimagenum);
    qresult = imread(file, 'bmp');
    subplot(4,4,ploti);
    imshow(qresult);
end;





