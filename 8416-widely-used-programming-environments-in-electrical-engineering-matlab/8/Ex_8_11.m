clear
        % Incarcarea datelor din tabel
I=0:0.5:5;
x=linspace(0,pi,length(I));
for k=1:length(I)
    yy=3*I(k)*sin(x);
    y(:,k)=yy';
end
        % Incarcarea tabelului de cautare
tab=zeros(12);
tab(2:12,1)=x';
tab(1,2:12)=I;
tab(2:12,2:12)=y;
        % Cautarea in tabel
a=table2(tab,pi/10,1)
b=table2(tab,0.5,0.75)
