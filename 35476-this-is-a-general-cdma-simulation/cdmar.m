%% Code Division Multiple Access Reciever
% CDMAr - Function
% 1. (s) Input the data
% 2. (hl) Hadamard matrix length 
% 3. (cn) code number to be used for this user (row - number of H - matrix)
% 4. (ml) original message length for this user
% 4. Despread the data by multiplying s by cn.
% 6. Outpot of the function is a despread data of user cn.
% Montadar Abas Taher
% 11/03/2011
function [outcdmar]=cdmar(s,hl,cn,ml)
if cn>hl
    errordlg('The input code number must be equal or less than the Hadamard length','File Error');
end
%% Generate Hadamard Matrix of length (hl)
h=hadamard(hl);
%% Despread the input sequence
scused=ones(1,ml);


bds=kron(scused,h(cn,:));

ds=bds.*s;

rds=reshape(ds,hl,length(s)/hl);
ou=sum(rds);
t=length(ou);
en=[];
for a=1:t
    if ou(a)>1
        en(a)=1;
    else
        en(a)=-1;
    end
end
outcdmar=en;
