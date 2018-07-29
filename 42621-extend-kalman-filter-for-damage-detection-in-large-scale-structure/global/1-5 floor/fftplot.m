function [f,y]=fftplot(x,step)

[r,c] = size(x);

if r == 1
	x = x.';   % make it a column
end;

[n,cc] = size(x);

m = 2^nextpow2(n);
y = fft(x,m);
y = y(1:n,:);
yy=abs(y)*step;

fid1=fopen('fft1.txt','w');
fid2=fopen('aft1.txt','w');

for kk=1:m/2+1;
   f(kk)=(kk-1)/m/step;
   fprintf(fid1,'%8.4f\n',f(kk));
   fprintf(fid2,'%8.4f\n',y(kk));

end

fclose(fid1);
fclose(fid2);
y=yy(1:m/2+1);
plot(f,y);
xlabel('Frequency (Hz)');
ylabel('Fourier Amplitude');
%title('Fouier Transform of the Data')

