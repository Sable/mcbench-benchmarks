function delay=delayest_3point(u2,u1,method,estimator,parameter);
%delay=delayest_3point(u2,u1,method,estimator,parameter);
%Estimates delay of u2 wrt u1 by interpolating the peak of the cross correlatio
%using a three-point peak interpolation
%method may be 'parabola','Gaussian','modGaussian','cosine'.
%estimator may be 'xcorr','ASDF','AMDF' (AMDF is very slow).
%if using modGaussian, parameter is a bias (always used if >=0, only used
%for xc<0 for parameter < 0)

if nargin<3
    method='parabola';
end

if nargin<4
    estimator='xcorr';
end

if nargin<5
    switch method
        case {'modGaussian','modgaussian'}
            parameter=1;
    end
end


N_p=numel(u2);%number of elements



switch estimator
    case {'xcorr','xc','xcorr_fft'}%cross correlation
        U1=fft(u1);
        U2=fft(u2);
        xc=ifft(U2.*conj(U1));%circular xcorr
        [tmp idx]=max(xc);
    case {'ASDF'}%average squared difference function
         xc = (-2*ifft(fft(u2).*conj(fft(u1))) + sum(u1.^2) + sum(u2.^2))/N_p;%ADSF
        [tmp idx]=min(xc);
    case {'AMDF'}%average magnitude difference function (this is a lot slower for large N_p)
        xc=sum(abs(repmat(u1',1,N_p)-hankel(u2',[u2(end)'; u2(1:(end-1))'])))/N_p;%AMDF
        [tmp idx]=min(xc);
end


R=zeros(1,3);%three points to use for interpolation
R(2)=xc(idx);%peak

%find neighbors, assuming periodic
if idx==1
    R(1)=xc(end);
    R(3)=xc(2);
elseif idx==numel(xc)
    R(1)=xc(end-1);
    R(3)=xc(1);
else
    R(1)=xc(idx-1);
    R(3)=xc(idx+1);
end


switch method
    case {'Gaussian','gaussian'}
        %a=exp(log(R(2))+(log(R(3))-log(R(1)))^2/(16*log(R(2))-8*log(R(1))-8*log(R(3))));%peak value
        %b=(2*log(R(2))-log(R(1))-log(R(3)))/2;%width
        c=(log(R(3))-log(R(1)))/(4*log(R(2))-2*log(R(1))-2*log(R(3)));
    case {'parabola','parabolic'}
    	%A=inv([1 -1 1;0 0 1;1 1 1])*R';
        %c=-A(2)/(2*A(1));
        %a=-1/4*A(2)^2/A(1)+A(3);%peak value
        c=(R(3)-R(1))/(2*(2*R(2)-R(1)-R(3)));
    case {'modGaussian','modgaussian'}
        if parameter>=0%always add bias
            R=R-min(R)+parameter*R(2);
        else%only add bias if R has a negative value
            if any(R<=0)
                R=R-min(R)-parameter*R(2);
            end
        end
        %a=exp(log(R(2))+(log(R(3))-log(R(1)))^2/(16*log(R(2))-8*log(R(1))-8*log(R(3))));
        %b=(2*log(R(2))-log(R(1))-log(R(3)))/2;
        c=(log(R(3))-log(R(1)))/(4*log(R(2))-2*log(R(1))-2*log(R(3)));
    case {'cosine'}
        omega=acos((R(1)+R(3))/(2*R(2)));
        theta=atan((R(1)-R(3))/(2*R(2)*sin(omega)));
        %A=R(2)/cos(theta);
        c=-theta/omega;
    otherwise
        error('unknown method')
end

lag=mod(idx-1+floor(N_p/2),N_p)-floor(N_p/2);%integer part
delay=lag+c;%delay estimate
