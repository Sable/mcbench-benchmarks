function newgrounds(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://www.newgrounds.com/portal/search/title/',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end