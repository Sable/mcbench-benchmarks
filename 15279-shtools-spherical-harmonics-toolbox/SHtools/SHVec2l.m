function l = SHVec2l(vec)

% l = SHVec2l(vec)
%
% For a given vector of real spherical harmonic coefficient compute
% it's maximum degree l and output an error if the input is not valid.

n=length(vec);
l=SHn2lm(n);

if SHl2n(l) ~= n
    error('invalid usage: not a valid spherical harmonic coefficient vector');
end
