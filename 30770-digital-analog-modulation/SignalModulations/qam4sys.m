function qam4sys(bin,f)
disp('QAM4SYS Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
disp('Example: qam4sys([0 0 1 1 0 1 1 0 1 0 1 1],10)');
%bin = [0 0 1 1 0 1 1 0 1 0 1 0];f=10;
L=length(bin);k=100;%t=0:2*pi/99:2*pi;
bit1=ones(1,k);bit0=0*bit1;symbol=ones(1,2*k);mbit=[];mx=[];my=[];

if 2*round(L/2)~=L
    error('DO DAI CUA CHUOI "BIN" LA CHAN');
end
%============== Dieu che & du lieu  ======================================
for n=1:2:L
    if bin(n)==0 && bin(n+1)==0
       x=symbol;y=0*symbol; bit=[bit0 bit0];
   elseif bin(n)==0 && bin(n+1)==1
       x=-1*symbol;y=0*symbol; bit=[bit0 bit1];
   elseif bin(n)==1 && bin(n+1)==0
      x=2*symbol;y=0*symbol; bit=[bit1 bit0];    
   elseif bin(n)==1 && bin(n+1)==1
       x=-2*symbol;y=0*symbol; bit=[bit1 bit1]; 
    end
    mbit=[mbit bit];mx=[mx x];my=[my y];
end
v=0:2*pi/k:2*pi*L-2*pi/k;msync = mx+my*j;

qam =  real(msync).*cos(f*v)+imag(msync).*sin(f*v);
%============== Kenh truyen  =============================================
Vn=awgn(qam,10,'measured');
Vnx=Vn.*cos(f*v);Vny=Vn.*sin(f*v);
[b,a]=butter(2,0.04);
%============== Giai dieu che ============================================
Hx=filter(b,a,Vnx);Hy=filter(b,a,Vny);M=length(Hx);mdeb=[];
for m=k:2*k:M
    if 0<Hx(m)&& Hx(m)<0.7
        deb=[bit0 bit0];
    elseif 0.7<Hx(m) && Hx(m) <1.5
        deb=[bit1 bit0];
    elseif -0.6<Hx(m) && Hx(m) <0
        deb=[bit0 bit1];
    elseif -1.5<Hx(m) && Hx(m) <-0.7
        deb=[bit1 bit1];  
end
mdeb=[mdeb deb];
end
%============== Do thi minh hoa dang song ================================
figure(1);
subplot(4,1,1);plot(mbit,'r','linewidth',2);axis([0  k*L -0.5 1.5]);grid on;legend('Data in');
subplot(4,1,2);plot(qam,'m','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('QAM mod ');
subplot(4,1,3);plot(Vn,'g','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('QAM mod & AWGN');
subplot(4,1,4);plot(mdeb,'k','linewidth',1.5);axis([0  k*L -0.5 1.5]);grid on;legend('QAM demod');
figure(2)
subplot(2,1,1);plot(Hx,'g','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('Horizontal Synchronous Xcos Wave');
subplot(2,1,2);plot(Hy,'m','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('Vertical Synchronus Ycos Wave');    