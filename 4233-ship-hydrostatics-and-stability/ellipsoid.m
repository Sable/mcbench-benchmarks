%ELIIPSOID  Plots the upper half of a parametric ellipsoid of rotation
%   Figure 13.10.For explanations see Subsection 13.26 in the book.

% define axes
a = 5;
b = 3;
c = 2;
% plot the boundary of the patch and define frame
w = 0: 0.01: 1;
x = a*cos(2*pi*w);
y = b*sin(2*pi*w);
z = zeros(size(x));
plot3(x, y, z, 'k-')
axis off, axis equal
axis([ -1.1*a 1.1*a -1.1*b 1.1*b -0.3 1.2*c ])
t = [ 'Ellipsoid x^2/a^2 + y^2/b^2 + z^2/c^2 = 1, a = ' num2str(a) ];
t = [ t ', b = ' num2str(b) ' c = ' num2str(c) ]
Ht = title(t);
set(Ht, 'FontSize', 14)
hold on
% plot now family of constant-w curves
u = 0: 0.01: 1;
for w = 0: 0.1: 1
    x = a*cos(pi*u).*cos(2*pi*w);
    y = b*cos(pi*u).*sin(2*pi*w);
    z = c*sin(pi*u);
    plot3(x, y, z, 'k-')
end 
for w1 = 0.5: 0.1: 0.9
        t = [ 'w = ' num2str(w1) ];
        xt = a*cos(2*pi*w1);
        yt = b*sin(2*pi*w1);
        zt = -0.3;
        Ht = text(xt, yt, zt, t);
        set(Ht, 'FontSIze', 12)
end        

% plot now family of constant-u curves
w2 = 0: 0.01: 1;
for u2 = 0: 0.1: 1
    x = a*cos(pi/2*u2).*cos(2*pi*w2);
    y = b*cos(pi/2*u2).*sin(2*pi*w2);
    z = c*sin(pi/2*u2).*ones(size(x));
    plot3(x, y, z, 'k-')
end    
w3 = 0.6;
for u3   = 0: 0.1: 1
    x3   = a*cos(pi/2*u3).*cos(2*pi*w3);
    y3   = b*cos(pi/2*u3).*sin(2*pi*w3);
    z3   = c*sin(pi/2*u3).*ones(size(x3));
    t3  = [ 'u = ' num2str(u3) ];
    % xt1 = a*cos(2*pi*w3);
    % yt1 = b*sin(2*pi*w);
    % zt1 = c*sin(pi/2*u);
    Ht = text(x3, y3, z3, t3);
    set(Ht, 'FontSIze', 12)
end
hold off