% Caesar Cipher Encryption Operation
% Get the Key size for encryption  witht the tag ke
HH = findobj(gcf,'Tag','ke');
ke = str2double(get(HH,'String'));
% Get the Plain Text Value with the tag pl
HH = findobj(gcf,'Tag','pl');
pl = get(HH,'String');
%Operation of Encryption
if ke>26
    cipher = ['Wrong Key Used'];
    cipher=cipher;
    HH = findobj(gcf,'Tag','cipher'); 
set(HH,'String',cipher) 
end
C=pl+ke;
l=find(C>122);
C(l)=C(l)-26;
l=find(C>90);
l=find(C(l)<97);
C(l)=C(l)-26;
l=find(pl==32);
C(l)=32;
cipher=char(C);
HH = findobj(gcf,'Tag','cipher'); 
set(HH,'String',cipher) 
%%Caesar Cipher Decryption Operation
% Get the Key size for encryption  witht the tag kd
HH = findobj(gcf,'Tag','kd');
kd = str2double(get(HH,'String'));
% Get the Cipher Text Value with the tag en
HH = findobj(gcf,'Tag','en');
en = get(HH,'String');
plain=en-kd;
l=find(plain<65);
plain(l)=plain(l)+26;
l=find(plain<97);
l=find(plain(l)>90);
plain(l)=plain(l)+26;
l=find(en==32);
plain(l)=32;
plain=char(plain);
HH = findobj(gcf,'Tag','plain'); 
set(HH,'String',plain) 
