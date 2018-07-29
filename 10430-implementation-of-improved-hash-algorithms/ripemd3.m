time1=clock;
fname=input('Input File (in ASCII format)? ','s');
hash_foutname=input('Output File for ripemd Hash? ','s');
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
   block = reshape(block_temp,512,length(block_temp)/512)';

   H = [ '67','45','23','01';...
      'ef','cd','ab','89';...
      '98','ba','dc','fe';...
      '10','32','54','76';...
      'c3','d2','e1','f0'] ;

   
        rho=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,7,4,13,1,10,6,15,3,12,0,9,5,2,14,11,8,3,10,14,4,9,15,8,1,2,7,0,6,13,11,5,12,1,9,11,10,0,8,12,4,13,3,7,15,14,5,6,2,4,0,5,9,7,12,2,10,14,1,3,8,11,6,15,13];
        phi=[5,14,7,0,9,2,11,4,13,6,15,8,1,10,3,12,6,11,3,7,0,13,5,10,14,15,8,12,4,9,1,2,15,5,1,3,7,14,6,9,11,8,12,2,10,0,4,13,8,6,4,1,3,11,15,0,5,12,2,13,9,7,10,14,12,15,10,4,1,5,8,7,6,2,13,14,0,3,9,11];
        shi=[11,14,15,12,5,8,7,9,11,13,14,15,6,7,9,8,7,6,8,13,11,9,7,15,7,12,15,9,11,7,13,12,11,13,6,7,14,9,13,15,14,8,13,6,5,12,7,5,11,12,14,15,14,15,9,8,9,14,5,6,8,6,5,12,9,15,5,11,6,8,13,12,5,12,13,14,11,8,5,6];
        shi1=[8,9,9,11,13,15,15,5,7,7,8,11,14,14,12,6,9,13,15,7,12,8,9,11,7,7,12,7,6,15,13,11,9,7,15,11,8,6,6,14,12,13,5,14,13,13,7,5,15,5,8,11,14,14,6,14,6,9,12,9,12,5,15,8,8,5,12,9,12,5,14,6,8,13,6,5,15,13,11,11];

 a = hex2bin(H(1,:));
 b = hex2bin(H(2,:));
 c = hex2bin(H(3,:));
 d = hex2bin(H(4,:));
 e = hex2bin(H(5,:));
a1=a;
b1=b;
c1=c;
d1=d;
e1=e;

a2=a;
b2=b;
c2=c;
d2=d;
e2=e;
for N = 1:length(block_temp)/512

    for i=1:80

        inp=reshape(block(N,:),32,16)';

    if i>64
       K = floor(2^30*sqrt(7)); 
       K1=0;
            

       elseif i>48
       K = floor(2^30*sqrt(5));
       K1 = floor(2^30*(7^(1/3)));
            
          elseif i>32
       K = floor(2^30*sqrt(3));
       K1 = floor(2^30*(5^(1/3)));            
       
               elseif i>16
                K1 = floor(2^30*(3^(1/3)));
                K = floor(2^30*sqrt(2));
            
                 elseif i>0
                     K=0;
                     K1 = floor(2^30*(2^(1/3)));
            
                     end
 %left part

              t1=bin2dec2(fripemd(i,'L',b1,c1,d1));                  
              t=rho(i);
              t2=bin2dec2(inp(t+1,:));
              t3=bin2dec2(a1);
              t4=bin2dec2(e1);
         

             a1=e1;
             e1=d1;
             
             d1=cls(c1,10);
             c1=b1;

             btemp=bin2dec2(cls(dec2bin(mod(K+t1+t2+t3,2^32),32),shi(i)));     
             b1=dec2bin(mod(btemp+t4,2^32),32);
%right part             
             
             t1=bin2dec2(fripemd(i,'R',b2,c2,d2));
              t=phi(i);
              t2=bin2dec2(inp(t+1,:));
              t3=bin2dec2(a2);
              t4=bin2dec2(e2);   
    
              a2=e2;
              e2=d2;
             
              d2=cls(c2,10);
              c2=b2;

              btemp=bin2dec2(cls(dec2bin(mod(K1+t1+t2+t3,2^32),32),shi1(i)));     
              b2=dec2bin(mod(btemp+t4,2^32),32);
         end
            


        
                  a=dec2hex(mod(bin2dec2(b)+bin2dec2(c1)+bin2dec2(d2),2^32),8);
                  b=dec2hex(mod(bin2dec2(c)+bin2dec2(d1)+bin2dec2(e2),2^32),8);
                  c=dec2hex(mod(bin2dec2(d)+bin2dec2(e1)+bin2dec2(a2),2^32),8);                  
                  d=dec2hex(mod(bin2dec2(e)+bin2dec2(a1)+bin2dec2(b2),2^32),8);                  
                  e=dec2hex(mod(bin2dec2(a)+bin2dec2(b1)+bin2dec2(c2),2^32),8);

         
         
end
disp(a);
disp(b);
disp(c);
disp(d);
disp(e);
   

time2=clock;
disp(etime(time2,time1));