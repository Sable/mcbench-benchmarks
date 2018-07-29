function Adj = polygon(N, d, rad)
% Adj = polygon(N, d, rad)
% Plots the regular polygon {N/d} with vertices on a circle of radius
% 'rad'. The output 'Adj' is the adjacency matrix of the corresponding
% graph. 
%
% Description:
% ------------
% Let d < N be a positive integer and define p = N/d.
% Let y_{1} be a point on the unit circle. Let R be clockwise
% rotation by the angle t = 2*pi/p. The generalized regular
% polygon {p} is given by the points y_{i+1} = R * y_{i}, and edges
% between points i and i+1.
%
% Example: 
% --------
% polygon(9, 4, 1);
% 
% 
% Nima Moshtagh (nima@seas.upenn.edu)
% University of Pennsylvania
%
% Sept. 2007
%


% check the values of 'd' and 'N'. They must be integers.
if (d - round(d)) ~= 0 || (N - round(N)) ~= 0 
    display('error: Input parameters N and d must be integers!');
    return;
elseif d > N,
        display('error: d must be less than or equal to N.');
        return
else
    p = N/d;
    t = 2*pi/p;
end

% generate the vertices.
%theta = [pi/N : 2*pi/N : 2*pi];
theta = [0 : 2*pi/N : 2*pi]
Pos = rad * exp(i*theta);

X = real(Pos);
Y = imag(Pos);

% plot the vertices on a circle
plot(X,Y,'o');
axis([-2*rad 2*rad -2*rad 2*rad]);

A = zeros(N);
for j = 1:N,
    % compute the position of the neighboring vertix
    node = exp(i*t) *Pos(j);
    xx = real(node);
    yy = imag(node);
    
    % find the index of the neighboring vertix
    indx = mod(j+d,N);
    if indx == 0,
        indx = N;
    end
    A(j,indx) = 1;
    % connect the vertices
    line([X(j) xx], [Y(j) yy]);
end
axis equal
% the Adjacency matrix 
Adj = A + A';
