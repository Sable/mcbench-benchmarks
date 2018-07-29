%% Author: epokh
%% Website: www.epokh.org/drupy
%% This software is under GPL


function [J]=jacobianT6(Tuh,JType)
%%input: a list of transformation matrix: T01,T12,T23,T34,T45,T56
%%       a list of 6 joint type: R revolute joint  P prismatic joint
%% if the DOF of the manipulator are less than 6
%% complete the transformation matrixs with identity matrix
%%output: the geometric Jacobian
%% Jacobian matrix is generated column by column
J=zeros(6,6);

for c=1:1:6
   Ti6=eye(4,4); 
    for r=c:1:6
    Ti6=Ti6*Tuh(1:4,4*r-3:4*r);
    end
    n=Ti6(1:3,1);
    o=Ti6(1:3,2);
    a=Ti6(1:3,3);
    
    P=Ti6(:,4);
    if(JType(c)=='R')
        J(1,c)=-n(1)*P(2)+n(2)*P(1);
        J(2,c)=-o(1)*P(2)+o(2)*P(1);
        J(3,c)=-a(1)*P(2)+a(2)*P(1);
        J(4,c)=n(3);
        J(5,c)=o(3);
        J(6,c)=a(3);
    else

        J(1,c)=n(3);
        J(2,c)=o(3);
        J(3,c)=a(3);
        J(4,c)=0;
        J(5,c)=0;
        J(6,c)=0;

    end
    
end

end