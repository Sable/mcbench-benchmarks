function ebay(varargin)
	
	query = reshape(transpose([strvcat(varargin{:}),[repmat('+',size(strvcat(varargin{:}),1)-1,1);' ']]),1,[]);
	
	url = ['''http://shop.ebay.com/?_nkw=',query,''''];
	
	url(url==' ') = [];
	
	eval(['web ', url ,' -browser'])
	
end