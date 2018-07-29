function [W phi]=train_rbf(X,Y,Xc,k_i,basisfunction)
%trains a radial basis function
%X is a N_p by N_dim matrix of training data
%Y is a N_p by N_dim matrix of training data
%Xc is a N_r by N_dim matrix of rbf centres
%basisfunction may be 'gaussian' or 'polyharmonicspline'
%k_i is a prescaler for 'gaussian' rbf and function order for
%'polyharmonicspline'. See k_i(i)=0 for constant bias

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

if nargin<4
    k_i=1;
end

if nargin<5
    basisfunction='gaussian';
end

N_r=size(Xc,1);%number of centres

W=zeros(N_r,1);%weight matrix
[z phi]=sim_rbf(Xc,X,W,k_i,basisfunction);%simulate rbf
A=pinv(phi'*phi)*phi';%do inverse
W=A*Y;%find weights