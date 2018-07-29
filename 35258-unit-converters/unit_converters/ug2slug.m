function [slug] = ug2slug(ug)
% Convert mass from micrograms to slugs. 
% Chad Greene 2012
slug = ug*(2.204622621849E-9)/32.17405;