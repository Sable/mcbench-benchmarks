%*************************************************************************
%***          OPTIMALITY CRITERIA METHOD : FULLY STRESS DESIGN         ***
%***                     Nguyen Quoc Duan : I-2-1-b                    ***
%*************************************************************************
%             This is a practise exercise on Optimizing Structures

%                     University of Liege - EMMC 
%            ( European Master in Mechanics of Constructions )
%  Professor : Bui Cong Thanh (Faculty of Civil Engineering-HCMUT,Vietnam)
%  Student   : Nguyen Quoc Duan (EMMC11 - Ho Chi Minh City, Vietnam )


% FSD is applicable to design for the truss.

clear all;close all; clc;

disp(' The program is working. Please wait for a while, professor !');
disp('Units : kN-cm');

format short ;
syms X1 X2 X3 real
sigU=16;              % the limited tensive stress ( upper bound )
sigL=-16;             % the limited compressive stress ( lower bound )

% Load FEM results 
% load stress and cross-sectional area variables: Stress and A
load femtruss;    

%Initial point
Xo=[10 20 30];
iteration=0;
epsilon=0.0001;
error=1;
Xi=Xo;  % vector of across section variables
Xh=Xi;  % history matrix of all Xi
So=subs(stress,{X1,X2,X3},Xi)';  % stress in term of Xo 
Sh=So;  % history matrix of all stress

while error>epsilon
    iteration=iteration+1;
    fprintf('***** Iterative cycle %g *****\n',iteration)
    disp('-------------------------------------')
    
    %Compute stresses of bars in term of Xi
    Area=subs(A,{X1,X2,X3},Xi);
    S=subs(stress,{X1,X2,X3},Xi);
    
    %REDESIGN THE STRUCTURE
    
    % loop to optimize each bar
    for i=1:length(S)              
        if S(i)>=0
            Area(i)=Area(i)*S(i)/sigU;
        else
            Area(i)=Area(i)*S(i)/sigL;
        end        
    end
    
     % Condition for manufacturing
    for i=1:length(A)
        if Area(i)<0.0864
            Area(i)=0.0864;  % cm2
        end
    end
    
    % Consider the same across sections
    x1=max([Area(1) Area(2)]);
    x2=max([Area(3) Area(4) Area(5)]);
    x3=max([Area(6) Area(7)]);     
    Area=[x1 x1 x2 x2 x2 x3 x3]';        
    Xii=[x1 x2 x3];
    
    Xh=[Xh;Xii];
    
    Si=subs(stress,{X1,X2,X3},Xii)';
    Sh=[Sh;Si];
    
    error = sqrt(((Xii(1)-Xi(1))/Xi(1))^2+((Xii(2)-Xi(2))/Xi(2))^2+...
                + ((Xii(3)-Xi(3))/Xi(3))^2);
    Xi=Xii  
    
    if iteration >30    % maximum iterative loop = 30
        break
    end
    
end

 % Output 
disp('         OUTPUT RESULTS            ');
 
disp('Optimum for variables');
disp('---------------------');
X=Xi
disp('History for variables');
disp('---------------------');
Xh
disp('Stresses of bars at optimum');
disp('---------------------------');
Si
disp('history of stresses of bars ');
disp('---------------------------');
Sh

disp('Areas of bars at optimum');
disp('---------------------------'); 

    fprintf('           A1 = %g (cm2)\n',Area(1))
    fprintf('           A2 = %g (cm2)\n',Area(2))
    fprintf('           A3 = %g (cm2)\n',Area(3))
    fprintf('           A4 = %g (cm2)\n',Area(4))
    fprintf('           A5 = %g (cm2)\n',Area(5))
    fprintf('           A6 = %g (cm2)\n',Area(6))
    fprintf('           A7 = %g (cm2)\n',Area(7))


fprintf(' Number of loop:   %g \n',iteration)
fprintf('   Cross-sectional area of bar 1,2     :  X1 = %g (cm2)\n',X(1))
fprintf('   Cross-sectional area of bar 3,4,5   :  X2 = %g (cm2)\n',X(2))
fprintf('   Cross-sectional area of bar 6,7     :  X3 = %g (cm2)\n',X(3))

% Compute internal radious and thickness of circular bars
% Assuming that thickness is one-fifth internal radious

for i=1:length(X)
    r(i)=sqrt(pi*X(i)*25/11);
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

V=0;
for i=1:length(Area)
    Vi=Lbar(i)*Area(i);
    V=V+Vi;
end
V

disp('***************************************************************');
disp('***                      Completed !                        ***');
disp('***   THANK YOU FOR YOUR INTERESTING LECTURES, PROFESSOR !  ***');
disp('***************************************************************');
