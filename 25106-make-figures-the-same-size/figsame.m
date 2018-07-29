% FIGSAME Makes figures the same size
%
%   FIGSAME         Resizes all figures to be the size of gcf
%   FIGSAME(f1)     Resizes all figures to be the size as figure f1
%   FIGSAME(f1,f2)  Resizes figure(s) specified by vector f2 to be the same
%                   size as f1

function figsame(f1,f2)

if ~exist('f1','var')
    f1 = gcf;
end

if ~exist('f2','var')
    f2 = get(0,'children');
end

if ~isscalar(f1) || ~isvector(f2)
    error('Usage: figsamesize(f1 (scalar),f2 (vector))')
end

figure(f1);
figsiz = get(gcf,'Position');
newfigpos = figsiz;
scrn = get(0,'screensize');

n = 20; %Shift by 20 pixels
for k = [f2(:)]'
    figure(k);
    newfigpos = newfigpos+[n -n 0 0];
    
    % Make sure we don't push it off the screen...
    if newfigpos*[1;0;1;0] > scrn(3)
        newfigpos(1) = 1;
    end
    newfigpos(2) = max(newfigpos(2), 1);
    
    set(gcf,'Position',newfigpos);
end