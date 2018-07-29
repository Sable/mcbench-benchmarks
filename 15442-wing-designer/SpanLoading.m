function [y_cp] = SpanLoading(l_s, l_t, CL, geo, panel)
%Determine center of pressure and spanwise loading 
%due to bound vortices and trailing vortices.

BV = [panel.BV];
BV1 = [panel.BV1];
s = [panel.s]';

y_cp.alpha = sum([l_s.alpha].*BV(2,:)' + [l_t.alpha].*BV1(2,:)')/(0.5*CL.alpha*0.5*geo.b);  %Eqn 35 in NASA paper
cl.alpha = ([l_s.alpha] + [l_t.alpha])*geo.S./(CL.alpha*2*s*cos(geo.dih)*geo.c_av);  %Eqn 37 in NASA paper

if CL.c ~= 0  %Prevent divide by zero
y_cp.c = sum([l_s.c].*BV(2,:)' + [l_t.c].*BV1(2,:)')/(0.5*CL.c*0.5*geo.b);  %Eqn 35 in NASA paper
cl.c = ([l_s.c] + [l_t.c])*geo.S./(CL.c*2*s*cos(geo.dih)*geo.c_av);  %Eqn 37 in NASA paper
else
    y_cp.c = 0;
    cl.c = zeros(size(cl.alpha));
end


