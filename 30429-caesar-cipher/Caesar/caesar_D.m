function P=caesar_D(C,k)
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

P=double(C)-k;
l=find(P<65);
P(l)=P(l)+26;

l=find(P<97);
l=find(P(l)>90)
P(l)=P(l)+26;

l=find(C==32);
P(l)=32;

P=char(P);
disp(' ')
disp('Cipher Text C =')
disp(C)
disp(' ')
disp('Plain Text')