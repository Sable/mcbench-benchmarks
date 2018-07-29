function thesaurus(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://thesaurus.com/browse/',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end