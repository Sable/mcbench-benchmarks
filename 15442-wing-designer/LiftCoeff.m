function [CL, u_U, v_U, w_U, l_t, l_s] = LiftCoeff(gamma, panel, geo, Fu_bar, Fv_bar, Fw_bar)
%Determine the lift coefficient given the vortex strengths
%and the influence coefficients from the vortex lattice method

u_U.c = 1/(4*pi)*Fu_bar*[gamma.c]';  %Eqn 25 in NASA paper
v_U.c = 1/(4*pi)*Fv_bar*[gamma.c]';    %Eqn 23 in NASA paper
w_U.c = 1/(4*pi)*Fw_bar*[gamma.c]';

u_U.alpha = 1/(4*pi)*Fu_bar*[gamma.alpha]';
v_U.alpha = 1/(4*pi)*Fv_bar*[gamma.alpha]';
w_U.alpha = 1/(4*pi)*Fw_bar*[gamma.alpha]';

for i = 1:geo.ns
    for j = 1:geo.nc
        if i == geo.ns  %wingtip
            DeltaGamma(i,j).c = gamma(i,j).c;
            DeltaGamma(i,j).alpha = gamma(i,j).alpha;
        elseif j == 1 %Leading edge
            DeltaGamma(i,j).c = gamma(i,j).c-gamma(i+1,j).c;
            DeltaGamma(i,j).alpha = gamma(i,j).alpha-gamma(i+1,j).alpha;
        else
            DeltaGamma(i,j).c = DeltaGamma(i,j-1).c + gamma(i,j).c - gamma(i+1,j).c;
            DeltaGamma(i,j).alpha = DeltaGamma(i,j-1).alpha + gamma(i,j).alpha - gamma(i+1,j).alpha;
        end
    end
end

l_t.c = 2/geo.S*[DeltaGamma.c]'.*[panel.cc]'.*[v_U.c];  %Eqn 24 in NASA paper
l_t.alpha = 2/geo.S*[DeltaGamma.alpha]'.*[panel.cc]'.*[v_U.alpha];  %Eqn 24 in NASA paper

l_s.c = 2/geo.S*[gamma.c]'*2.*[panel.s]'.*((ones(size(u_U))-[u_U.c])+[v_U.c].*tan([panel.sweep]'))*cos(geo.dih);  %Eqn 28 in NASA paper
l_s.alpha = 2/geo.S*[gamma.alpha]'*2.*[panel.s]'.*((ones(size(u_U))-[u_U.alpha])+[v_U.alpha].*tan([panel.sweep]'))*cos(geo.dih);  %Eqn 28 in NASA paper

% reshape([l_t.c],geo.ns,geo.nc)
% reshape([l_t.alpha],geo.ns,geo.nc)
% reshape([l_s.c],geo.ns,geo.nc)
% reshape(((ones(size(u_U))-[u_U.alpha])+[v_U.alpha].*tan([panel.sweep]')),geo.ns,geo.nc)
% reshape([panel.s],geo.ns,geo.nc)
% reshape([l_s.alpha],geo.ns,geo.nc)
% reshape([u_U.alpha],geo.ns,geo.nc)
% reshape([v_U.alpha],geo.ns,geo.nc)
% reshape([gamma.alpha],geo.ns,geo.nc)
% sum([gamma.c])
% geo.S

CL.c = 2*(sum([l_t.c])+sum([l_s.c]));
CL.alpha = 2*(sum([l_t.alpha])+sum([l_s.alpha]));

