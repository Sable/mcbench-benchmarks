% Least squares method for GPS positioning.
function [Rcv_Pos,Rcv_b] = Rcv_Pos_Compute(SV_Pos, SV_Rho)

Num_Of_SV=size(SV_Pos);
if Num_Of_SV<4
    Rcv_Pos=[0 0 0];Rcv_b=0;
    return;
end
%%
%Initial GPS Position
Rcv_Pos=[0 0 0];Rcv_b=0;
%Start Iteration
%Constrain for convergence  
  B1=1;
  END_LOOP=100;
  count=0;
while (END_LOOP > B1) 
    %A.Compute G
    G = G_Compute(SV_Pos, Rcv_Pos);
    %B.Compute Delta_Rho
    Delta_Rho = Delta_Rho_Compute(SV_Rho, SV_Pos, Rcv_Pos, Rcv_b);
    %C.Iteration for new postion
    Delta_X = inv(G' * G) * G' * Delta_Rho;
    Rcv_Pos = (Rcv_Pos' + Delta_X(1:3))';
    Rcv_b = Rcv_b + Delta_X(4);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    END_LOOP = (Delta_X(1)^2 + Delta_X(2)^2 + Delta_X(3)^2)^.5;
    count = count+1;
    if count>10
        END_LOOP=B1/2;
    end
end%End of While

end