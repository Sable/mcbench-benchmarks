% undo(n=1) removes the last n figure items added

function undo(n)

if nargin==0 n=1; end
if ischar(n) n = sscanf(n,'%i'); end

if n<1 error(['Not undoing ' int2str(n) ' items']); end
g=get(gca,'children');
L=length(g);
for i=1:n
	delete(g(i));
end
