% MultiQuadrics scattered data INTERPOLATION. 
% 
% SYNTAX: [fi, coefficients] = mq_interpolation( r, f, ri, c )
%
%          where r and f are the scattered argument and function
%          values, fi is the data interpolated at ri, c is the  
%          multiquadric parameter and coefficients is a vector  
%          containing the coefficients of the MQ expansion. 
%
%         Examples: 
%         N =  51; c = 0.2;
%         x = 2*pi*sort( rand([1 N]) ); f = sin(x);
%         xi = linspace(0,2*pi,N);
%        [fi,coefficients] = mq_interpolation(x(:),f(:),xi(:),c);
%         figure(1), plot(x,f,xi,fi,'o')
% 
%	  N = 51; c = 0;
%	  x = 2*rand([1 N]) - 1; y = 2*rand([1 N]) - 1; r = [x(:) y(:)];
%	  for i = 1:N, f(i) = exp( -x(i)^2 -y(i)^2 ); end
%	  xi = linspace(-1.1,1.1,N); yi = linspace(-1.1,1.1,N);
%	 [Xi,Yi] = meshgrid(xi,yi);
%	  for i = 1:N*N, ri(i,:) = [Xi(i) Yi(i)]; end
%	 [fi,coefficients] = mq_interpolation(r,f(:),ri,c);
%	  S = reshape(fi,N,N);
%	  figure(2)
%	  mesh(xi,yi,S), hold on, plot3(x,y,f,'o'), hold off


% Written by Orlando Camargo Rodriguez

function [fi,coefficients] = mq_interpolation(r,f,ri,c)

fi           = [];
coefficients = [];

N = length( r(:,1) ); 

for i = 1:N   

    rj_minus_ri = ( r(i,:)'*ones([1 N]) )' - r;
    
    Phi(:,i) = sqrt( sum( rj_minus_ri.^2 , 2 ) + c*c );
    
end

coefficients = Phi\f(:); % Calculate the coefficients through Gaussian elimination

Ni = length( ri(:,1) );

for i = 1:Ni

    ri_minus_r = ( ri(i,:)'*ones([1 N]) )' - r;
    
    phi_at_ri = sqrt( sum( ri_minus_r.^2 , 2 ) + c*c );
    
    fi(i) = coefficients'*phi_at_ri(:);
    
end
