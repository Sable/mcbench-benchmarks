function [ radius ] = atomic_radius( Z )
%ATOMIC_RADIUS Get atomic radius of element.
%   r = ATOMIC_RADIUS(Z) returns the atomic radius of element number Z in
%   Angstroms, as given in J. Chem. Phys. 47, 1300 (1967) doi: 
%   10.1063/1.1712084. Z can also be a string the the element symbol. For 
%   unrecognized symbols/element numbers, a a value of 1.0 is returned.
%
%   See also CHEMSYM2NUMBER, NUMBER2CHEMSYM

    if ischar(Z)
        Z = chemsym2number(Z);
    end
    
    default_r = 1.0;
    
    r = [ ...
     0.53 ... H
     0.31 ... He
     1.67 ... Li
     1.12 ... Be
     0.87 ... B
     0.67 ... C
     0.56 ... N
     0.48 ... O
     0.42 ... F
     0.38 ... Ne
     1.90 ... Na
     1.45 ... Mg
     1.18 ... Al
     1.11 ... Si
     0.98 ... P
     0.88 ... S
     0.79 ... Cl
     0.71 ... Ar
     2.43 ... K
     1.94 ... Ca
     1.84 ... Sc
     1.76 ... Ti
     1.71 ... V
     1.66 ... Cr
     1.61 ... Mn
     1.56 ... Fe
     1.52 ... Co
     1.49 ... Ni
     1.45 ... Cu
     1.42 ... Zn
     1.36 ... Ga
     1.25 ... Ge
     1.14 ... As
     1.03 ... Se
     0.94 ... Br
     0.88 ... Kr
     2.65 ... Rb
     2.19 ... Sr
     2.12 ... Y
     2.06 ... Zr
     1.98 ... Nb
     1.90 ... Mo
     1.83 ... Tc
     1.78 ... Ru
     1.73 ... Rh
     1.69 ... Pd
     1.65 ... Ag
     1.61 ... Cd
     1.56 ... In
     1.45 ... Sn
     1.33 ... Sb
     1.23 ... Te
     1.15 ... I
     1.08 ... Xe
     2.98 ... Cs
     2.53 ... Ba
     default_r ... La (missing value)
     default_r ... Ce (missing value)
     2.47 ... Pr
     2.06 ... Nd
     2.05 ... Pm
     2.38 ... Sm
     2.31 ... Eu
     2.33 ... Gd
     2.25 ... Tb
     2.28 ... Dy
     2.26 ... Ho
     2.26 ... Er
     2.22 ... Tm
     2.22 ... Yb
     2.17 ... Lu
%{
     ... Hf
      ... Ta
      ... W 
      ... Re
      ... Os
      ... Ir
      ... Pt
      ... Au
      ... Hg
      ... Tl
      ... Pb
      ... Bi
      ... Po
      ... At
      ... Rn
      ... Fr
      ... Ra
      ... Ac
      ... Th
      ... Pa
      ... U
      ... Np
      ... Pu
      ... Am
      ... Cm
      ... Bk
      ... Cf
      ... Es
      ... Fm
      ... Md
      ... No
      ... Lr
      ... Rf
      ... Db
      ... Sg
      ... Bh
      ... Hs
      ... Mt
%}
     ]; 
     if Z <= numel(r)
        radius = r(Z);
     else
         radius = default_r; % default radius
     end
end

