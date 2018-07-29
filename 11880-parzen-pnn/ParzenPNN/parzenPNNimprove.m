function neto = parzenPNNimprove(net,samples,classification)
% PARZENPNNLEARN  Creates a Parzen probabilistic neural network
%
%  This funcion improves a Parzen PNN (Probabilistic Neural Network) from
% a list of classified samples. The samples are given in the format of a
% matrix containing a single sample per row. The returned structure is a
% Parzen PNN and must be used with the parzen PNN manipulation functions.
%
%  Parameters
%  ----------
% IN:
%  net              = The original network to be improved.
%  samples          = The set of samples.
%  classification   = The classification of the samples.
% OUT:
%  net              = The parzen PNN.
%
%  Pre
%  ---
% -  The given network must be a valid parzenPNN structure.
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
% net = parzenPNNlearn(S,C);
% % Other samples:
% f=figure; imshow(img); nsa=getpoints; close(f);
% f=figure; imshow(img); nsb=getpoints; close(f);
% % The samples matrix:
% nS = [nsa,nsb];
% % The classification vector:
% nC = [repmat('a',[1,size(nsa,2)]),repmat('b',[1,size(nsb,2)])];
% % Generating the network:
% inet = parzenPNNimprove(net,nS,nC);
% % Generating the whole grid:
% [X,Y] = meshgrid(1:100,1:100);
% X = [X(:),Y(:)]';
% % Classification of all points:
% [class,score] = parzenPNNclassify(net,X);
% class = reshape(class,[100,100]);
% score = reshape(score,[100,100]);
% [nclass,nscore] = parzenPNNclassify(inet,X);
% nclass = reshape(nclass,[100,100]);
% nscore = reshape(nscore,[100,100]);
% % Creating the binary image:
% BW = class=='a';
% nBW = nclass=='a';
% % Plotting:
% figure; imshow(BW);
% figure; imshow(nBW);
%
%  See also
%  --------
% parzenPNNlearn, parzenPNNclassify

% Check params:
if nargin<3 || size(samples,2)~=numel(classification)
    error('A parzenPNN, a samples matrix and a classification vector must be provided!');
end

% Centering the samples:
samples = samples - repmat(net.center,[1,size(samples,2)]);

% Obtaining the normalization factors:
normvals = sqrt(sum(samples.^2));

% Normalizing:
samples = samples./repmat(normvals,[size(samples,1),1]);

% Creating the network structure:
nos = size(net.ws,2);
net.ws = [net.ws,samples];

% Preparing the set of classification indexes:
nc = numel(net.classes);
for i=1:nc
    % Finding the indexes for this class:
    net.classInds{i} = [net.classInds{i},find(classification==net.classes(i))+nos];
end

% Saving:
neto = net;
