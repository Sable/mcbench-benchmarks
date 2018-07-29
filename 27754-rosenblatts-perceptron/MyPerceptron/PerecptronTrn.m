function [w,b,pass]=PerecptronTrn(x,y);
% %Rosenblatt's Perecptron
tic
[l,p]=size(x);
w=zeros(p,1); % initialize weights
b=0;          % initialize bias
ier=1;        % initialize a misclassification indicator
pass=0;       % number of iterations
n=0.5;        % learning rate
r=max(sqrt(sum(x))); % max norm
while ier==1, %repeat until no error
       ier=0; 
       e=0; % number of training errors
       for i=1:l  % a pass through x           
           xx=x(i,:);
           ey=xx*w+b; % estimated y
           if ey>=0.5
              ey=1;
           else
              ey=0;
           end
           if y(i)~=ey;
              er=y(i)-ey; % error difference
              w=w'+(er*n)*x(i,:); % the only rule works for me
              %w=w'+(n*y(i))*(x(i,:)); % don't know why itdoes npt work              
              %b=b-n*y(i)*(r^2);       % don't know why itdoes npt work               
              e=e+1 ; % number of training errors
              w=w';   
           end;
       end;  
       ee=e;    % number of training errors
       if ee>0  % cuntinue if there is still errors
          ier=1;           
       end
       pass=pass+1; % stop after 10000 iterations
       if pass==10000
          ier=0;
          pass=0;
       end;
 end;
disp(['Training_Errors=' num2str(e) '     Training data Size=' num2str(l)])
toc

 