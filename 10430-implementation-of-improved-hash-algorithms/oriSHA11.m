function output = SHA1 ()

fname=input('Input File (in ASCII format)? ','s');
hash_foutname=input('Output File for SHA Hash? ','s');
time1=clock;
%Open the input file and get the first line of data
fid=fopen(fname);
M = fread(fid);
fclose(fid);
ini=dec2bin(M(1),8);

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
   
% H(0) initialization
H = [ '67','45','23','01';...
      'ef','cd','ab','89';...
      '98','ba','dc','fe';...
      '10','32','54','76';...
      'c3','d2','e1','f0'] ;


for N = 1:length(block_temp)/512

	% Generate Wt
	Wt = WtgenSHA1( block(N,:) );

	%use previous last H's
	a_hex = H(1,:); a = hex2bin(a_hex);
	b_hex = H(2,:); b = hex2bin(b_hex);
	c_hex = H(3,:); c = hex2bin(c_hex);
	d_hex = H(4,:); d = hex2bin(d_hex);
	e_hex = H(5,:); e = hex2bin(e_hex);
	
	% Kt initialization
	
	for t = 1:80
        T1 = bin2dec2(cls(a,5) ); 
        %Number to Char
        if t <= 20
   f = xor(b&c, ~b&d); 
elseif t <= 40
   f = xor(xor(b,c),d);     
elseif t <= 60
    f = xor(xor(b&c,b&d),c&d);     
elseif t <= 80
    f = xor(xor(b,c),d);     
else
    error ('t must be in the range 1 to 80')
end

        T2 = bin2dec2(f);    
        T3 = bin2dec2(e);
        if t>=60
            T4=floor(2^32*sqrt(10));
        elseif t>=40
            T4=floor(2^32*sqrt(5));
        elseif t>=20
            T4=floor(2^32*sqrt(3));
        elseif t>0
            T4=floor(2^32*sqrt(2));
        end
%        T4=bin2dec2(Kt(t,:));
        T5 = bin2dec2(Wt(t,:) );     
        T = mod(T1+T2+T3+T4+T5,2^32);
        
        e = d;
        d = c;
        c = cls(b,30);
        b = a;
        a = dec2bin(T,32);    
        %display_resultsSHA1(t,a,b,c,d,e)         %receives column bits
	end
	
	H = calculate_new_HSHA1(H,a,b,c,d,e);
 
end
output=H;

time2=clock;
disp(etime(time2,time1));