function [position,velocity]=update_v_p(D,N,c1,c2,w,p_best,g_best,position,velocity,v_max,Gl_Lo_flag)
if Gl_Lo_flag==1
    for i=1:N
        temp(i,:)=g_best-position(i,:); %#ok<AGROW>
    end
    velocity=w*velocity+c1*rand*(p_best-position)+c2*rand*temp;   %  For global model
else
    velocity=w*velocity+c1*rand*(p_best-position)+c2*rand*(g_best-position); % For loval model
end
for d=1:D
    for n=1:N
        if velocity(n,d)>v_max
           velocity(n,d)=v_max;
        elseif velocity(n,d)<-v_max
           velocity(n,d)=-v_max;
        end
    end
end
pro_velocity=abs(2*(logsig(velocity)-0.5));
for n=1:N
    for d=1:D
        if rand<pro_velocity(n,d)
            position(n,d)=xor(position(n,d),1);
        else
            position(n,d)=position(n,d);
        end
    end
end
return