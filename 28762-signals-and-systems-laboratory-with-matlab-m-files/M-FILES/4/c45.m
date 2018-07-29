% book : Signals and Systems Laboratory with MATLAB  
% authors : Alex Palamides & Anastasia Veloni
% 
% 
% 
% stability

 syms t
 h=exp(-t.^2);
 int(abs(h),t,-inf,inf)

 t=-10:.1:10;
 x1=ones(size(t));
 h=exp(-t.^2);
 y1=conv(x1,h)*0.1;
 plot(-20:.1:20,y1)
 title('System response to u(t+10)-u(t-10)')

