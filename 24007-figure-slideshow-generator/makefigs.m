function makefigs(n)

if nargin < 1, n= 5; end

for i= 1 : n
   fig(0.3, 0.3, 'BackgroundColor',RGB(i));
end

end
