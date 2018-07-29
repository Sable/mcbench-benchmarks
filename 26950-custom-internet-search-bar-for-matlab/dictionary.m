function dictionary(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://dictionary.reference.com/browse/',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end