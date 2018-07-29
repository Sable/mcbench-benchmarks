function flickr(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://www.flickr.com/search/?q=',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end