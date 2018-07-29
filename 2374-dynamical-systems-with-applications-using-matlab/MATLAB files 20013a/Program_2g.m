% Chapter 2 - Nonlinear Discrete Dynamical Systems.
% Program 2g - Computing the Lyapunov Exponents of the Henon map.
% Copyright Birkhauser 2013. Stephen Lynch.

itermax=500;
a=1.2;b=0.4;x=0;y=0;
vec1=[1;0];vec2=[0;1];
for i=1:itermax 
    x1=1-a*x^2+y;y1=b*x;
    x=x1;y=y1;
    J=[-2*a*x 1;b 0];
    vec1=J*vec1;
    vec2=J*vec2;
    dotprod1=dot(vec1,vec1);
    dotprod2=dot(vec1,vec2);
    vec2=vec2-(dotprod2/dotprod1)*vec1;
    lengthv1=sqrt(dotprod1);
    area=vec1(1)*vec2(2)-vec1(2)*vec2(1);
    h1=log(lengthv1)/i;
    h2=log(area)/i-h1;
end
fprintf('h1= %12.10f\n',h1)
fprintf('h2= %12.10f\n',h2)

% End of Program 2g.