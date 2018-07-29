function [] = bihist(x1,x2,n)
% BIHIST(X1,X2,N) open a new figure an plot a back to back histogram 
% X1: variable 1 (right side, colour blue) 
% X2: variable 2 (right side, colour green) 
% n : number of classes for each histogramm

% make two dummy-histogram 
[temp, d1] = hist(x1,n);  %#ok<ASGLU> 
[temp, d2] = hist(x2,n);  %#ok<ASGLU>
clear temp 
% calculate classes 
d = min([d1 d2]):((max([d1 d2])-min([d1 d2]))/(n-1)) : max([d1 d2]); 
% create the two histograms 
templ = hist(x1,d); 
tempr = hist(x2,d); 
% scaling the histograms 
templ=templ*-1; 
% create bar plot 
left=barh(templ,'style','hist'); 
hold on
right = barh(tempr,'style','hist'); 
plot([0 0], [1 n],'k') 
% change color of left histogram 
set(left,'FaceColor',[0 0 1]); 
% change color of right histogram 
set(right,'FaceColor',[0 1 0]); 
% distance factor to frame
dt=1.2; 
xlim([-max(abs([templ tempr]))*dt max(abs([templ tempr]))*dt]) 
% mark the y-axis 
yl = get(gca,'YTick'); 
b = (max(d)-min(d))/(n-1); 
a = max(d)-b*n; 
yl2 = yl*b+a; 
ds = cell(size(yl2)); 
for k=1:length(yl2)
    ds{k} = num2str(yl2(k),3); 
end 
set(gca,'YTickLabel',ds) 

% rewrite the x-axis with positiv values
xl = get(gca,'XTickLabel'); 
xl = regexprep(cellstr(xl),'-','');
set(gca,'XTickLabel',regexprep(cellstr(xl),'-','')) 


