% ------------------------GOLDEN SECTION METHOD----------------------------
% -------------------------------------------------------------------------
% Copyright (c) 2009, Katarzyna Zarnowiec, all rights reserved 
% mailto: katarzyna.zarnowiec@gmail.com
% -------------------------------------------------------------------------

figure; hold on;

a=0;                            % start of interval
b=2;                            % end of interval
epsilon=0.000001;               % accuracy value
iter= 50;                       % maximum number of iterations
tau=double((sqrt(5)-1)/2);      % golden proportion coefficient, around 0.618
k=0;                            % number of iterations


x1=a+(1-tau)*(b-a);             % computing x values
x2=a+tau*(b-a);

f_x1=f(x1);                     % computing values in x points
f_x2=f(x2);

plot(x1,f_x1,'rx')              % plotting x
plot(x2,f_x2,'rx')

while ((abs(b-a)>epsilon) && (k<iter))
    k=k+1;
    if(f_x1<f_x2)
        b=x2;
        x2=x1;
        x1=a+(1-tau)*(b-a);
        
        f_x1=f(x1);
        f_x2=f(x2);
        
        plot(x1,f_x1,'rx');
    else
        a=x1;
        x1=x2;
        x2=a+tau*(b-a);
        
        f_x1=f(x1);
        f_x2=f(x2);
        
        plot(x2,f_x2,'rx')
    end
    
    k=k+1;
end


% chooses minimum point
if(f_x1<f_x2)
    sprintf('x_min=%f', x1)
    sprintf('f(x_min)=%f ', f_x1)
    plot(x1,f_x1,'ro')
else
    sprintf('x_min=%f', x2)
    sprintf('f(x_min)=%f ', f_x2)
    plot(x2,f_x2,'ro')
end

