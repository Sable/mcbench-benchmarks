function [zeta_u zeta_v]=zeta_uv(Xc,X,k_i,basisfunction)
%calculates zeta_u and zeta_v matrices such that we can calculated the velocities
%u and v from the rbf weights approximating the stream function. Xc is a 
%matrix of rbf centres, k_i is a vector (or single scalar) of prescalers 
%(or function order in the case of polyharmicspline). 
%The basisfunction may be 'gaussian' or 'polyharmonicspline'.
% u=zeta_u*W;
% v=zeta_v*W;
%
%For more details, see Wiens, Travis "Sensing of Turbulent Flows Using
%Real-Time Acoustic Tomography." X1Xth Biennial Conference of the New
%Zealand Acoustical Society, 2008.
%or http://blog.nutaksas.com

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


if nargin<3
    k_i=1;
end

if nargin<4
    basisfunction='gaussian';
end

N_r=size(Xc,1);%number of rbf functions
N_p=size(X,1);%number of points

if numel(k_i)==1
    k_i=k_i*ones(N_r);%prescaler
end

zeta_u=zeros(N_p,N_r);
zeta_v=zeros(N_p,N_r);

for j=1:N_p
    for i=1:N_r
        switch basisfunction
            case {'gaussian','Gaussian'}
                phi=exp(-k_i(i)*sum((X(j,:)-Xc(i,:)).^2));%rbf
                zeta_u(j,i)=-2*(X(j,2)-Xc(i,2))*k_i(i)*phi;
                zeta_v(j,i)=2*(X(j,1)-Xc(i,1))*k_i(i)*phi;
            case {'phs', 'polyharmonicspline'}
            switch k_i(i)
                case 1
                zeta_u(j,i)=sum((X(j,:)-Xc(i,:)).^2)^(-1/2)*(X(j,2)-Xc(i,2));
                zeta_v(j,i)=sum((X(j,:)-Xc(i,:)).^2)^(-1/2)*(X(j,1)-Xc(i,1));
                otherwise
                    error('PHS order must be 1')
            end
            otherwise
                error('unknown basis function')
        end
    end
end
