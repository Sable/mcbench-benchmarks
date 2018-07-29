function [net_Grad,OutputOffset] = NN_GradientFunction(net)
%NN_GRADIENTFUNCTION, Forms the network of the gradient of the input net
% 
% Syntax
%
%   [net_Grad,OutputOffset] = NN_GradientFunction(net)
%
% Description
% 
%   NN_GRADIENTFUNCTION, Forms the network of the gradient of the input
%   network. The initial network must be a single-layer, feed-forward,
%   network with linear, scalar output (see assumptions below). 
%     NET - trained neural network
%     NET_GRAD - Output network, simply a transform of the original
%     network
%     OUTPUTOFFSET - Final translation of gradient. 

% Example: 
% load house_dataset
% net = newff(houseInputs,houseTargets,20);
% net = train(net,houseInputs,houseTargets);
% [net_Grad,OutputOffset] = NN_GradientFunction(net);
% % For a set of points
% Gradient = sim(net_Grad,houseInputs)-repmat(OutputOffset,1,size(houseInputs,2));
% % For a single points
% Gradient = sim(net_Grad,houseInputs(:,1))-OutputOffset;

% Assumes that the network is constant, so if it's trained later, then
% this function will need to be called again. 

% Assumes that the network output is a scalar. Expansion to vector output
% would require a different structure but could be done.

% Assumes that the hidden layer activation function is tansig. Uses
% dtansig_0 which is a modification of tansig. Type 'open tansig' (or the
% activation function that you're using and then modify the
% 'apply_transfer' subroutine with the derivative. Resave with new name in 
% your working directory (or the toolbox, if you want it available for 
% other projects). Recommended convention 'dXXXXX_0.m'; 'dXXXXX.m' may be
% an obsolete functions. Should use smooth (first derivative continuous)
% activation functions. Replace dtansig_0 with new file name below. 

% Assumes that you understand that activation function is a much more
% appropriate name for the hidden layer function than transfer function.
% wikipedia.org/wiki/Transfer_function, .../wiki/Activation_function

%% The real work (really not that hard)
net_Grad=net;

% Increase the size of the example output to fit the gradient.
net_Grad.outputs{2}.exampleOutput=repmat(...
    net_Grad.outputs{2}.exampleOutput,...
    size(net_Grad.inputs{1}.exampleInput,1),1);

% Change the activation function to its derivative.
net_Grad.layers{1}.transferFcn='dtansig_0'; 
% Replace 'dtansig_0' with the function name of derivative of the current
% activation function.

% For the gradient, the derivative of constant terms is zero.
net_Grad.b{2}=zeros(size(net_Grad.inputs{1}.exampleInput,1),1);

% The output is scaled down to [-1,+1] and in this process the gradient
% needs to be recentered. What I don't get is why it doesn't need to be
% rescaled. I have verified this works, but it's always good to check a
% test case, if you want your code to work. See NN_DerivativeValidate.m for
% an example.
OutputOffset=(net_Grad.outputs{2}.processSettings{2}.xmax+...
    net_Grad.outputs{2}.processSettings{2}.xmin)/2;

Base_LW=net_Grad.LW{2,1}(1,:);% Initial hidden layer weights
for alley=1:size(net_Grad.inputs{1}.exampleInput,1); 
    %The weights for each element of the gradient as composed individually.
net_Grad.LW{2,1}(alley,:)=Base_LW.*...Hidden layer weights
    net_Grad.IW{1,1}(:,alley).'*... %Initial weight of input
    net_Grad.inputs{1}.processSettings{3}.yrange/...%these three lines 
    (net_Grad.inputs{1}.range(alley,2)-...% account for the scaling of the 
    net_Grad.inputs{1}.range(alley,1));% input to the [-1,+1] range
end

end
% 
% Example code for finding gradient for a set of points, TestPoints
% temp= sim(net_Grad,TestPoints)-repmat(OutputOffset,1,size(TestPoints,2));
% 
% Example code for finding activation function first and second derivative
% x_s   = sym('x_s');
% y_s   = 2/(1+exp(-2*x_s))-1;
% dy_s  = diff(y_s,x_s);
% ddy_s = diff(dy_s,x_s);
