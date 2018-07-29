%NEWJOR Create an Jordan backpropagation network.
%
%  Syntax
%
%    net = newjor(P,T,[S1...S(N-l)],{TF1...TFN},BTF,BLF,PF,IPF,OPF,DDF)
%
%  Description
%    
%     NET = NEWJOR(P,T,[S1...SNl],{TF1...TFN},BTF,BLF,PF,IPF,OPF,DDF) takes,
%      P  - RxQ1 matrix of Q1 representative R-element input vectors.
%      T  - SNxQ2 matrix of Q2 representative SN-element target vectors.
%      Si  - Sizes of N-1 hidden layers, S1 to S(N-1), default = [].
%            (Output layer size SN is determined from T.)
%      TFi - Transfer function of ith layer. Default is 'tansig' for
%            hidden layers, and 'purelin' for output layer.
%      BTF - Backprop network training function, default = 'traingdx'.
%      BLF - Backprop weight/bias learning function, default = 'learngdm'.
%      PF  - Performance function, default = 'mse'.
%      IPF - Row cell array of input processing functions.
%            Default is {'fixunknowns','removeconstantrows','mapminmax'}.
%      OPF - Row cell array of output processing functions.
%            Default is {'removeconstantrows','mapminmax'}.
%      DDF - Data division function, default = 'dividerand';
%    and returns an N-layer Jordan network.
%
%    The training function BTF can be any of the backprop training
%    functions such as TRAINGD, TRAINGDM, TRAINGDA, TRAINGDX, etc.
%
%    *WARNING*: Algorithms which take large step sizes, such as TRAINLM,
%    and TRAINRP, etc., are not recommended for Jordan networks.  Because
%    of the delays in Jordan networks the gradient of performance used
%    by these algorithms is only approximated making learning difficult
%    for large step algorithms.
%
%    The learning function BLF can be either of the backpropagation
%    learning functions such as LEARNGD, or LEARNGDM.
%
%    The performance function can be any of the differentiable performance
%    functions such as MSE or MSEREG.


function net = newjor(varargin)

% Arnav Goel, 11-06-12
% Copyrights 2012 IEEE Student Branch BITS Goa
% $Revision 0.0.3 $Date 21-11-12

%This portion of the code refers to error declaration of the code inorder
%to make sure that the no of the arguments and the nature of the arguments
%is compatible to the NNT ver > 5.0 for the jordan_p1

if nargin < 1, error('NNET:Arguments','Not enough input arguments'),end

v1 = varargin{1};
if isa(v1,'cell'), v1 = cell2mat(v1); end
v2 = varargin{2};
if nargin > 2, v3 = varargin{3}; end

if (nargin<= 6) && (size(v1,2)==2) && (~iscell(v2)) && (size(v2,1)==1) && ((nargin<3)||iscell(v3))
  nntobsu(mfilename,['See help for ' upper(mfilename) ' to update calls to the new argument list.']);
  net = jordan_p0(varargin{:});
else
  net = jordan_p1(varargin{:});
end

%==========================================================

%this portion of the code is the main part with designing the Architecture,
%Simulation, Adaptation, Training & Initialization

function net = jordan_p1(p,t,s,tf,btf,blf,pf,ipf,tpf,ddf)
if nargin < 1, error('NNET:Arguments','Not enough arguments.'),end

% Defaults
if (nargin < 3), s = []; end
if (nargin < 4), tf = {}; end
if (nargin < 5), btf = 'traingdx'; end
if (nargin < 6), blf = 'learngdm'; end
if (nargin < 7), pf = 'mse'; end
if (nargin < 8), ipf = {'fixunknowns','removeconstantrows','mapminmax'}; end
if (nargin < 9), tpf = {'removeconstantrows','mapminmax'}; end
if (nargin < 10), ddf = 'dividerand'; end

% Format
if isa(p,'cell'), p = cell2mat(p); end
if isa(t,'cell'), t = cell2mat(t); end

% Error checking
if (~isa(p,'double')) || ~isreal(p)
  error('NNET:Arguments','Inputs are not a matrix or cell array with a single matrix.')
end
if isa(s,'cell')
  if (size(s,1) ~= 1)
    error('NNET:Arguments','Layer sizes is not a row vector of positive integers.')
  end
  for i=1:length(s)
    si = s{i};
    if ~isa(si,'double') || ~isreal(si) || any(size(si) ~= 1) || any(si<1) || any(round(si) ~= si)
      error('NNET:Arguments','Layer sizes is not a row vector of positive integers.')
    end
  end
  s = cell2mat(s);
end
if (~isa(s,'double')) || ~isreal(s) || (size(s,1) ~= 1) || any(s<1) || any(round(s) ~= s)
  error('NNET:Arguments','Layer sizes is not a row vector of positive integers.')
end

% Architecture

