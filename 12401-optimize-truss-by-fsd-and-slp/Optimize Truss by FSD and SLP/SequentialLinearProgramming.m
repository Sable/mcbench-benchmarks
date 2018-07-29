%*************************************************************************
%***                    SEQUENTIAL LINEAR PROGRAMMING                  ***
%***                     Nguyen Quoc Duan : I-2-1-b                    ***
%*************************************************************************
%             This is a practise exercise on Optimizing Structures

%                     University of Liege - EMMC 
%            ( European Master in Mechanics of Constructions )
%  Professor : Bui Cong Thanh (Faculty of Civil Engineering-HCMUT,Vietnam)
%  Student   : Nguyen Quoc Duan (EMMC11 - Ho Chi Minh City, Vietnam )


clear all; close all; clc;

disp('Units : kN-cm');

format short

syms X1 X2 X3 real
X=[X1 X2 X3];
sigU=16;            % Upper bound of stresses ( kN/cm2 ) 
sigL=-16;           % Lower bound of stresses ( kN/cm2 ) 
E=2*10^4;           % Elastic modulus of material ( kN/cm2 )
% LOAD DATA  
load femtruss;  %load stress and cross-sectional area variables: S and A

muy=1.0;    % factor of connection          
eta=5/6;    % ratio d/D       

% OBJECTIVE FUNCTION 
F=0;
for i=1:length(A)
    F=A(i)*Lbar(i)+F;   % weight of truss
end

% CONSTRAINTS
g=sym([]);  % constraint matrix

    %  Stress constraints 
    Ssign=subs(stress,{X1,X2,X3},[1 1 1]);
    for i=1:length(A)
        if Ssign(i)>=0
            gi=stress(i)-sigU;       
        else
            gi=stress(i)+sigL;
        end
        g=[g;gi];
    end
    clear gi;
    
    % Geometry constraints
    for j=1:length(X)
        gj=-X(j)+0.0864;
        g=[g;gj];
    end
    clear gj;
    
    % Stability constraints  
    for k=1:length(A)
        if Ssign(k)<0
         gk=-stress(k)-(1/4*pi*E*A(k)*(1+eta^2)/(muy*Lbar(k))^2*(1-eta^2));
         g=[g;gk];
        end
    end
    clear gk;
            
% SEQUENTIAL LINEAR PROGRAMMING 
% Initial data
X=[10 20 30];
iteration=0;
epsilon=0.0001;
error=1;

Xh=X;  % history matrix of all Xi
So=subs(stress,{X1,X2,X3},X)';  % stress in term of Xo 
Sh=So;  % history matrix of all stress
Fo=subs(F,{X1,X2,X3},X);
Fh=Fo;

while abs(error)>epsilon
    iteration=iteration+1;
    fprintf('********** Iteration : %g ***********\n',iteration)
    disp    ('---------------------------------------')
    Xo=X   
    for i=1:length(g)
        gln=linear(g(i),Xo);    % linearize the constraints
        Xf(i,:)=coef(gln);      % compute coefficients matrix
    end
    
    Fln=linear(F,Xo);           % linear the objective function

    Xf(i+1,:)=coef(Fln);        % compute coefficients matrix
    
    % Linear optimum
    X=linsystem(Xf);
    X=X'
    
    Fi=subs(F,{X1,X2,X3},X)
    Fh=[Fh;Fi];    
    Xh=[Xh;X];
    
    Si=subs(stress,{X1,X2,X3},X)';
    Sh=[Sh;Si];           
                
     error = sqrt(((X(1)-Xo(1))/Xo(1))^2+((X(2)-Xo(2))/Xo(2))^2+...
                + ((X(3)-Xo(3))/Xo(3))^2);               
                
                
                
    if iteration>20
        break;
    end
end

% OUTPUT 
disp('          History of X            ');
disp('-----------------------------------');
Xh
disp('History of objective function F ');
disp('-------------------------- -----');
Fh
disp('  History of stresses of bars   ');
disp('-------------------------- -----');
Sh

% Optimum design

disp('          OPTIMUM DESIGN        ');
disp('-----------------------------------');
disp('      Optimum variables values      ');

if Fh(iteration) >= Fh(iteration+1)
    Xopt=Xh(iteration+1,:)
else
    Xopt=Xh(iteration,:)
end


disp('Areas of bars at optimum');
disp('---------------------------'); 

    fprintf('           A1 = %g (cm2)\n',Xopt(1))
    fprintf('           A2 = %g (cm2)\n',Xopt(1))
    fprintf('           A3 = %g (cm2)\n',Xopt(2))
    fprintf('           A4 = %g (cm2)\n',Xopt(2))
    fprintf('           A5 = %g (cm2)\n',Xopt(2))
    fprintf('           A6 = %g (cm2)\n',Xopt(3))
    fprintf('           A7 = %g (cm2)\n',Xopt(3))


fprintf(' Number of loop:   %g \n',iteration)
fprintf(' Cross-sectional area of bar 1,2     :  X1 = %g (cm2)\n',Xopt(1))
fprintf(' Cross-sectional area of bar 3,4,5   :  X2 = %g (cm2)\n',Xopt(2))
fprintf(' Cross-sectional area of bar 6,7     :  X3 = %g (cm2)\n',Xopt(3))

% Compute internal radious and thickness of circular bars
% Assuming that thickness is one-fifth internal radious

for i=1:length(Xopt)
    r(i)=sqrt(pi*Xopt(i)*25/11);
    t(i)=0.2*r(i);
end

fprintf('   Radious of bar 1,2         :  r1 = %g (cm)\n',r(1))
fprintf('   Radious of bar 3,4,5       :  r2 = %g (cm)\n',r(2))
fprintf('   Radious of bar 6,7         :  r3 = %g (cm)\n',r(3))
fprintf('   Thickness of bar 1,2       :  t1 = %g (cm)\n',t(1))
fprintf('   Thickness of bar 3,4,5     :  t2 = %g (cm)\n',t(2))
fprintf('   Thickness of bar 6,7       :  t3 = %g (cm)\n',t(3))

disp('The volume of optimum design (cm3) ');
disp('------------------------------');

Fopt=subs(F,{X1,X2,X3},Xopt)

disp('***************************************************************');
disp('***                      Completed !                        ***');
disp('***   THANK YOU FOR YOUR INTERESTING LECTURES, PROFESSOR !  ***');
disp('***************************************************************');
