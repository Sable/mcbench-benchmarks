function imdb(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://www.imdb.com/find?s=all&q=',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end