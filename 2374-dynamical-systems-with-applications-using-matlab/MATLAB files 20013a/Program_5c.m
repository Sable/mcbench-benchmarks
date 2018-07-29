% Chapter 5 - Fractals and Multifractals.
% Program_5c - An Iterated Function System.
% Copyright Birkhauser 2013. Stephen Lynch.

% Barnsley's fern (Figure 5.7).
function Program_5c(~)
% This function plots Barnsley's fern with N points.
% The transformations are in the form
% T(x,y) = (a*x+b*y+c, d*x+e*y+f). 
echo on
N=50000;
close all
P=zeros(N,2);
P(1,:)=[0.5,0.5];  

% The main loop where the iterations are performed.
for k=1:N-1
	r=rand;
	if r<.05;
		P(k+1,:)=T(P(k,:),0,0,0,0,.2,0);
	elseif r<.86;
		P(k+1,:)=T(P(k,:),.85,.05,0,-.04,.85,1.6);
	elseif r<.93;
		P(k+1,:)=T(P(k,:),.2,-.26,0,.23,.22,1.6);
	else
		P(k+1,:)=T(P(k,:),-.15,.28,0,.26,.24,.44);
	end
end

plot(P(:,1),P(:,2),'.','MarkerSize',1);
axis([-2.5 3.5 0 11]);
set(gca,'Position',[0 0 1 1])

% The transformation T
function F=T(P,a,b,c,d,e,f)
F=zeros(1,2);
F(1)=a*P(1)+b*P(2)+c;
F(2)=d*P(1)+e*P(2)+f;

% End of Program_5c.