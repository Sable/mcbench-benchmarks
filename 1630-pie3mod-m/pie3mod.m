function varargout = pie3mod(h)
%PIE3MOD    Remove surface edgecolor from PIE3 plot.
%   H = PIE3MOD(HP) removes the lines along the edges of the pie slices 
%   while guaranteeing that there will still be a line separating the 
%   slices.  The input argument HP is the set of handles returned by 
%   PIE3.  The output argument H is the same as HP with the addition of  
%   the new line objects needed to separate the pie slices.
%
%   Example
%      hpie = pie3([2 4 3 5],{'North','South','East','West'});
%      hpienew = pie3mod(hpie);
%
%   See also PIE3.

%   Uncomment the code at the end of the file to move the slice 
%   labels in the front of the PIE3 plot so that they are beneath 
%   the pie's bottom edge.  You may need to adjust the "thresh"
%   value defined in the code depending on your PIE3 plot.

%   Greg Aloe + Kara Brotman
%   Version 1.0
%   4-24-2002

% start keeping track of the returned list of handles
hnew = h(:);

% remove the lines from the edges of the pie slices 
hs = findobj(h,'type','surface');
set(hs,'edgecolor','none')

% change renderer to zbuffer since the painters 
% algorithm draws this sloppily
if ~isempty(h)
    ha = get(h(1),'parent');
    hf = get(ha,'parent');
    set(hf,'renderer','zbuffer')
end

% redraw the lines between the slices
for n=hs'
    x=get(n,'xdata');
    y=get(n,'ydata');
    z=get(n,'zdata');
    hnew = [hnew; ...
       line([x(2,1) x(2,2)],[y(2,1) y(2,2)],[z(2,1) z(2,2)],'color','k')];
end
    
% return the handles if requested
if nargout > 0
    varargout{1} = hnew;
end

% % If uncommented, this code will move the slice labels in the front
% % of the PIE3 plot so that they are beneath the pie's bottom edge
% 
% ht = findobj(h,'type','text');
% thresh = 0.3;
% for n=ht'
%     pos = get(n,'position');
%     if all(pos(1:2)<thresh)
%         set(n,'position',[pos(1:2) 0])
%     end
% end

    