function out = RandDir(N)

% Generate a random vector from the set {+/- e_1, +/- e_2,..., +/- e_N}
% where e_i is the ith basis vector. N should be an integer.

I = round(ceil(2*N*rand));

if rem(I,2) == 1
    sgn = -1;
else
    sgn = 1;
end
out = zeros(N,1);

out(ceil(I/2)) = sgn*1;

end