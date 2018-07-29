%% this is an implementation of kalman filter using belief propagation.
% author: Shuang Wang
% email: shw070@ucsd.edu
% Division of Biomedical Informatics, University of California, San Diego.

clear;
addpath(genpath('.'));
%%
% x_k = A x_t-1 + q; N(0, V_Q);
% y_k = B x_k + w; N(0, V_W);
% x_1 ~ N(mu_0, V_0);

%% generating fake data.
s = RandStream('mt19937ar','Seed',4);
RandStream.setGlobalStream(s);
T = 40;
x = zeros(2, T);
y = zeros(2, T);
d_y = size(y, 1);
d_x = size(x, 1);
mu_0 = [4; 4];
V_0 = [1, 0
       0, 1];
V_Q = [0.1,   0
         0, 0.3];
V_W = [0.05,   0
          0, 0.1];
A = [   1, 0.04
     0.02,    1];
B = [1, 0
     0, 1];

 x(:, 1) = mvnrnd(mu_0, V_0, 1)';
 y(:, 1) = B * x(:, 1) + mvnrnd([0, 0], V_W, 1)';
 for t = 2:T
     x(:, t) = A * x(:, t-1) + mvnrnd([0, 0], V_Q, 1)';
     y(:, t) = B * x(:, t) + mvnrnd([0, 0], V_W, 1)';
 end
 
[msg, varNode_x, factorNode_x, factorNode_y, belief] = initializeMessage(T, mu_0, V_0, d_x, y, B, V_W);
 
for bp_iter = 1:2*T
    %% variable node update
    for i = 1:T
        if (i < T)
            msg{varNode_x{i}.backwardNeighborMsgID}.toFactorNode ...
                = GaussianMultiply(msg{varNode_x{i}.forwardNeighborMsgID}.toVarNode,...
                msg{varNode_x{i}.lowerNeighborMsgID}.toVarNode);
            
            msg{varNode_x{i}.forwardNeighborMsgID}.toFactorNode ...
                = GaussianMultiply(msg{varNode_x{i}.backwardNeighborMsgID}.toVarNode,...
                msg{varNode_x{i}.lowerNeighborMsgID}.toVarNode);
        else
            msg{varNode_x{i}.backwardNeighborMsgID}.toFactorNode = msg{varNode_x{i}.lowerNeighborMsgID}.toVarNode;
        end
    end
    
    %% factor node update
    for i = 2:T
        msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.mu ...
            = A * msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.mu;
        if(~isempty(msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.V))
            msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.V ...
                = A * msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.V * (A') + V_Q;
            msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.iV = [];
        else
            msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.V = [];
            tmp_iAtiviA = (A')\msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.iV/A;
            msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.iV ...
                = tmp_iAtiviA -(eye(d_x) + tmp_iAtiviA*V_Q)\tmp_iAtiviA*V_Q*tmp_iAtiviA;
        end
        msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.mu ...
            = A\msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.mu;
        if(~isempty(msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.V))
            msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.iV = [];
            msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.V ...
                = A\(msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.V + V_Q)/(A');
        else
            tmp_iv = msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.iV;
            msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.V = [];
            msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.iV ...
                = (A')*(tmp_iv -(eye(d_x) + tmp_iv*V_Q)\tmp_iv*V_Q*tmp_iv)*A;
        end
    end
end % bp_iter

%% update belief
for i = 1:T
    belief{i} = GaussianMultiply(msg{varNode_x{i}.backwardNeighborMsgID}.toFactorNode,...
                msg{varNode_x{i}.backwardNeighborMsgID}.toVarNode);
    mu_tmp_sm(:,i) = belief{i}.mu;
end
%%
figure(1); clf;
plot(x(1, :), x(2, :), '.'); hold on;
plot(y(1, :), y(2, :), 'ro'); hold on;
plot(mu_tmp_sm(1, :), mu_tmp_sm(2, :), 'g*'); hold on;
h = legend('Hidden state', 'observation', 'kalman smoother');
set(h, 'box', 'off', 'location', 'best');
fprintf('SAD:x_z = %f\n', sum(abs((y(:) - x(:)))));
fprintf('SAD:kf_sm_z = %f\n', sum(abs((mu_tmp_sm(:) - x(:)))));