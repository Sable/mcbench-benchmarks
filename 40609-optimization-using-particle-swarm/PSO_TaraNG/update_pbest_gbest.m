%% update pbest & gbest;
function update_pbest_gbest()
global n p ev FitVal pbest_val NumVer pbest_loc El gbest_val gbest_loc gbest_val_record;
if (n~=1)
    if (FitVal < pbest_val(p))%% check < or >
        pbest_loc(1,1:NumVer,p)=El(1,1:NumVer,p);
        pbest_val(p)=FitVal;
    end
    if(FitVal < gbest_val)
        gbest_loc(1,1:NumVer)=El(1,1:NumVer,p);
        gbest_val = FitVal;
    end
else
    pbest_loc(1,1:NumVer,p)=El(1,1:NumVer,p);
    pbest_val(p)=FitVal;
    if(p~=1)
        if(pbest_val(p) < gbest_val)
        gbest_loc(1,1:NumVer)= El(1,1:NumVer,p);
        gbest_val = FitVal;
        end
    else
        gbest_loc(1,1:NumVer) = pbest_loc(1,1:NumVer,p);
        gbest_val = pbest_val(p);
    end
end
gbest_val_record(ev) = gbest_val;
end
