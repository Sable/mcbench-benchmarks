% Wigner 6j-symbol calculator.
% Written by Amita B Deb, Clarendon Lab. 2007.

% Calculates { j1, j2 ,j3}  using Racah formula. See: Sobelman: Atomic Spectra and Radiative Transitions.
%              J1  J2  J3


function Wigner = Wigner6j(j1,j2,j3,J1,J2,J3)



% Finding Triangular coefficients
tri1 = triangle_coeff(j1,j2,j3);
tri2 = triangle_coeff(j1,J2,J3);
tri3 = triangle_coeff(J1,j2,J3);
tri4 = triangle_coeff(J1,J2,j3);

% Finding the range of summation in Racah formula.

a(1) = j1 + j2 + j3;
a(2) = j1 + J2 + J3;
a(3) = J1 + j2 + J3;
a(4) = J1 + J2 + j3;

rangei = max(a)

k(1) = j1 + j2 + J1 + J2;
k(2) = j2 + j3 + J2 + J3;
k(3) = j3 + j1 + J3 + J1;

rangef = min(k)

%range = min([j1+j2-j3 j1+J2-J3 J1+j2-J3 J1+J2-j3 j2+j3-j1 J2+J3-j1 j2+J3-J1 J2+j3-J1 j3+j1-j2 J3+j1-J2 J3+J1-j2 j3+J1-J2])

Wigner = 0;



   for t=rangei:rangef,
   
       
   
      Wigner = Wigner+ (tri1*tri2*tri3*tri4)^(0.5)*((-1)^t)*factorial(t+1)/fung(t,j1,j2,j3,J1,J2,J3);
      
   end
   
   
   Wigner
   
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % Calculateing triange coefficients for Angular momenta.

function tri = triangle_coeff(a,b,c)

tri = factorial(a+b-c)*factorial(a-b+c)*factorial(-a+b+c)/(factorial(a+b+c+1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Calculating the dem=nominator in Racah Formula

function r = fung(t, j1,j2,j3,J1,J2,J3)

r = factorial(t-j1-j2-j3)*factorial(t-j1-J2-J3)*factorial(t-J1-j2-J3)*factorial(t-J1-J2-j3)*factorial(j1+j2+J1+J2-t)*...
   factorial(j2+j3+J2+J3-t)*factorial(j3+j1+J3+J1-t);


