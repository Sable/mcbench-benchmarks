function Q=addlz(E,N)
%these function add 'N' low zero to end of a vector array 'E'
for i=length(E)+1:length(E)+N
    E(i)=0;
end
Q=E;