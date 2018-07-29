%%%% discretization of direct space, to be used for plotting the field
%%%% distribution; X,Y = vectors to be used for FFT; Xi,Yi = vectors to be
%%%% used for interpolation
function [X,Y,Xi,Yi]=prcellgrid(a1,a2,N1,N2)
X=[]; Y=[]; %spatial coordinates after FFT 
for l=1:N1
    for m=1:N2
        X(l,m)=(l-1-(N1-1)/2)*a1(1)/N1 + (m-1-(N2-1)/2)*a2(1)/N2;
        Y(l,m)=(l-1-(N1-1)/2)*a1(2)/N1 + (m-1-(N2-1)/2)*a2(2)/N2;  
    end
end

M=501; 
Xi=[]; Yi=[]; %finer discretization for field interpolation
for l=1:M
    for m=1:M
        Xi(l,m)=(l-1-(M-1)/2)*a1(1)/M + (m-1-(M-1)/2)*a2(1)/M;
        Yi(l,m)=(l-1-(M-1)/2)*a1(2)/M + (m-1-(M-1)/2)*a2(2)/M;  
    end
end
