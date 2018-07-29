function [ X,h,R ] = generate_test_data(~)
% GENERATE_TEST_DATA creates a sample data set for demonstration of the 
% Abel inversion algorithm. Based on the density distribution f 
% (polynomial function), the virtual measurement result h is calculated 
% via Abel transform:
%
%           h(x) = 2* int_x^R f(r)*r/sqrt(r^2-x^2) dr                  (1)
%
%
%                                         written by C. Killer, Sept. 2013

R=3;                        % radius
X=(0:0.01:R-0.01)';         % spatial coordinates

%polynomial distribution function
f= (17.*(X./R).^4-32.*(X./R).^3+14.*(X./R).^2+1); 

h=zeros(length(X),1);    % allocate result vector

for c=1:length(X) 
    x=X(c);
    % evaluate Abel-transform equation (1)
    fun = @(r) (17.*(r./R).^4-32.*(r./R).^3+14.*(r./R).^2+1).*r./sqrt(r.^2 - x.^2);
    h(c,1)=2*integral(fun,x,R);      
end


figure; 
plot(X,f./max(f),'k','Linewidth',1.5); 
hold on; 
plot(X,h./max(h),'b','Linewidth',1.5); 
grid on; box on; 
legend('initial density distribution f(r)','measurement result h(r) (Abel-Transform of f(r))','Location','SouthWest')
title('example with polynomial data sample (normalized for better comparison)')

