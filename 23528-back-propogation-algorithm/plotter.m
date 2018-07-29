
clear all;
clc

a=dlmread('plot1inv');
b=dlmread('plot1out');
ain=dlmread('plot1in');
[ar,ac]=size(a);

load weightmatrix W B;
load norms m v no l;
f=3;

for i=1:no(1)
    a(i,:)=(a(i,:)-m(i))/v(i);
    ain(i,:)=(ain(i,:)-m(i))/v(i);
end;

for c=1:ac
    for i=1:no(1)
        Y(i,1)=a(i,c);
        V(i,1)=a(i,c);
    end

    for k=1:l-2
        for j=1:no(k+1)
            w=W(1:no(k),j,k);
            y=Y(1:no(k),k);
            V(j,k+1)=y'*w;
            Y(j,k+1)=logsig(V(j,k+1)-B(j,k+1));
        end
    end

    k=l-1;
    for j=1:no(l)
        w=W(1:no(k),j,k);
        y=Y(1:no(k),k);
        V(j,l)=y'*w;
        Y(j,l)=purelin(V(j,l)-B(j,l));
        O(j,c)=Y(j,l);
    end
end

figure;
plot(ain(f,:),b(1,:),'-*gre',a(f,:),O(1,:),'blu-');
xlabel('Normalized Stub Length'),ylabel('Real S(1,1)');
legend('Actual Plot','Obtained Curve');
figure;
plot(ain(f,:),b(2,:),'-*gre',a(f,:),O(2,:),'blu-');
xlabel('Normalized Stub Length'),ylabel('Imag S(1,1)');
legend('Actual Plot','Obtained Curve');



