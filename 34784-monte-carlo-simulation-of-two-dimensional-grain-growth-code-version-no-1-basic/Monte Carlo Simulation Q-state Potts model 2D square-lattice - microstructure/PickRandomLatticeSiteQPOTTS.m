function [i,j] = PickRandomLatticeSiteQPOTTS(x,y)

i=floor(1+rand*size(x,1));
j=floor(1+rand*size(x,1));