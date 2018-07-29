function [x, fval] = emd(F1, F2, W1, W2, Func)
%
% EMD   Earth Mover's Distance between two signatures
%    [X, FVAL] = EMD(F1, F2, W1, W2, FUNC) is the Earth Mover's Distance
%    between two signatures S1 = {F1, W1} and S2 = {F2, W2}. F1 and F2
%    consists of feature vectors which describe S1 and S2, respectively.
%    Weights of these features are stored in W1 and W2. FUNC is a function
%    which computes the ground distance between two feature vectors.
%
%    Example:
%    -------
%        f1 = [[100, 40, 22]; [211, 20, 2]; [32, 190, 150]; [2, 100, 100]];
%        f2 = [[0, 0, 0]; [50, 100, 80]; [255, 255, 255]];
%        w1 = [0.4; 0.3; 0.2; 0.1];
%        w2 = [0.5; 0.3; 0.2];
%        ...
%        [x fval] = emd(f1, f2, w1, w2, @gdf);
%        ...
%
%    EMD is formalized as linear programming problem in which the flow that
%    minimizes an overall cost function subject to a set of constraints is
%    computed. This implementation is based on "The Earth Mover's Distance
%    as a Metric for Image Retrieval", Y. Rubner, C. Tomasi and L. Guibas,
%    International Journal of Computer Vision, 40(2), pp. 99-121, 2000.
%
%    The outcome of EMD is the flow (X) which minimizes the cost function
%    and the value (FVAL) of this flow.
%
%    This file and its content belong to Ulas Yilmaz.
%    You are welcome to use it for non-commercial purposes, such as
%    student projects, research and personal interest. However,
%    you are not allowed to use it for commercial purposes, without
%    an explicit written and signed license agreement with Ulas Yilmaz.
%    Berlin University of Technology, Germany 2006.
%    http://www.cv.tu-berlin.de/~ulas/RaRF
%

% ground distance matrix
f = gdm(F1, F2, Func);

% number of feature vectors
[m a] = size(F1);
[n a] = size(F2);

% inequality constraints
A1 = zeros(m, m * n);
A2 = zeros(n, m * n);
for i = 1:m
    for j = 1:n
        k = j + (i - 1) * n;
        A1(i, k) = 1;
        A2(j, k) = 1;
    end
end
A = [A1; A2];
b = [W1; W2];

% equality constraints
Aeq = ones(m + n, m * n);
beq = ones(m + n, 1) * min(sum(W1), sum(W2));

% lower bound
lb = zeros(1, m * n);

% linear programming
[x, fval] = linprog(f, A, b, Aeq, beq, lb);
fval = fval / sum(x);

end