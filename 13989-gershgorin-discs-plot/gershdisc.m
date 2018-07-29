% gerschdisc.m
% 
% This function plots the Gershgorin Discs for the matrix A passed as an argument.
% It will also plot the centers of such discs, and the actual eigenvalues
% of the matrix.

function gershdisc(A)

error(nargchk(nargin,1,1));
if size(A,1) ~= size(A,2)
    error('Matrix should be square');
    return;
end

% For each row, we say:
for i=1:size(A,1)
    % The circle has center in (h,k) where h is the real part of A(i,i) and
    % k is the imaginary part of A(i,i)   :
    h=real(A(i,i)); k=imag(A(i,i)); 
    

    % Now we try to compute the radius of the circle, which is nothing more
    % than the sum of norm of the elements in the row where i != j
    r=0;
    for j=1:size(A,1)
       if i ~= j 
           r=r+(norm(A(i,j)));
       end    
    end 
    
    % We try to make a vector of points for the circle:
    N=256;
    t=(0:N)*2*pi/N;
    
    % Now we're able to map each of the elements of this vector into a
    % circle:
    plot( r*cos(t)+h, r*sin(t)+k ,'-');

    % We also plot the center of the circle for better undesrtanding:
    hold on;
    plot( h, k,'+');
end

% For the circles to be better graphed, we would like to have equal axis:
axis equal;

% Now we plot the actual eigenvalues of the matrix:
ev=eig(A);
for i=1:size(ev)
    rev=plot(real(ev(i)),imag(ev(i)),'ro');
end
hold off;
legend(rev,'Actual Eigenvalues');

end