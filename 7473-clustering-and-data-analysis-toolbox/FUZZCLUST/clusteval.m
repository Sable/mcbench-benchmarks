function eval = clusteval(new,result,param)

v = result.cluster.v;
c = size(result.cluster.v,1);%c = param.c;
if exist('param.m')==1, m = param.m;else m = 2;end;
 
X=new.X;
[N,n] = size(X);
X1 = ones(N,1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
if isfield(result.cluster,'M')%GK
    M = result.cluster.M;
    for j = 1 : c,
        xv = X - X1*v(j,:);
        d(:,j) = sum((xv*M(:,:,j).*xv),2);
    end
    distout=sqrt(d);
    %Update the partition matrix
    d = (d+1e-10).^(-1/(m-1));
    f0 = (d ./ (sum(d,2)*ones(1,c)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif isfield(result.cluster,'P')%GG
    A = result.cluster.P;
    f = result.data.f; 
    fm = f.^m;
    for j = 1 : c,                        
        xv = X - X1*v(j,:);
        Pi(:,:,j)=1/N*sum(fm(:,j));
        A = result.cluster.P(:,:,j);
        d(:,j) = 1/(det(pinv(A))^(1/2))*1/Pi(:,:,j)*exp(1/2*sum((xv*pinv(A).*xv),2));
    end
    distout=sqrt(d);  
    %Update the partition matrix
    if m>1
          d = (d+1e-10).^(-1/(m-1));
      else
          d = (d+1e-10).^(-1);
      end    
    f0 = (d ./ (sum(d,2)*ones(1,c)));

else        %FCM
     for j = 1 : c,
      xv = X - X1*v(j,:);
      d(:,j) = sum((xv*eye(n).*xv),2);
    end;
    distout=sqrt(d);
    d = (d+1e-10).^(-1/(m-1));
    f0 = (d ./ (sum(d,2)*ones(1,c)));
end
%results
    eval.d = distout;
    eval.f = f0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Visualization

if n == 2   %in 2dimensional case draw a contour map
    lower1=min(X(:,1));upper1=max(X(:,1));scale1=(upper1-lower1)/200;
    lower2=min(X(:,2));upper2=max(X(:,2));scale2=(upper2-lower2)/200;
    [x,y] = meshgrid(lower1:scale1:upper1, lower2:scale2:upper2);
    pair = [x(:) y(:)];
    [pair1,pair2] = size(pair);
    X1 = ones(pair1,1);
    d=zeros(pair1,c);  %resize the distance matrix
    
    
    if isfield(result.cluster,'M')%GK
        for j = 1 : c,
            xv = pair - X1*v(j,:);
            d(:,j) = sum((xv*M(:,:,j).*xv),2);
        end
        distout=sqrt(d);
        d = (d+1e-10).^(-1/(m-1));
        f0 = (d ./ (sum(d,2)*ones(1,c)));
        
    elseif isfield(result.cluster,'P')%GG
        for j = 1 : c,                        
            xv = pair - X1*v(j,:);
            Pi(:,:,j)=1/N*sum(fm(:,j));
            A = result.cluster.P(:,:,j);
            d(:,j) = 1/(det(pinv(A))^(1/2))*1/Pi(:,:,j)*exp(1/2*sum((xv*pinv(A).*xv),2));
        end
        distout=sqrt(d);  
        if m>1
            d = (d+1e-10).^(-1/(m-1));
        else
            d = (d+1e-10).^(-1);
        end    
        f0 = (d ./ (sum(d,2)*ones(1,c)));
    else   %FCM
        for i = 1 : c,
            xv = pair - ones(pair1,1)*v(i,:);
            d(:,i)= sum((xv*eye(2).*xv),2);%
        end;
        distout=sqrt(d);
        d = (d+1e-10).^(-1/(m-1));
        f0 = (d ./ (sum(d,2)*ones(1,c)));
    end
    f=max(f0')';
    Z= reshape(f,size(x,1),size(x,2));
    contour(x,y,Z);
    drawnow
end