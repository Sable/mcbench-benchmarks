function [y, alpha_out, b_out] = svr(xdata,ydata,x,alpha, b, c, epsilon)
% SVR  Utilises Support Vector Regression to approximate 
%           the functional relationship from which the
%           the training data was generated.
%
%  Note: At this stage only a Wavelet kernel is implemented.
%        Also, on evaluating the SVR model the input data,
%        xdata, is required as this contains the 'support
%        vectors'.
%
%  Function call:
%
%    [y, alpha0,b0] = SVR(xdata,ydata,x,alpha,b,c,epsilon);
%    [~,alpha0,b0] = SVR(xdata,ydata,[],[],[],c,epsilon);
%    y = SVR(xdata,ydata,x,[],[],[],[]);
%    y = SVR(xdata,[],x,alpha,b,[],[]);
%
%  Example usage:
%
%   [X, Y] = meshgrid(linspace(-10,10,15),linspace(-10,10,15));
%   z = (X.^2 - Y.^2).*sin(0.5*X) + randn(15).*10;
%
%   xdata = [reshape(X,15,1) reshape(Y,15,1)]';
%   ydata = [reshape(z,15,1)]';
%
%   [~, alpha0] = svr(xdata,ydata,[],[]);
%   for x=1:15
%        for y=1:15
%            z_approx(x,y) = svr(xdata,[],[X(1,x) Y(y,1)]',alpha0);
%       end
%   end
%
%   subplot(1,2,1)
%   surf(X,Y,z)
%   subplot(1,2,2)
%   surf(X,Y,z_approx)
%
%  Implemented by: Ronnie Clark
%            Date: 09/09/2013
%
%  References:
%
%    [1] Cristianini N. and Shawe-Taylor J. "An introduction to Support 
%        Vector Machines and other kernel - based learning methods", 
%        Cambridge, University Press, 2003
%
%  Disclaimer: If you use this code in commercial or non-commercial
%              software, modify or improve it please reference this 
%              implementation.

ntrain = size(xdata,2);

M = zeros(ntrain);

y = inf;

if size(alpha,1) == 0
    svr_train()
end

if size(x,1) ~= 0
    y = svr_eval(x);
end

alpha_out = alpha;
b_out = b;

function svr_train()
    Aeq = sparse([ones(1,ntrain); zeros(ntrain-1,ntrain)]);
    beq = sparse(zeros(ntrain,1));
    lb = -c*ones(ntrain,1);
    ub = c*ones(ntrain,1);

    alpha0 = zeros(ntrain,1);
    M = zeros(ntrain);
    for l=1:ntrain
        for m=1:ntrain
            M(l,m) = K(xdata(:,l),xdata(:,m));
        end
    end
    M = M + 1/c*eye(ntrain);
    image(M)    
    options = optimoptions('fmincon','Algorithm','interior-point','MaxFunEvals',100000,'TolX',1e-3,'Display','iter');
    %options = gaoptimset('TolFun',1e-10);
    alpha = fmincon(@W, alpha0, [],[],Aeq, beq, lb, ub,[],options); 

    for m=1:ntrain
        bmat(m) = ydata(m);
        for n = 1:ntrain
            bmat(m) = bmat(m) - alpha(n)*M(m,n);
        end
        bmat(m) = bmat(m) - epsilon - alpha(m)/c;
    end
    b = mean(bmat);
end

function f = svr_eval(x)
    f = 0;
    
    for i=1:ntrain
        f = f + alpha(i)*K(x,xdata(:,i));
    end
    f = f + b;
end

function cost = W(alpha)
    cost = 0;
  
    for i=1:ntrain
        cost = cost + alpha(i)*ydata(i) - epsilon*abs(alpha(i));
        for j = 1:ntrain
            cost = cost - 0.5*alpha(i)*alpha(j)*M(i,j);
        end
    end 
    cost = -cost;
end

function uv = K(u,v)
a = 4;
n = size(u);
uv = 1;
    for k=1:n
        uv = uv*cos(1.75*(u(k)-v(k))/a)*exp(-(u(k)-v(k))^2/(2*a^2));
    end
end

end