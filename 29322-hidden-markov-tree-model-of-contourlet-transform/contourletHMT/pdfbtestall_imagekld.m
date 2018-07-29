% pdfbtestall_imagekld.m
% written by: Duncan Po
% Date: December 3, 2002
% calculate the Kublick-Liebler distance between a query image and all 
% database images based on their hidden markov tree parameters
% Usage:    [kld, kld2] = pdfbtestall_imagekld(qimage, qformat, db, tdir, mdir, N, firsttime)
% Inputs:   qimage      - query image file name
%           qformat     - format of the query image file
%           db          - this should be a cell vector containing the
%                           names of all the images in the database
%                           e.g. db = {'image1', 'image2', 'image3'}    
%           tdir        - database directory: full path of the directory 
%                           that contains the database images
%           mdir        - model directory: full path of the directory that 
%                           either contains the database image models or that is
%                           for saving of the database image models
%           N           - number of subimages obtained from each image
%           firsttime   - set to 1 if this is the first time that this
%                           algorithm is run and no model is available
%                           for the database images and set to 0 otherwise
% Output:   kld         - the Kublick Liebler distance upperbound between 
%                           the trees
%           kld2        - the kublick Liebler distance estimate using Monte-
%                           Carlo method                              

function [kld, kld2] = pdfbtestall_imagekld(qimage, qformat, db, tdir, mdir, N, firsttime)

[model, dummy] = pdfbtrainimagethmt(qimage, qformat, '', 0.01);

for i=1:length(db)
    for j = 1:N
        if firsttime ==1
            file = sprintf('%s%s%02d', tdir, db{i}, j);
            savefile = sprintf('%s%02d', db{i}, j);
            [kld((i-1)*N+j), kld2((i-1)*N+j)] = ...
                pdfbcalc_imagekld(savefile, mdir, file, model, 'bmp');
        else
            modelfile = sprintf('%s%s%02d', mdir, db{i}, j);
            load(modelfile);
            [kld((i-1)*N+j), kld2((i-1)*N+j)] = ...
                pdfbcalc_imagekld('', '', model1, model);
        end;
    end;
end;
