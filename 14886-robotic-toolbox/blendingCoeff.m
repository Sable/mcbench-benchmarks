

%%input values:
%% thetai: initial positional value
%% thetaf: final positional value
%% acci: initial acceleration
%% tf: final time
%% omega: cruise velocity
%% intermediate (boolean):1 it's an intermediate blending 
function tb=blendingCoeff(thetai,thetaf,tf,omega,acci,intermediate)
if(intermediate==0)
tb=(thetai-thetaf+omega*tf)/omega;
else

 tbsol=roots([acci,-2*omega,omega*tf+thetai-thetaf]);   
 %%two solution
 tb1=tbsol(1);
 tb2=tbsol(2);
 if(isreal(tb1) && isreal(tb2) )
     if(tb1>tb2)
        tb=tb1;
     else
         tb=tb2;
     end
 else
     if(isreal(tb1)) tb=tb1;
     else tb=tb2;
     end
 end

end
end