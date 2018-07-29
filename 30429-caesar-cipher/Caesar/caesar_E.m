function C=caesar_E(P,k)
% P=plain text
% k=key (can be 0 to 26); k=0 mean No encryption
% Example: P='Hello World' k=3
% C=caesar(P,k), C=Khoor Zruog
%If you have any problem or feedback please contact me @
%%===============================================
% NIKESH BAJAJ
% Asst. Prof., Lovely Professional University, India
% Almameter: Aligarh Muslim University, India
% +919915522564, bajaj.nikkey@gmail.com
%%===============================================
if k>26
    error('Key must be in rang from 1 to 26')
end

C=double(P)+k;
l=find(C>122);
C(l)=C(l)-26;
l=find(C>90);
l=find(C(l)<97);
C(l)=C(l)-26;
l=find(P==32);
C(l)=32;
C=char(C);
disp(' ')
disp('Plain Text P=')
disp(P)
disp(' ')
disp('Cipher Text ')