%% PIREG PI-regulator. Ger regulatorvärde.
%%
%% ut =  pireg(ipart,meas,set,k,itime)

function ut =  pireg(ipart,meas,set,k,itime)

e = set - meas;

ut = k*(e + 1/itime*ipart);

