function net = parzenPNNlearn(samples,classification,center)
% PARZENPNNLEARN  Creates a Parzen probabilistic neural network
%
%  This funcion generates a Parzen PNN (Probabilistic Neural Network) from
% a list of classified samples. The samples are given in the format of a
% matrix containing a single sample per row. The returned structure is a
% Parzen PNN and must be used with the parzen PNN manipulation functions.
%
%  Parameters
%  ----------
% IN:
%  samples          = The set of samples.
%  classification   = The classification of the samples.
%  center           = Data must be centered? Here a boolean value selects
%                     autocentering or not, whilst a vector can define the
%                     selected center. (def=true)
% OUT:
%  net              = The parzen PNN.
%
%  Pre
%  ---
% -  The input samples must be passed as a row-samples matrix.
% -  The classification vector must have the same number of elements as the
%   number of columns of the samples matrix.
%
%  Post
%  ----
% -  The returned structure is a valid parzenPNN structure.
%
%  Examples
%  --------
% % A training set for the class 'a' and 'b':
% img=ones(100);
% f=figure; imshow(img); sa=getpoints; close(f);
% f=figure; imshow(img); sb=getpoints; close(f);
% % The samples matrix:
% S = [sa,sb];
% % The classification vector:
% C = [repmat('a',[1,size(sa,2)]),repmat('b',[1,size(sb,2)])];
% % Generating the network:
% net = parzenPNNlearn(S,C),
%
%  See also
%  --------
% parzenPNNclassify, parzenPNNimprove

% Check params:
if nargin<2 || size(samples,2)~=numel(classification)
    error('A samples matrix and a classification vector must be provided!');
end
if nargin<3 
    center=true; 
end

% Generating the center:
if isa(center,'logical')
    % Generating automatically the center:
    if center
        center = mean(samples,2);
    else
        center = zeros(size(samples,1),1);
    end
else
    % Checking the given mean:
    if ~vectCheckShape(center,[size(samples,1),1])
        error('The specified center is not a point of the samples space (wrong dimensionality)!');
    end
end

% Counting the classes and generating the classes vector:
classes = unique(classification);

% Centering the data:
samples = samples - repmat(center,[1,size(samples,2)]);

% Obtaining the normalization factors:
normvals = sqrt(sum(samples.^2));

% Normalizing:
samples = samples./repmat(normvals,[size(samples,1),1]);

% Creating the network structure:
net.ws = samples;
net.classes = classes;
net.center = center;

% Preparing the set of classification indexes:
nc = numel(classes);
net.classInds = cell(1,nc);
for i=1:nc
    % Finding the indexes for this class:
    net.classInds{i} = find(classification==classes(i));
end
