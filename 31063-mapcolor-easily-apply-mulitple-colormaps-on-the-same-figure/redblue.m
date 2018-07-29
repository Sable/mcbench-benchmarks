function J = redblue(m,whiteloc)
% Usage: J=redblue([m],[whiteloc])
% redblue: A colormap from red to white to blue. Optionally specify the 
% colormap size in "m" and the normalized location of the white point in 
% "whiteloc", with 0 being the minimum and 1 being the maximum. 
%
%   Example:
%      load clown
%      imagesc(X);
%      colormap redblue

% Written 17 July 2009 by Douglas H. Kelley, dhk [at] dougandneely.com.

whitelocdefault=0.5;

if ~exist('m','var') || isempty(m)
   m = size(get(gcf,'colormap'),1);
end
if ~exist('whiteloc','var') || isempty(whiteloc)
    whiteloc=whitelocdefault;
end

if floor(whiteloc*m)==0
    J=[ ones(m,1) linspace(1,0,m)' linspace(1,0,m)' ];
elseif floor(whiteloc*m)==m
    J=[ linspace(0,1,m)' linspace(0,1,m)' ones(m,1)];
else
    J=[ [linspace(0,1,floor(whiteloc*m))'; ones(m-floor(whiteloc*m),1)]...
        [linspace(0,1,floor(whiteloc*m))'; linspace(1,0,m-floor(whiteloc*m))']...
        [ones(floor(whiteloc*m),1); linspace(1,0,m-floor(whiteloc*m))'] ];
end

