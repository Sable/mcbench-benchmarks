function gamefaqs(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://www.gamefaqs.com/search/index.html?game=',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end