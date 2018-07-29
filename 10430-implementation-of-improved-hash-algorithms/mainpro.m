fname=input('Input File (in ASCII format)? ','s');
hash_foutname=input('Output File for md5 Hash? ','s');
time1=clock;
%Open the input file and get the first line of data
fid=fopen(fname);
M = fread(fid);
fclose(fid);


pwd='sri';
ini=reshape(dec2bin(pwd,8),1,24);

for ii = 2:length(M)
    ini=cat(2,ini,dec2bin(M(ii),8));
end

s2=length(ini)/8;

block_temp = [ ini, ... 
                 '1', ... 
                 num2str(zeros(mod(448-1-s2*8,512),1))' ... 
                dec2bin(s2*8,64) ]; 
            nb=length(block_temp)/512;
block = reshape(block_temp,512,nb)';

shi=[7,12,17,22,7,12,17,22,7,12,17,22,7,12,17,22,5,9,14,20,5,9,14,20,5,9,14,20,5,9,14,20,4,11,16,23,4,11,16,23,4,11,16,23,4,11,16,23,6,10,15,21,6,10,15,21,6,10,15,21,6,10,15,21];

mp=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,2,7,12,1,6,11,16,5,10,15,4,9,14,3,8,13,6,9,12,15,2,5,8,11,14,1,4,7,10,13,16,3,1,8,15,6,13,4,11,2,9,16,7,14,5,12,3,10];

a=dec2bin(hex2dec('01234567'),32);a1=a;
b=dec2bin(hex2dec('89abcdef'),32);b1=b;
c=dec2bin(hex2dec('fedcba98'),32);c1=c;
d=dec2bin(hex2dec('76543210'),32);d1=d;   
for b=1:nb

    
inp=reshape(block(b,:),32,16)';

%disp('round1');
%Round1

for i=1:64
   
    a=d;
    d=c;
    c=b;
if i>48    
t1= bin2dec2(xor(c,(b&~d)));
elseif i>32    
t1= bin2dec2(xor(b,xor(c,d)));
elseif i>16    
t1= bin2dec2((b&d)|(c&~d));
else    
t1= bin2dec2((b&c)|(~b&d));
end



t2= floor(2^32*abs(sin(i)));
t3= bin2dec2(inp(mp(i),:));
t4=bin2dec2(b);
anst=dec2bin(mod(t1+t2+t3,2^32),32);
ans=cls(anst,shi(i));
b=dec2bin(mod(bin2dec2(ans)+t4,2^32),32);



end

a=dec2bin(mod(bin2dec2(a)+bin2dec2(a1),2^32),32);
b=dec2bin(mod(bin2dec2(b)+bin2dec2(b1),2^32),32);
c=dec2bin(mod(bin2dec2(c)+bin2dec2(c1),2^32),32);
d=dec2bin(mod(bin2dec2(d)+bin2dec2(d1),2^32),32);



end
a=dec2hex(bin2dec(a),8);disp(a);
b=dec2hex(bin2dec(b),8);disp(b);
c=dec2hex(bin2dec(c),8);disp(c);
d=dec2hex(bin2dec(d),8);disp(d);

time2=clock;

disp(etime(time2,time1));

fid=fopen(hash_foutname,'w+');
fprintf(fid,'%s',a);
fprintf(fid,'%s',b);
fprintf(fid,'%s',c);
fprintf(fid,'%s',d);

fclose(fid);

























