function metacritic(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://www.metacritic.com/search/process?sb=0&tfs=all&ts=',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end