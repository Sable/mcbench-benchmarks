clc
clear
load response.mat acc
   dt=0.001;
  
    %nl=input('‘Î…˘ÀÆ∆Ω  ');
    nl=5;
    n=4;
    % Add measurement noise
    % % calculate the rms of all measurements
    ll=length(acc(:,1));
    for i=1:n
    noise=randn(ll,1);
    accn(:,i)=acc(:,i)+nl/100*std(acc(:,i))*noise;
    end;

    acc=accn;
   
   
   filter_order = 6;
   filter_cutoff =50;    
   [filt_num,filt_den] = butter(filter_order,filter_cutoff*2*dt);
   Nt=length(acc);
   Nt2=Nt+2*filter_order;
   ff= filter(filt_num,filt_den,acc);
   ff= ff(Nt2-Nt+1:end,:);
   plot(acc(:,2))
   hold
   plot(ff(:,2),'r')
   
   acc=ff;
   save response.mat acc
   
   
   
   