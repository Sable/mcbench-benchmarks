function [uwav]=u_wav(x,a_uwav,d_uwav,t_uwav,li)
l=li;
a=a_uwav
x=x-t_uwav;
b=(2*l)/d_uwav;
n=100;
u1=1/l
u2=0
for i = 1:n
    harm4=(((sin((pi/(2*b))*(b-(2*i))))/(b-(2*i))+(sin((pi/(2*b))*(b+(2*i))))/(b+(2*i)))*(2/pi))*cos((i*pi*x)/l);             
    u2=u2+harm4;
end
uwav1=u1+u2;
uwav=a*uwav1;
