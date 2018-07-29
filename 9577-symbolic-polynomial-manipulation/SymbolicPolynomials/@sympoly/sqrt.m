function sp=sqrt(sp)
% sympoly/sqrt: sqrt of a sympoly (sp.^0.5)
% usage: sp=sqrt(sp);
% 
% arguments:
%  sp - sympoly object

if length(sp.Coefficient)>1
  error 'Sqrt of a sympoly with multiple terms is not implemented.' 
end

sp.Exponent=sp.Exponent/2;
sp.Coefficient=sqrt(sp.Coefficient);


