%
% The following material summarizes mathematical relations
% facilitating use of curvilinear coordinates. ANY
% REPEATED INDICES IN THESE EQUATIONS ARE ASSUMED TO BE
% SUMMED FROM 1 TO 3. Typical symbols such as v_(i), v(i),
% and V(i) denote cartesian, covariant, and contravariant
% vector components, respectively.
%
% Cartesian base vectors
% e(1)=[1;0;0], e(2)=[0;1;0], e(3)=[0;0;1]
%
% Cartesian radius vector where the subscript _ designates
% cartesian components. 
% x = [x_(1); x_(2); x_(3)] = x_(k)*e(k)
%
% General vector v
% v = [v_(1); v_(2); v_(3)] = v_(k)*e(k)
%
% Dot product vectors u and v
% dot(u,v) = u_(k)*v_(k)
%
% Kronecker delta symbol
% delta(i,j) = dot(e(i),e(j))
%
% Permutation symbol
% perm(i,j,k) = dot(cross(e(i),e(j)),e(k))
%             = (i-j)*(j-k)*(k-i)/2
%
% Cross product of two vectors
% cross(u,v) = perm(i,j,k)*u_(i)*v_(j)*e(k)
%
% Divergence of a vector
% div(v) = diff(v_(k),x(k))
%
% Curl of a vector
% curl(v) = perm(i,j,k)*diff(v_(j),x(i))*e(k)
%
% Curvilinear coordinate variables (which are
% usually not vector components)
% t=[t(1),t(2),t(3)]
%
% Coordinate transformation where radius vector
% x is a function of the curvilinear coordinate
% variables
% x = x(t(1),t(2),t(3))
%
% Jacobian matrix
% Jmat=[diff(x,t(1)), diff(x,t(2)), diff(x,t(3))]
%
% Jacobian determinant
% Jdet=det(Jmat)
%
% Covariant base vectors (which are tangents to the
% coordinate lines)
% g(i) = diff(x,t(i))
% Matrix Jmat has columns which are the components
% of the covariant base vectors.
%
% Contravariant base vectors (which are normals to the
% coordinate surfaces)
% G(i) = [diff(t(i),x(1)); diff(t(i),x(2)); diff(t(i),x(3))];
% Alternately, G(i) is column i of inv(Jmat.').
%
% Base vector orthogonality
% dot(g(i),G(j)) = delta(i,j)
%
% The base vector components determine matrices of metric
% tensor components as follows:
% gmet = Jmat'*Jmat gives the covariant components and
% Gmet = inv(gmet) gives the contravariant components.
% These matrices are symmetric and their matrix product 
% yields the identity matrix.
%
% Vector representation relative to different bases
% v = v_(i)*e(i) = v(i)*G(i) = V(i)*g(i) where
% v_(i) = dot(v,e(i)), cartesian components
% v(i)  = dot(v,g(i)), covariant components
% V(i)  = dot(v,G(i)), contravariant components
%
% The metric tensor components are useful for switching
% between vector bases according to
% v(i) = gmet(i,k)*V(k) and V(i) = Gmet(i,k)*v(k)
%
% Dot product of two vectors
% dot(u,v) = u(i)*V(i) = U(i)*v(i)
%
% Cross product of two vectors
% w= cross(u,v) = w(k)*G(k) = W(k)*g(k) where
% w(k) =   Jdet*perm(i,j,k)*U(i)*V(j) and
% W(k) = 1/Jdet*perm(i,j,k)*u(i)*v(j)
%
% Divergence of a vector
% div(u)=1/Jdet*diff((Jdet*U(k)),t(k))
%
% covariant differentiation
% diff(v,t(i)) = diff( V(j)*g(j),t(i) )
%              = cvdif( V(j),t(i) )*g(j)
%              = dif( v(j)*G(j),t(i) )
%              = cvdif( v(j),t(i) )*G(j)
% where cvdif(V(j),t(i)) means the covariant derivative
% of contravariant component V(j) with respect to 
% curvilinear coordinate t(i). These quantities involve
% Christoffel symbols cs1(i,j,k) and cs2(i,j,k) computed
% in terms of the base vectors and their derivatives. 
% The Christoffel symbol of the first kind is  
%
% cs1(i,j,k) = dot(diff(g(i),t(j)),g(k)))
%
% and The Christoffel symbol of the second kind is
%
% cs2(i,j,k) = dot(diff(g(i),t(j)),G(k))
%
% The Christoffel symbols, which are not tensors, can also
% be obtained as derivatives of the metric tensor 
% components. It is found that
%
% cs1(i,j,k) = [diff(gmet(j,k),t(i))+...
%               diff(gmet(i,k),t(j))-...
%               diff(gmet(i,j),t(k))]/2
% and
%
% cs2(i,j,k) = cs1(i,j,m)*Gmet(m,k)
%
% With the aid of the Christoffel symbols, the covariant
% derivatives introduced above are expressed as
%
% cvdif(v(i),t(j)) = diff(v(i),t(j))-v(n)*cs2(i,j,n)
% cvdif(V(i),t(j)) = diff(V(i),t(j))+V(n)*cs2(n,j,i)
%
% Divergence and curl of a vector can also be obtained
% in general form by using covariant derivatives. This
% gives
% div(v) = cvdif(V(k),t(k))
% and 
% curl(v) = 1/Jdet*perm(i,j,k)*cvdif(v(j),t(i))*g(k)
% 
% Two final relations which often occur in field problems
% for general curvilinear coordinates relate to the 
% gradient and Laplacian of a scalar function phi. It
% is can be shown that
% grad(phi) = G(k)*diff(phi,t(k))
%
% and for the Laplacian
%
% div(grad(phi) = 1/Jdet*diff((Jdet*G(i,j)*...
%                              diff(phi,t(i))),t(j))