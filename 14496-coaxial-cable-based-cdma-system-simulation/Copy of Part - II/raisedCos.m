function TF = raisedCos (f,Tb,r)
% Raised Cosine Filter
% f = Frequency Matrix
% Tb = Bit Period
% r = Rolloff Factor

W0 = 1/(2*Tb);
W = (r+1)*W0;
x = abs(f)*(1/(W-W0));
x = x + ((W - 2*W0)/(W-W0))*ones(size(x));
TF = cos((pi/4)*x).^2;
xx = find(abs(f) < (2*W0 - W));
for ll = xx, TF(ll) = 1;end
xx = find(abs(f) > W);
for ll = xx, TF(ll) = 0;end