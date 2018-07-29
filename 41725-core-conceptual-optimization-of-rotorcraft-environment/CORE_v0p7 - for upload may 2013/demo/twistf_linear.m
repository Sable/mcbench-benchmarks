function thetafactor = twistf(r)
% As a function of non-dimensional radius location r (0-1), the twist
% function returns thetafactor, which, when multiplied by the tip twist,
% gives the local twist at r. Therefore, twistf(1) should normally be 1,
% and twistf(0) should be 0.
% remember that positive twist corresponds to blade washin.
% This code should be vectorized for m x n r.

thetafactor = r;

end