function [twav]=t_wav(x,a_twav,d_twav,t_twav,li)
l=li;
a=a_twav;
x=x-t_twav-0.045;
b=(2*l)/d_twav;
n=100;
t1=1/l;
t2=0;
for i = 1:n
    harm2=(((sin((pi/(2*b))*(b-(2*i))))/(b-(2*i))+(sin((pi/(2*b))*(b+(2*i))))/(b+(2*i)))*(2/pi))*cos((i*pi*x)/l);             
    t2=t2+harm2;
end
twav1=t1+t2;
twav=a*twav1;


