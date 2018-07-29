function map = lbmap(n,scheme)
%LBMAP Returns specified Light-Bertlein colormap.
%
%   LBMAP(N,SCHEME) returns an Nx3 colormap. SCHEME can be one of the
%   following strings:
%
%       'Blue'       Single-hue progression to purlish-blue (default)
%       'BlueGray'   Diverging progression from blue to gray
%       'BrownBlue'  Orange-white-purple diverging scheme
%       'RedBlue'    Modified spectral scheme
%
%   If N is not specified, the size of the colormap is determined by the
%   current figure. If no figure exists, MATLAB creates one.
%
%Example 1: 7-color single-hue blue (default)
%   load penny
%   imagesc(P)
%   colormap(lbmap(7))
%   colorbar
%
%Example 2: 11-color modified spectrum
%   load penny
%   imagesc(P)
%   colormap(lbmap(11,'RedBlue'))
%   colorbar
%
%   See also HSV, GRAY, HOT, BONE, COPPER, PINK, FLAG, COLORMAP, RGBPLOT.

% Reference:
% A. Light & P.J. Bartlein, "The End of the Rainbow? Color Schemes for
% Improved Data Graphics," Eos,Vol. 85, No. 40, 5 October 2004.
% http://geography.uoregon.edu/datagraphics/EOS/Light&Bartlein_EOS2004.pdf

% Copyright 2007-2010 The MathWorks, Inc.

%defensive programming
error(nargchk(0,2,nargin))
error(nargoutchk(0,1,nargout))

%defaults
if nargin<2
  scheme = 'Blue';
end
if nargin<1
  n = size(get(gcf,'colormap'),1);
end

%valid schemes
switch lower(scheme)
  case 'blue'
    baseMap = BlueMap;
  case 'bluegray'
    baseMap = BlueGrayMap;
  case 'brownblue'
    baseMap = BrownBlueMap;
  case 'redblue'
    baseMap = RedBlueMap;
  otherwise
    error(['Invalid scheme ' scheme])
end
idx1 = linspace(0,1,size(baseMap,1));
idx2 = linspace(0,1,n);
map = interp1(idx1,baseMap,idx2);

function baseMap = BlueMap
baseMap = [243 246 248;
           224 232 240;
           171 209 236;
           115 180 224;
            35 157 213;
             0 142 205;
             0 122 192]/255;

function baseMap = BlueGrayMap
%DivergingBlueGray
baseMap = [  0 170 227;
            53 196 238;
           133 212 234;
           190 230 242;
           217 224 230;
           146 161 170;
           109 122 129;
            65  79  81]/255;

function baseMap = BrownBlueMap
baseMap = [144 100  44;
           187 120  54;
           225 146  65;
           248 184 139;
           244 218 200;
           241 244 245;
           207 226 240;
           160 190 225;
           109 153 206;
            70  99 174;
            24  79 162]/255;

function baseMap = RedBlueMap
baseMap = [175  53  71;
           216  82  88;
           239 133 122;
           245 177 139;
           249 216 168;
           242 238 197;
           216 236 241;
           154 217 238;
            68 199 239;
             0 170 226;
             0 116 188]/255;
