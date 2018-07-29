%% Gets frame by color distance
% vF: input frame (r, g, b)
% rC: reference color
%  d: l2 distance threshold squared
% rF: return frame binary
function [xc, yc, rF] = FrameByColorDistance (vF, rC, d)
M = size(vF, 1);
N = size(vF, 2);
A = zeros(M, N, 2);
for k = 1:2
    A(:, :, k) = rC(k);
end
B = (A - vF(:,:,1:2)).^2;
rF = sum(B, 3) < d;
rF = bwlabel(rF);
[r, c, v] = find(rF);
vMax = max(v);
nV = 0;
V  = 1;
for vi = 1:vMax
    lVi = length(find(v == vi));
    if lVi > nV
        nV = lVi;
        V = vi;
    end
end
rF = rF == V;
[r, c, ] = find(rF);
xc = mean(r); yc = mean(c);