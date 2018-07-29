% gradient descent function in the meaning of least squares
% this example fits to straight line case only 
% y =ax+b
%  min(sum(h(a,b,x)-y).^2)
% v=[a,b]
% v(n+1)= v(n)-alpha*((d/dv)h(v))   % go in direction of gradient
% v(n+1)  = v(n)-alpha*(h(v)-y)'*x
% ---------------------
% inputs
%
%
%
%
function [theta_out,err_vec,theta_vec] = gradient_descent_opt(xi,yi,theta_st,nsteps,mindiff,learnrate)

 theta_out=theta_st';
 theta_new=zeros(size(theta_out));

 err_vec=[];
 theta_vec=[theta_out];

 xii = [ones(length(xi),1) xi];
 % number of iterations
 for ind=1:nsteps
 
     % hypothesis estimation
     hth=compute_hypoth(theta_out,xi);
     
     err=sum(abs(hth-yi));
    err_vec = [err_vec err];
     
    theta_new=theta_out-(learnrate*(hth-yi)'*xii)';
     %theta_new=theta_out-learnrate*(hth-yi)*xi';
%      theta_new(1) = theta_out(1)-learnrate*sum(hth-yi);
%      theta_new(2)=theta_out(2)-learnrate*(hth-yi)'*xi;
     
     
     theta_vec = [theta_vec  theta_new];
     %change in theta below min  change
     if(abs(theta_new-theta_out)<=mindiff)
          theta_out=theta_new;
          break;
     end
     
     theta_out=theta_new;
end




     % hypothesis estimation
    function [hth] =    compute_hypoth(th,x)
        hth=th(1)+th(2)*x;
    end

end
