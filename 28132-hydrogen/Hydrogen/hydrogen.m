
function Ynlm=hydrogen
% NAME
% hydrogen - non-relativistic Schrodinger's Equation analytical 
% solution for hydrogen
%
% DESCRIPTION
% Hydrogen is a simple program that allows the user to 'view' the orbitals
% of a hydrogenic atom.  When run, hydrogen prompts the user for the three
% quantum numbers.  Hydrogen then checks to make sure that the user inputs
% are valid, i.e. checks for the quantum rules and makes sure that the
% inputs are integers.
%
% Hydrogen is called via the command hydrogen.  The program then askes the
% user for: the principal quantum number (n), the angular quantum number
% (l) and the magnetic quantum number (m_l).  Based upon the user inputs,
% the program uses the analytical solution to the non-relativistic 
% Schrodinger's Equation to produce the obitals of the hydrogen atom
% 
% AUTHOR
% Sasha Karcz
%                       2010                        hydrogen(1)


%Collecting data from user

nn=input('Principal Quantum Number (n)=');
l=input('Angular Quantum Number (l)=');
m=input('Magnetic Quantum Number (m_l)=');

%Checking for valid user inputs

if nn~=0
    disp('Checking that the Principal Quantum Number is Non-Zero                  [  OK  ]')
elseif nn==0 disp('Checking that the Principal Quantum Number is Non-Zero                  [ FAIL ]'), return
end

if mod(nn,1)==0
    disp('Checking that the Principal Quantum Number is an Integer                [  OK  ]')
elseif mod(nn,1)~=0 disp('Checking that the Principal Quantum Number is an Integer                [ FAIL ]'), return
end


if nn/abs(nn)==1
    disp('Checking that the Principal Quantum Number is Positive                  [  OK  ]')
elseif nn/abs(nn)~=1 disp('Checking that the Principal Quantum Number is Positive                 [ FAIL ]'), return
end

if mod(l,1)==0
    disp('Checking that the Angular Quantum Number is an Integer                  [  OK  ]')
elseif mod(l,1)~=0 disp('Checking that the Angular Quantum Number is an Integer                  [ FAIL ]'), return
elseif l==0 disp('Checking that the Angular Quantum Number is an Integer                  [  OK  ]')
end

if l/abs(l)==1
    disp('Checking that the Angular Quantum Number is Positive                    [  OK  ]')
elseif l==0 disp('Checking that the Angular Quantum Number is Positive                    [  OK  ]') 
elseif l/abs(l)~=0 disp('Checking that the Angular Quantum Number is Positive                   [ FAIL ]'), return
end

if mod(m,1)==0
    disp('Checking that the Magnetic Quantum Number is an Integer                 [  OK  ]')
elseif mod(m,1)~=0 disp('Checking that the Magnetic Quantum Number is an Integer                [ FAIL ]'), return
end

if nn-1 >= l
    disp('Checking Principal and Angular Quantum Number                           [  OK  ]')
elseif l >= 1-nn disp('Checking Principal and Angular Quantum Number                           [ FAIL ]'), return
end

if l >= abs(m)
    disp('Checking Angular and Magnetic Quantum Number                            [  OK  ]')
elseif abs(m) >= l disp('Checking Angular and Magnetic Quantum Number                            [ FAIL ]'), return
end




n = 6;  %  Number of samples per half wavelength
N = max([30, l*6]);
theta = [0 : N]' *pi/N;
phi   =[-N : N]  *pi/N;
mm=abs(m);


%  Create the surface of Re Ylm(theta,phi)/r^(l+1) = 1;
%  Solves for r on a theta, phi grid
gamma = 1/(l+1);
all = legendre(l, cos(theta));
if (l == 0) all=all'; end         % Compensate for error in legendre 
Ylm = all(mm+1, :)' * cos(mm*phi);
[A,B]=size(Ylm);
x=linspace(-50e-10,50e-10,B*A);
x=reshape(x,A,B);

%  Creates the radial component of the wavefunction
ra=(polyval(LaguerreGen(nn),x));
size(ra');
size(Ylm);
r = ra.*(abs(Ylm) .^ gamma);


%  Convert to Cartesian coordinates
X =  r.* (sin(theta)*cos(phi)) ;
Y =  r.* (sin(theta)*sin(phi));
Z =  r.* (cos(theta)*ones(size(phi)));

%  Color according to size of Ylm
C = Ylm.^1;


% Graph a three dimensional surface that represents the orbital
figure(1)
surf(X, Y, Z, C,'FaceColor','flat','FaceLighting','phong')
shading('interp')
%colormap([1 .1 0]);
h=camlight('left');
lighting phong
grid off
axis off
axis equal

ti=['Hydrogen Atom with n=' int2str(nn) ', l=' int2str(l) ', m_l=' int2str(m)];
title(ti);

%  Rotate graph
for i=1:400;
	camorbit(2,0,'camera')
    camlight(h,'left')
	drawnow
end









end
