%% initialize message for BP based kalman filter.
% author: Shuang Wang
% email: shw070@ucsd.edu
% Division of Biomedical Informatics, University of California, San Diego.
function [msg, varNode_x, factorNode_x, factorNode_y, belief] = initializeMessage(T, mu_0, V_0, d_x, y, B, V_W)
    total_edges = 3*T - 1;
    msg = cell(total_edges,1);
    varNode_x = cell(T, 1);
    belief = cell(T, 1);
    factorNode_x = cell(T, 1);
    factorNode_y = cell(T, 1);
    
    %% connect variable and facotr nodes with message edge ID.
    count = 1;
    for i = 1:T
        % for variable node
        varNode_x{i}.backwardNeighborMsgID = count; count = count + 1; % previous factor node
        if(i < T) % no forward neighbor for the last variable
            varNode_x{i}.forwardNeighborMsgID = count; count = count + 1; % future factor node
        end
        varNode_x{i}.lowerNeighborMsgID = count; count = count + 1; % observation y;
        % for factor node_x
        factorNode_x{i}.forwardNeighborMsgID = varNode_x{i}.backwardNeighborMsgID;
        if(i > 1) % no backward NeighborMsgID
            factorNode_x{i}.backwardNeighborMsgID = varNode_x{i-1}.forwardNeighborMsgID;
        end
        % for factor node_y
        factorNode_y{i}.upperNeighborMsgID = varNode_x{i}.lowerNeighborMsgID;
    end
    count = count - 1; % make sure count is correct.
    assert(count == total_edges, 'count mismatch');
    for i = 1:T
        assert(varNode_x{i}.backwardNeighborMsgID == factorNode_x{i}.forwardNeighborMsgID);
        assert(varNode_x{i}.lowerNeighborMsgID == factorNode_y{i}.upperNeighborMsgID);
        if(i < T)
            assert(varNode_x{i}.forwardNeighborMsgID == factorNode_x{i+1}.backwardNeighborMsgID);
        end
    end
    %% initialize message
    % factor node x_1 for prior of x1
    msg{factorNode_x{1}.forwardNeighborMsgID}.toVarNode.mu = mu_0;
    msg{factorNode_x{1}.forwardNeighborMsgID}.toVarNode.V = V_0;
    msg{factorNode_x{1}.forwardNeighborMsgID}.toVarNode.iV = [];
    msg{factorNode_x{1}.forwardNeighborMsgID}.toFactorNode.mu = [];
    msg{factorNode_x{1}.forwardNeighborMsgID}.toFactorNode.V = [];
    % factor node x_2 to x_T with zero mean and infinite std.
    for i = 2:T
        % forward message
        msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.mu = zeros(d_x, 1);
        msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.V  = eyeInf(d_x);
        msg{factorNode_x{i}.forwardNeighborMsgID}.toVarNode.iV  = [];
        msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.mu = zeros(d_x, 1);
        msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.V  = eyeInf(d_x);
        msg{factorNode_x{i}.forwardNeighborMsgID}.toFactorNode.iV  = [];
        % backward message
        msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.mu = zeros(d_x, 1);
        msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.V  = eyeInf(d_x);
        msg{factorNode_x{i}.backwardNeighborMsgID}.toFactorNode.iV  = [];
        msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.mu = zeros(d_x, 1);
        msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.V  = eyeInf(d_x);
        msg{factorNode_x{i}.backwardNeighborMsgID}.toVarNode.iV  = [];
    end
    % factor node y_1 to y_T.
    for i = 1:T
        msg{factorNode_y{i}.upperNeighborMsgID}.toVarNode.mu = B'/(B*B')*y(:,i); % this is B' * inv(B*B') * y;
        msg{factorNode_y{i}.upperNeighborMsgID}.toVarNode.V = [];  % the inverse matrix is singular;
        msg{factorNode_y{i}.upperNeighborMsgID}.toVarNode.iV = (B')/V_W*B; % we use precision to represent the distribution.
    end
end