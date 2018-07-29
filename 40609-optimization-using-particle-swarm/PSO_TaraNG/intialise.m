%% Intialise position & velocity of all agents %ini_posi_vel()
function intialise()
global El vel El_lim_low El_range P NumVer;
for p=1:P% population
        Randm=rand(1,NumVer);
        El(1,1:NumVer,p) = El_lim_low + Randm .* El_range;
        vel(1,1:NumVer,p) = El_lim_low + Randm .* El_range;
end
end