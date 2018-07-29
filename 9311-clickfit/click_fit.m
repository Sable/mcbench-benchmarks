%This code allows the user to enter a set of 2-D data points by using the
%mouse. The user can see the points he is choosing plotted instanteneously.
%Finally, a polynomial fit is used to fit a curve for the chosen data.
%Then, the data, and the corresponding fitted points (evaluated at the same
%x-locations) are plotted on the same curve
%
%   Inputs: 
%          nb_data_pts: it is an integer.It is the number of data points
%                       that the user should choose using the mouse.
%
%          order_poly: it is an integer.It defines the order of the
%                      polynomial that is desired to be fitted
%          xmin,xmax,ymin & ymax:define the axis for the figure
%
%   Output:
%         p:a vector that containes the coffecients of the polynomial 
%
%   Example: 
%         [p]=click_fit(10,7,0,10,0,10)

%This function is written by :
%                               Nassim Khaled
%                               Wayne State University
%                               Mechanical Engineering Department
%                               Graduate Research Assistant+Phd Student
%                               Detroit, Michigan
%%%%%%%%Please don't hesitate to use it, and give some feedback to enhance
%it. 




function [p]=click_fit(nb_data_pts,order_poly,xmin,xmax,ymin,ymax)
figure
axis([xmin xmax ymin ymax])
hold on
[x,y]=ginput(1);   
plot(x,y,'ro')
X=[x,y];
for i=2:nb_data_pts
    [x,y]=ginput(1);
    plot(x,y,'ro')
    X=[X;[x,y]];
    plot(X(:,1),X(:,2))
end
    
hold off
x=X(:,1);
y=X(:,2);
% ft_ = fittype('poly5' );
% cf_ = fit(x,y,ft_ );
% cfit(x,y,cf_)
threshold=5/100;       % 5 percent error 
p = polyfit(x,y,order_poly);
y_fit=polyval(p,x);
close all
figure
axis([xmin xmax ymin ymax])
hold on
plot(x,y,'ro')
plot(x,y_fit,'*-')
hold off





