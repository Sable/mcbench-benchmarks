function margin = constraint_Dlength(Dlength_all,AC)
% nonlinear constraint function are provided with an allowable value for
% the constraint and AC, a structure with aircraft data (see documentation)
% the function returns margin, which is positive is the constraint is
% satisfied.

Dlength = AC.Rotor.R+AC.TRotor.R+AC.TRotor.X;

margin = (Dlength_all - Dlength)/Dlength_all;

end