Nl = length(s)+1; %N-1 hidden + 1 output to decide the no of layers for the network
net = network(1,Nl); % 1 input N-1 HL 1 output layer network
net.biasConnect = ones(Nl,1); 
net.inputConnect(1,1) = 1;
[j,i] = meshgrid(1:Nl,1:Nl);
net.layerConnect = (j == (i-1)) | ((j-1) == i); % here LC(1,2) = 1 and LC(2,1) = 1
net.outputConnect(Nl) = 1; 

% Simulation
net.inputs{1}.exampleInput = p;
net.inputs{1}.processFcns = ipf; %pre-processing conditions for less arguments in the newjor

for i=1:Nl
    if (i<Nl)
        net.layerWeights{i,i+1}.delays = 1;
    else
       net.layerWeights{Nl,Nl}.delays = 1 ;
    end
    
  if (i<Nl), net.layers{i}.size = s(i); end
  if (length(tf) < i) || all(isnan(tf{i}))
    if (i<Nl)
      net.layers{i}.transferFcn = 'tansig';
    else
      net.layers{i}.transferFcn = 'purelin';
    end
  else
    net.layers{i}.transferFcn = tf{i};
  end
end
net.outputs{Nl}.exampleOutput = t;
net.outputs{Nl}.processFcns = tpf;

% Adaption
net.adaptfcn = 'trains';
net.inputWeights{1,1}.learnFcn = blf;
for i=1:Nl
  net.biases{i}.learnFcn = blf;
  net.layerWeights{i,:}.learnFcn = blf;
end

% Training
net.trainfcn = btf;
net.dividefcn = ddf;
net.performFcn = pf;
net.gradientFcn = feval(btf,'gdefaults',0);

% Initialization
net.initFcn = 'initlay';
for i=1:Nl
  net.layers{i}.initFcn = 'initnw';
end
net = init(net);

% Plots
net.plotFcns = {'plotperform','plottrainstate'};

%===========================================

%this is similar to the above function written for the lower end MATLAB
%version of NNT tooblox

function net = jordan_p0(pr,s,tf,btf,blf,pf)
% Backward compatible to NNT 5.0

if nargin < 1, error('NNET:Arguments','Not enough arguments.'),end

% Defaults
Nl = length(s);
if nargin < 3, tf = {'tansig'}; tf = tf(ones(1,Nl)); end
if nargin < 4, btf = 'traingdx'; end
if nargin < 5, blf = 'learngdm'; end
if nargin < 6, pf = 'mse'; end

% Error checking
if (~isa(pr,'double')) || ~isreal(pr) || (size(pr,2) ~= 2)
  error('NNET:Arguments','Input ranges is not a two column matrix.')
end
if any(pr(:,1) > pr(:,2))
  error('NNET:Arguments','Input ranges has values in the second column larger in the values in the same row of the first column.')
end
if isa(s,'cell')
  if (size(s,1) ~= 1)
    error('NNET:Arguments','Layer sizes is not a row vector of positive integers.')
  end
  for i=1:length(s)
    si = s{i};
    if ~isa(si,'double') || ~isreal(si) || any(size(si) ~= 1) || any(si<1) || any(round(si) ~= si)
      error('NNET:Arguments','Layer sizes is not a row vector of positive integers.')
    end
  end
  s = cell2mat(s);
end
if (~isa(s,'double')) || ~isreal(s) || (size(s,1) ~= 1) || any(s<1) || any(round(s) ~= s)
  error('NNET:Arguments','Layer sizes is not a row vector of positive integers.')
end

% Architecture
net = network(1,Nl);
net.biasConnect = ones(Nl,1);
net.inputConnect(1,1) = 1;
[j,i] = meshgrid(1:Nl,1:Nl);
net.layerConnect = (j == (i-1)) | ((j-1) == i);
net.outputConnect(Nl) = 1;

% Simulation
net.inputs{1}.range = pr;
for i=1:Nl
  if (i<Nl)
        net.layerWeights{i,i+1}.delays = [1];
    else
       net.layerWeights{Nl,Nl}.delays = [1] ;
    end
  net.layers{i}.size = s(i);
  net.layers{i}.transferFcn = tf{i};
end

% Performance
net.performFcn = pf;

% Adaption
net.adaptfcn = 'trains';
net.inputWeights{1,1}.learnFcn = blf;
for i=1:Nl
  net.biases{i}.learnFcn = blf;
  net.layerWeights{i,:}.learnFcn = blf;
end

% Training
net.trainfcn = btf;
net.gradientFcn = feval(btf,'gdefaults',0);

% Initialization
net.initFcn = 'initlay';
for i=1:Nl
  net.layers{i}.initFcn = 'initnw';
end
net = init(net);

% Plots
net.plotFcns = {'plotperform','plottrainstate'};


