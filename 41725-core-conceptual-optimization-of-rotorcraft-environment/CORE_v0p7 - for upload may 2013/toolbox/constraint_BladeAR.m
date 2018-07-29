function margin = BladeARconstraint(AR_all,AC)
% nonlinear constraint function are provided with an allowable value for
% the constraint and AC, a structure with aircraft data (see documentation)
% the function returns margin, which is positive is the constraint is
% satisfied.

AR = AC.Rotor.R./AC.Rotor.c;

margin = (AR_all - AR)/AR_all;

end