function Omegapsi=Omegapsi_rbf(Xc,X1,X2,k_i,c0,basisfunction)
%Omegapsi=Omegapsi_rbf(Xc,X1,X2,k_i,c0,basisfunction)
%calculates the Omegapsi matrix for an rbfn approximating the the stream
%function, psi, for vector tomography. 
%Xc is a [x y] matrix of rbf centres
%X1 and X1 are [x y] matrices of transducer positions
%c0 is the base wave speed
%basis function may be 'gaussian' or 'polyharmonic spline'
%if 'gaussian', k_i is a prescaler
%if 'polyharmonic spline', k_i is the order (currently 1 or 3)
%
%Omegapsi is 1/c0^2*int(diff(Phi,q),X1,X2) where q is in the direction of
%the line between X1 and X2.
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

if nargin<4
    k_i=1;
end

if nargin<6
    basisfunction='gaussian';
end

N_r=size(Xc,1);%number of centres
N_p=size(X1,1);%number of paths

if numel(k_i)==1
    k_i=k_i*ones(N_r);
end

Omegapsi=zeros(N_p,N_r);%allocate matrix
theta=atan2(X2(:,2)-X1(:,2),X2(:,1)-X1(:,1));%angle of line from x axis
    
for i=1:N_r
    %this performs a coordinate rotation and translation, such that
    %the p-axis is parallel to the line connecting X1 and X2, and
    %the origin is at Xc.
    p1=(X1(:,1)-Xc(i,1)).*cos(theta)+(X1(:,2)-Xc(i,2)).*sin(theta);
    p2=(X2(:,1)-Xc(i,1)).*cos(theta)+(X2(:,2)-Xc(i,2)).*sin(theta);
    q=-(X2(:,1)-Xc(i,1)).*sin(theta)+(X2(:,2)-Xc(i,2)).*cos(theta);

    switch basisfunction
        case {'gaussian','Gaussian'}
            Omegapsi(:,i)=-1/c0^2*q.*sqrt(pi*k_i(i)).*exp(-k_i(i)*q.^2).*(erf(sqrt(k_i(i)).*p2)-erf(sqrt(k_i(i)).*p1));
        case {'phs', 'polyharmonicspline'}
            switch k_i(i)
                case 1
                    Omegapsi(:,i)=1/c0^2*-q.*(log(p1+(q.^2+p1.^2).^(1/2))-log(p2+(q.^2+p2.^2).^(1/2)));
                case 3
                    Omegapsi(:,i)=1/c0^2*-3/2*q.*(p1.*(q.^2+p1.^2).^(1/2)+q.^2.*log(p1+(q.^2+p1.^2).^(1/2))-p2.*(q.^2+p2.^2).^(1/2)-q.^2.*log(p2+(q.^2+p2.^2).^(1/2)));
                otherwise
                    error('k_i must be 1 or 3')
            end
        otherwise
            error('unknown basis function')
    end
end
end



