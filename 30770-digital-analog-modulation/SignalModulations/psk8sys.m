function psk8sys(bin,f)
clc;
disp('PSK8SYS Written by Nguyen Hoang Minh DHCNTPHCM. he..he..');
bin = [0 0 0 0 0 1 0 1 0 0 1 1 1 0 0 1 0 1 1 1 0 1 1 1];f=2;
L=length(bin);k=50;%t=0:2*pi/149:2*pi;length(t)
bit1=ones(1,k);bit0=0*bit1;symbol=ones(1,3*k);mbit=[];mx=[];my=[];

if 3*fix(L/3)~=L
    error('DO DAI CUA CHUOI BIN PHAI LA BOI SO CUA 3');
    disp('Example: psk8sys([0 0 0 0 0 1 0 1 0 0 1 1 1 0 0 1 0 1 1 1 0 1 1 1],10)');
end
%============== Dieu che & du lieu  ======================================
for n=1:3:L
    if bin(n)==0 && bin(n+1)==0 && bin(n+2)==0
       x=-1/sqrt(2)*symbol;y=-1/sqrt(2)*symbol; bit=[bit0 bit0 bit0];
   elseif bin(n)==0 && bin(n+1)==0 && bin(n+2)==1
       x=-symbol;y=0*symbol; bit=[bit0 bit0 bit1];
   elseif bin(n)==0 && bin(n+1)==1 && bin(n+2)==0
       x=0*symbol;y=symbol; bit=[bit0 bit1 bit0];
   elseif bin(n)==0 && bin(n+1)==1 && bin(n+2)==1
       x=-1/sqrt(2)*symbol;y=1/sqrt(2)*symbol; bit=[bit0 bit1 bit1];
   
    elseif bin(n)==1 && bin(n+1)==0 && bin(n+2)==0
       x=0*symbol;y=-symbol; bit=[bit1 bit0 bit0];
   elseif bin(n)==1 && bin(n+1)==0 && bin(n+2)==1
       x=1/sqrt(2)*symbol;y=-1/sqrt(2)*symbol; bit=[bit1 bit0 bit1];
   elseif bin(n)==1 && bin(n+1)==1 && bin(n+2)==0
       x=1/sqrt(2)*symbol;y=1/sqrt(2)*symbol; bit=[bit1 bit1 bit0];
   elseif bin(n)==1 && bin(n+1)==1 && bin(n+2)==1
       x=symbol;y=0*symbol; bit=[bit1 bit1 bit1];    
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
for m=1.5*k:3*k:M
        if -1<Hx(m) && Hx(m)<-0.25
            if -1<Hy(m) && Hy(m)<-0.25
                deb = [bit0 bit0 bit0];
            elseif 0.25<Hy(m) && Hy(m)<1
                 deb = [bit0 bit1 bit1];
            elseif -0.25<Hy(m) && Hy(m)<0.25
                 deb = [bit0 bit0 bit1];
            end
          
        elseif -0.25<Hx(m) && Hx(m)<0.25
            if  0.25<Hy(m) && Hy(m)<1
                deb = [bit0 bit1 bit0];
            elseif -1<Hy(m) && Hy(m)<-0.25
                deb = [bit1 bit0 bit0];
            end
        
        elseif 0.25<Hx(m) && Hx(m)<1 
            if -1<Hy(m) && Hy(m)<-0.25
                 deb = [bit1 bit0 bit1];
            elseif 0.25<Hy(m) && Hy(m)<1
                 deb = [bit1 bit1 bit0];
            elseif -0.25<Hy(m) && Hy(m)<0.25
                deb = [bit1 bit1 bit1];
            end;   
        end;
mdeb=[mdeb deb];
end
%============== Do thi minh hoa dang song ================================
figure(1);
subplot(4,1,1);plot(mbit,'r','linewidth',2);axis([0  k*L -0.5 1.5]);grid on;legend('Data in');
subplot(4,1,2);plot(qam,'m','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('8PSK mod ');
subplot(4,1,3);plot(Vn,'g','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('8PSK mod add AWGN');
subplot(4,1,4);plot(mdeb,'k','linewidth',1.5);axis([0  k*L -0.5 1.5]);grid on;legend('8PSK demod');
figure(2)
subplot(2,1,1);plot(Hx,'g','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('Horizontal Synchronous Xcos Wave');
subplot(2,1,2);plot(Hy,'m','linewidth',1.5);axis([0  k*L -2.5 2.5]);grid on;legend('Vertical Synchronus Ycos Wave');    
end