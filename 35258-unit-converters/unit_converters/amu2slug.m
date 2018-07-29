function [slug] = amu2slug(amu)
% Convert mass from atomic mass units to slugs. 
% Chad Greene 2012
slug = amu*(3.660864489409*1e-27)/32.17405;