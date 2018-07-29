% pdfbcalc_imagekld.m
% written by: Duncan Po
% Date: November 16, 2002
% calculate the Kublick-Liebler distance between two images based on 
% on their hidden markov tree parameters
% Usage:    kld = pdfbcalc_imagekld(savename, sdir, model1, model2)
%           kld = pdfbcalc_imagekld(savename, sdir, image1, model2, imformat1)
%           kld = pdfbcalc_imagekld(savename, sdir, image1, image2, imformat1, 
%                       imformat2)
% Inputs:   model1      - first Hidden Markov Tree Model
%           model2      - second Hidden Markov Tree Model
%           image1      - first image file name
%           image2      - second image file name
%           imformat1   - format of the first image file
%           imformat2   - format of the second image file
%           savename    - filename to save the model of image1
%                       - set to '' if no save desired
%           sdir        - full pathname to save the model 1 (also set to ''
%                           if savename == '')
% Output:   kld         - the Kullback Liebler distance between the trees
%           kld2        - KLD estimation using Monte Carlo method

%function [kld, kld2] = pdfbcalc_imagekld(savename, sdir, model1, model2, ...
%    imf1, imf2)
function [kld, kld2] = pdfbcalc_imagekld(savename, sdir, model1, model2, ...
    imf1, imf2)

% initialize the kld
kld = 0;
kld2 = 0;

if nargin == 6
    % this case is when the images are provided but not the models
    image1 = model1;
    image2 = model2;
    
    % train the HMT models first
    [model1, dummy] = pdfbtrainimagethmt(image1, imf1, '', 0.01);
    [model2, dummy] = pdfbtrainimagethmt(image2, imf2, '', 0.01);

elseif nargin == 5
    % this case is when we have one model and one image, need to 
    % train a second model using the image provided
    image1 = model1;
    
    % train the HMT model
    [model1, dummy] = pdfbtrainimagethmt(image1, imf1, '', 0.01);
    
    %there is also the case for two models and no image when nargin==3
    %in that case, no training is needed
end;

if strcmp(savename, '') ~= 1
    file = sprintf('%s%s', sdir, savename);
    save(file,'model1');
end;

N = 60;
nlevel = model1{1}.nlevels;

for k = 1:nlevel
    levndir(k) = log2(length(model1{1}.stdv{k}));
end;

% treat each tree as independent and using chain rule of KLD for
% independent variables, simply add up the distances
for index = 1:length(model1)
    minkld = 10000;
    dbmodels = pdfbcreate_equiv_models(model1{index});
    for mmm = 1:length(dbmodels)
        tkld = pdfbcalc_KLD(nlevel, levndir, model2{index}, dbmodels{mmm});
        if tkld < minkld
            minkld = tkld;
        end;
    end;
    kld = kld + minkld;
end;

% Also apply the Monte Carlo method to verify the KLD estimation
for index = 1:length(model1)
    kld2 = kld2 + pdfbest_KLD(nlevel, levndir ,model2{index}, ...
        model1{index}, N); 
end;

