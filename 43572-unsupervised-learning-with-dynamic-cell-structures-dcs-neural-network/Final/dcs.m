% Unsupervised Learning of MD manifold using:
% Dynamic Cell Structure - Growing Cell Structures (DCS)-(GCS) ANN.

% REFERENCES
% [1] Bruske J., Sommer G., "Dynamic Cell Structure Learns Perfectly Topology Preserving Map",
%                                                Neural Computation, vol. 7, Issue 4, July 1995, pp. 845-865.    

clc;
clear; close all;
colordef black;
NumOfEpochs   = 500;
NumOfSamples = 1000;
input_dims         = 2;
Mi                        = input_dims;
max_nodes        = 200;
eb                        = 0.05;
en                        = 0.005;
Theta                   = 0.001;  % Lateral Connections Deletion Threshold.
% alpha               = Theta^(1/NumOfSamples); % Connections Forgetting Constant.
alpha                   = 0.9992;
beta                     = 0.95;   % Outer Loop Error Decrease Constant.
sigma                  = 15;     % Activation function y(x) receptive field width.

% Select one of the following manifolds to learn with DCS:
% load local_circular_2d1.mat
% load local_circular_2d2.mat;
% load local_sphere_shell.mat;
% load local_torus.mat;
     load local_uniform_2d.mat
% load local_quartersphere.mat;
 % load multi_manifold_3d.mat;

NumOfNodes = 2;
RMSE = zeros(1,NumOfEpochs);
Current_RMSE = [];
Epoch = [];
Cur_NumOfNodes = [];

%% DCS Initialization.
a = Data(:,1);
b = Data(:,2);
nodes = [a b];

% Initial Lateral Connections matrix C.
C = [0  1;
        1  0;];
     
% Initial Error Vector.
error = [0 0];

%% Open the demo figure.
h = figure('Name','Dynamic Cell Structure Neural Network Demo');
set(h,'Position',[200 100 1200 600]);

%% Outer loop.
for kk=1:NumOfEpochs

    % Get the next block of input Training Vectors.
    b = (kk-1)*NumOfSamples+1:1:kk*NumOfSamples;
    In = Data(:,b);

% Inner loop. Each completed cycle corresponds to a training epoch.   
for ii=1:NumOfSamples

%% Find the 2 closest nodes to the incoming data sample.
[bmu secbmu distances] = findTwoClosest(In(:,ii),nodes);

% Node Activation Function is a Gaussian:
y = exp(-distances.^2/sigma);

%% Competitive Hebbian Learning (CHL) Rule.
% 1st Approach (use eq. (2.2) of ref. [1])
    C = competitiveHebb1(C,bmu,secbmu,Theta,alpha);

% 2nd approach (use eq. (2.4) of ref. [1])
% C = competitiveHebb2(C,bmu,secbmu,y,Theta,alpha);

%% Advantageous connections update scheme for on-line learning applications.
nodes = restrictedKohonen(In(:,ii),C,nodes,bmu,eb,en);

% Update the resource value of the best matching unit (bmu).
error(bmu) = error(bmu) + distances(bmu)^2;

end % End of inner loop.

% Continuation of Outer loop.

%% Remove the Unconnected (dead) Nodes.
   [nodes, error, C] = removeUnconnected(nodes,error,C);

%% New Node Insertion Procedure
if size(nodes,2)<max_nodes  
    [nodes error C] = addNewNeuron(nodes,error,C);
end

%% Decrement all Neurons Resource Values.
 error = beta*error;

%% Plot Management.
NumOfNodes = size(nodes,2);
Cur_NumOfNodes = [Cur_NumOfNodes NumOfNodes];
if length(Cur_NumOfNodes)>100
    Cur_NumOfNodes = Cur_NumOfNodes(end-100:end);
end

RMSE(kk) = norm(error)/sqrt(NumOfNodes);
Current_RMSE = [Current_RMSE RMSE(kk)];
if length(Current_RMSE)>100
    Current_RMSE = Current_RMSE(end-100:end);
end

Epoch = [Epoch kk];
if length(Epoch)>100
    Epoch = Epoch(end-100:end);
end

% Plot the DCS structure.
subplot(1,2,1);
plotdcs(nodes,C,'n');
drawnow;

% Plot the RMS error history of the last 100 training epochs.
subplot(2,2,2);
plot(Epoch,Current_RMSE,'r.');
title('RMS Error');
if kk>100
     xlim([Epoch(1) Epoch(end)]);
end
xlabel('Training Epoch Number');
grid on;

% Plot the "current nodes number" in the DCS history for the last 100
% training epochs.
subplot(2,2,4);
plot(Epoch,Cur_NumOfNodes,'g.');
title('Number of Neural Units in the DCS Structure');
if kk>100
  xlim([Epoch(1) Epoch(end)]);
end
xlabel('Training Epoch Number');
grid on;

end
