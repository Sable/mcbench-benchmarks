function [f] = gdm(F1, F2, Func)
%
% GDM   Ground distance matrix between two signatures
%    [F] = GDM(F1, F2, FUNC) is the ground distance matrix between
%    two signatures whose feature vectors are given in F1 and F2.
%    FUNC is a function which computes the ground distance between
%    two feature vectors.
%
%    Example:
%    -------
%        f1 = [[100, 40, 22]; [211, 20, 2]; [32, 190, 150]; [2, 100, 100]];
%        f2 = [[0, 0, 0]; [50, 100, 80]; [255, 255, 255]];
%        ...
%        [f] = gdm(f1, f2, @gmf);
%        ...
%
%    This file and its content belong to Ulas Yilmaz.
%    You are welcome to use it for non-commercial purposes, such as
%    student projects, research and personal interest. However,
%    you are not allowed to use it for commercial purposes, without
%    an explicit written and signed license agreement with Ulas Yilmaz.
%    Berlin University of Technology, Germany 2006.
%    http://www.cv.tu-berlin.de/~ulas/RaRF
%

% number and length of feature vectors
[m a] = size(F1);
[n a] = size(F2);

% ground distance matrix
for i = 1:m
    for j = 1:n
        f(i, j) = Func(F1(i, 1:a), F2(j, 1:a));
    end
end

% gdm in column-vector form
f = f';
f = f(:);

end