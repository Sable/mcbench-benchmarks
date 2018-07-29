%% ----------------------------------------------------------------------------
% PSOGSA source codes version 1.0.
% Author: Seyedali Mirjalili (ali.mirjalili@gmail.com)

% Main paper:
% S. Mirjalili, S. Z. Mohd Hashim, and H. Moradian Sardroudi, "Training 
%feedforward neural networks using hybrid particle swarm optimization and 
%gravitational search algorithm," Applied Mathematics and Computation, 
%vol. 218, pp. 11125-11137, 2012.

%The paper of the PSOGSA algorithm utilized as the trainer:
%S. Mirjalili and S. Z. Mohd Hashim, "A New Hybrid PSOGSA Algorithm for 
%Function Optimization," in International Conference on Computer and Information 
%Application?ICCIA 2010), 2010, pp. 374-377.
%% -----------------------------------------------------------------------------

function o=My_FNN(Ino,Hno,Ono,W,B,x1,x2,x3,x4)
h=zeros(1,Hno);
o=zeros(1,Ono);

for i=1:Hno
    h(i)=My_sigmoid(x1*W(i)+x2*W(Hno+i)+x3*W(2*Hno+i)+x4*W(3*Hno+i)+B(i));
end

k=3;
for i=1:Ono
    k=k+1;
    for j=1:Hno
        o(i)=o(i)+(h(j)*W(k*Hno+j));
    end
end
for i=1:Ono 
    o(i)=My_sigmoid(o(i)+B(Hno+i));
end

