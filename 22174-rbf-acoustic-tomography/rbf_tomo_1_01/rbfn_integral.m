function [Y_int Phi_int]=rbfn_integral(Xc,X1,X2,W,k_i,basisfunction)
%calculates a line integral between X1 [x y] and X2 for a radial basis
%function with center Xc and prescaler k_i
%basis function may be 'gaussian' or 'polyharmonicspline'
%see rbf_integral for more

%    Copyright Travis Wiens 2008
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%    If you would like to request that this software be licensed under a less
%    restrictive license (i.e. for commercial closed-source use) please
%    contact Travis at travis.mlfx@nutaksas.com

if nargin<6
    basisfunction='gaussian';
end


Phi_int=rbf_integral(Xc,X1,X2,k_i,basisfunction);

Y_int=Phi_int*W;
