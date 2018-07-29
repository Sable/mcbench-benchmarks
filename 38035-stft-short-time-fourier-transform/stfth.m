function X=stfth(x,wl)
disp('Qverlooping of window is 50%');
disp('1 Rectangular Window, 2 Hamming window,  3 Hanning window');
window=input('Enter your choice');
L=length(x);
if L<wl
    z=wl-L;
    x=[x,zeros(1,z)];
end
switch window  % Window functions are (all =0 outside the interval 0<=n<=wl)
    case 1
        win=ones(1,wl); % Rectangular Window
    case 2
        win=hamming(wl)'; % Hanning window w[n]=0.5-0.5*cos(2*pi*n/M), for 0<=n<=M
    case 3
        win=hann(wl)';  % Hamming window w[n]=0.54-.46*cos(2*pi*n/M) for 0<=n<=M
    otherwise
        win=ones(1,window_length);
        disp('Not a right option, By default rectangular window is taken.');
end

L=length(x);
hop=ceil(wl/2);  % Hoop size of window
if hop<1
    hop=wl;
end
i=1;str=1; len=wl; X=[];
while (len<=L || i<2) 
    if i==1
    if  len>L   % If window size excceds the L of signal for 1st time
        z=len-L;
        x=[x,zeros(1,z)]; % padding zeros
        i=1+1;
    end
    x1=x(str:len);
    X=[X;fft(x1.*win)];  % Matrix mul
    str=str+hop; len=str+wl-1; % to make window overlapping
        end
    end
figure,subplot(2,1,1)
imagesc(abs(X)); title('Result by imagesc function')

subplot(2,1,2)
surf(abs(X)); title('Result by surf function')



        
