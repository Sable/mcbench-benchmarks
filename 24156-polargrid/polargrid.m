function polargrid(hax,nr,nth,style)

%POLARGRID  Polar grid lines.
%   POLARGRID(HAX,NR,NTH,STYLE) adds grid lnes to axes 
%     HAX (default is current axes).  
%     NR is the number of subdivisions in the radial 
%      direction (default is 10)
%     NTH is the number of subdivisions in theta
%      (default is 12, giving lines at THETA=0,30,60,... deg
%     STYLE is a string for the linestyle of the grid lines
%      (default='k:') 

if nargin<1 | isempty(hax),
	hax=gca;
end
if nargin<2, nr = 10; end
if nargin<3, nth= 12; end
if nargin<4, style='k:'; end

xlim=get(hax,'xlim');
ylim=get(hax,'ylim');

% maximum radius to plot
maxr = sqrt(max(abs(xlim))^2+max(abs(ylim))^2);

r = linspace(0,maxr,nr);
th = linspace(0,2*pi,nth+1); th(end)=[];

hold on;
% plot radial lines
polar(hax,kron(th,ones(1,10*nr)),kron(ones(1,length(th)),linspace(0,maxr,10*nr)),style);
% plot circles
polar(hax,kron(ones(1,length(r)),linspace(0,2*pi,10*nth)),kron(r,ones(1,10*nth)),style);
hold off;

% reset xlim,ylim
set(hax,'xlim',xlim);
set(hax,'ylim',ylim);
