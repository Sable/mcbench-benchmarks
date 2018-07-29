function [z phi]=sim_rbf(Xc,X,W,k_i,basisfunction)
%simulates a radial basis function
%Xc is a N_r by N_dim matrix of rbf centres
%X is a N_p by N_dim matrix of the points to simulate
%W is the weight vector
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

N_r=size(Xc,1);%number of rbf centres
N_p=size(X,1);%number of points

if numel(k_i)==1
    k_i=k_i*ones(N_r);
end

phi=zeros(N_p,N_r);%rbf outputs

for i=1:N_r
    if k_i(i)==0
        phi(:,i)=1;
    else
        r=sqrt(sum((repmat(Xc(i,:),N_p,1)-X(:,:)).^2,2));%distance from point Xc to X

        switch basisfunction
            case {'gaussian','Gaussian'}
                phi(:,i)=exp(-k_i(i).*r.^2);
            case {'phs','polyharmonicspline'}
                if r==0
                    phi(:,i)=0;
                else
                    if round(k_i(i)/2)==k_i(i)/2%even
                        phi(:,i)=r.^k_i(i).*log(r);
                        phi(r==0,i)=0;%avoid log(0)
                    else
                        phi(:,i)=r.^k_i(i);
                    end
                end
            otherwise
                error('unknown basis function')
        end
    end
end

z=phi*W;