function som = SOMSimple(nfeatures, ndim, nepochs, ntrainingvectors, eta0, etadecay, sgm0, sgmdecay, showMode)
%SOMSimple Simple demonstration of a Self-Organizing Map that was proposed by Kohonen.
%   sommap = SOMSimple(nfeatures, ndim, nepochs, ntrainingvectors, eta0, neta, sgm0, nsgm, showMode) 
%   trains a self-organizing map with the following parameters
%       nfeatures        - dimension size of the training feature vectors
%       ndim             - width of a square SOM map
%       nepochs          - number of epochs used for training
%       ntrainingvectors - number of training vectors that are randomly generated
%       eta0             - initial learning rate
%       etadecay         - exponential decay rate of the learning rate
%       sgm0             - initial variance of a Gaussian function that
%                          is used to determine the neighbours of the best 
%                          matching unit (BMU)
%       sgmdecay         - exponential decay rate of the Gaussian variance 
%       showMode         - 0: do not show output, 
%                          1: show the initially randomly generated SOM map 
%                             and the trained SOM map,
%                          2: show the trained SOM map after each update
%
%   For example: A demonstration of an SOM map that is trained by RGB values
%           
%       som = SOMSimple(3,60,10,100,0.1,0.05,20,0.05,2);
%       % It uses:
%       %   3    : dimensions for training vectors, such as RGB values
%       %   60x60: neurons
%       %   10   : epochs
%       %   100  : training vectors
%       %   0.1  : initial learning rate
%       %   0.05 : exponential decay rate of the learning rate
%       %   20   : initial Gaussian variance
%       %   0.05 : exponential decay rate of the Gaussian variance
%       %   2    : Display the som map after every update

nrows = ndim;
ncols = ndim;

som = rand(nrows,ncols,nfeatures);

if showMode >= 1
    fig = figure;
    displaySOMmap(fig, 1, 'Randomly initialized SOM', som, nfeatures);
end

% Generate random training data
trainingData = rand(ntrainingvectors,nfeatures);

% Generate coordinate system
[x y] = meshgrid(1:ncols,1:nrows);

for t = 1:nepochs    
    % Compute the learning rate for the current epoch
    eta = eta0 * exp(-t*etadecay);        

    % Compute the variance of the Gaussian (Neighbourhood) function for the ucrrent epoch
    sgm = sgm0 * exp(-t*sgmdecay);
    
    % Consider the width of the Gaussian function as 3 sigma
    width = ceil(sgm*3);        
    
    for ntraining = 1:ntrainingvectors
        % Get current training vector
        trainingVector = trainingData(ntraining,:);
                
        % Compute the Euclidean distance between the training vector and
        % each neuron in the SOM map
        dist = getEuclideanDistance(trainingVector, som, nrows, ncols, nfeatures);
        
        % Find the best matching unit (bmu)
        [~, bmuindex] = min(dist);
        
        % transform the bmu index into 2D
        [bmurow bmucol] = ind2sub([nrows ncols],bmuindex);        
                
        % Generate a Gaussian function centered on the location of the bmu
        g = exp(-(((x - bmucol).^2) + ((y - bmurow).^2)) / (2*sgm*sgm));
                        
        % Determine the boundary of the local neighbourhood
        fromrow = max(1,bmurow - width);
        torow   = min(bmurow + width,nrows);
        fromcol = max(1,bmucol - width);
        tocol   = min(bmucol + width,ncols);

        % Get the neighbouring neurons and determine the size of the neighbourhood
        neighbourNeurons = som(fromrow:torow,fromcol:tocol,:);
        sz = size(neighbourNeurons);
        
        % Transform the training vector and the Gaussian function into 
        % multi-dimensional to facilitate the computation of the neuron weights update
        T = reshape(repmat(trainingVector,sz(1)*sz(2),1),sz(1),sz(2),nfeatures);                   
        G = repmat(g(fromrow:torow,fromcol:tocol),[1 1 nfeatures]);
        
        % Update the weights of the neurons that are in the neighbourhood of the bmu
        neighbourNeurons = neighbourNeurons + eta .* G .* (T - neighbourNeurons);

        % Put the new weights of the BMU neighbouring neurons back to the
        % entire SOM map
        som(fromrow:torow,fromcol:tocol,:) = neighbourNeurons;

        if showMode == 2
            displaySOMmap(fig, 2, ['Epoch: ',num2str(t),'/',num2str(nepochs),', Training Vector: ',num2str(ntraining),'/',num2str(ntrainingvectors)], som, nfeatures);
        end        
    end
end

if showMode == 1
    displaySOMmap(fig, 2, 'Trained SOM', som, nfeatures);
end

function ed = getEuclideanDistance(trainingVector, sommap, nrows, ncols, nfeatures)

% Transform the 3D representation of neurons into 2D
neuronList = reshape(sommap,nrows*ncols,nfeatures);               

% Initialize Euclidean Distance
ed = 0;
for n = 1:size(neuronList,2)
    ed = ed + (trainingVector(n)-neuronList(:,n)).^2;
end
ed = sqrt(ed);

function displaySOMmap(fig, nsubplot, description, sommap, nfeatures)
% Display given SOM map

figure(fig);
subplot(1,2,nsubplot);
if nfeatures >= 3
    imagesc(sommap(:,:,1:3));
else
    imagesc(sommap(:,:,1));
end
axis off;axis square;
title(description);


