function [class,score,scores] = parzenPNNclassify(net,X,nonlin)
% PARZENPNNCLASSIFY  Classifies a vector x given a parzenPNN network.
%
%  This funcion uses a Parzen PNN (Probabilistic Neural Network) to
% classify a given vector x. Also the scores of the vector are given to
% allow to the user to manipulate it and compute confidences.
%
%  Parameters
%  ----------
% IN:
%  net      = The parzen PNN.
%  X        = The matrix containing column vectors that must be classified.
%  nonlin   =  The nonlinearity funciton or the sigma value for the default
%             one. (def=@(u)(exp((u-1)./sigma.^2))) (def sigma=2)
% OUT:
%  class    = The class of the vector.
%  score    = The score of the selected class.
%  scores   = The scores obtained for each class.
%
%  Pre
%  ---
% -  The input network must be a valid parzenPNN structure.
% -  The vector x must have the same number of elements as the
%   number of columns of the samples matrix in the network.
%
%  Post
%  ----
% -  Only a class is returned.
% -  A score is returned in the vector scores for each class.
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
% % Selecting a set of points:
% f=figure; imshow(img); X=getpoints; close(f);
% % Classify the points:
% class = parzenPNNclassify(net,X);
% % Plotting:
% figure; imshow(img); hold on;
% plotpoints(sa,'r.');
% plotpoints(sb,'b.');
% plotpoints(X(:,find(class=='a')),'ro');
% plotpoints(X(:,find(class=='b')),'bo');
% % Generating the whole grid:
% [X,Y] = meshgrid(1:100,1:100);
% X = [X(:),Y(:)]';
% % Classification of all points:
% [class,score] = parzenPNNclassify(net,X);
% class = reshape(class,[100,100]);
% score = reshape(score,[100,100]);
% % Creating the binary image:
% BW = class=='a';
% % Creating the separating function:
% sep = score.*BW-score.*(~BW);
% % Plotting:
% figure; imshow(BW);
% figure; surf(sep);
%
%  See also
%  --------
% parzenPNNlearn, parzenPNNimprove

% Check params:
if nargin<2 || size(net.ws,1)~=size(X,1)
    error('A valid parzenPNN and a vector with the same number of values must be provided!');
end
if nargin<3
    % A nonlinearity with default sigma:
    nonlin = @(u)(exp((u-1)./4));
elseif ~isa(nonlin,'function_handle')
    % Using nonlin as the sigma value:
    sigma = nonlin;
    nonlin = @(u)(exp((u-1)./sigma.^2));
end

% Centering the data:
X = X - repmat(net.center,[1,size(X,2)]);

% Compute the activation values for the first nurons layer:
activations = X'*net.ws;

% Using the nonlinearity function:
activations = nonlin(activations);

% Generating the scores:
nc = numel(net.classes);
nx = size(X,2);
scores = zeros(nx,nc);
for i=1:nc
    % Getting the activation values for this class and summing up:
    scores(:,i) = sum(activations(:,net.classInds{i}),2);
end

% Selecting the winning class:
class = repmat(net.classes(1),[1,nx]);
score = zeros(1,nx);
for j=1:nx
    % Getting the best choice:
    [s,pos] = max(scores(j,:));
    % Saving the values:
    score(j) = s;
    class(j) = net.classes(pos);
end
