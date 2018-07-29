function [b,secuencia] = substrleft(k,pam)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                                        %
%%    Name: substrleft.m                                                  %
%%                                                                        %
%%    Descripción: recibe un numero de caracteres que hay que extraer     %
%%     de una secuencia de caracteres y devuelve los caracteres extraidos %
%%     y la secuencia recortada                                           %
%%                                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if length(pam)<k
    pam = [pam,zeros(1,k-length(pam))];
end    
b = pam(1:k);
secuencia = pam(k+1:end);