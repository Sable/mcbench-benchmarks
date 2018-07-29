function google(varargin)

%GOOGLE Searches in Google in different search areas (images, groups, etc.)
%
% SYNTAX
%
% google(text)
% google(text,'search_area')
% google(text,'search_area',param,value,...)
%
% DISCRIPTION
%
%        text: User entered text to search for.
%
%        search_area: If not specified, then the default is 'web'.
%              Can be one of the following:
%              'web': Searches the web.
%              'images':   Searches Google Images.
%              'groups':   Searches Google Groups.
%              'news':     Searches Google News.
%              'froogle':  Searches Froogle.
%              'scholar':  Searches Google Scholar.
%              'catalogs': Searches Google Catalogs.
%              if it starts with '+', then it will turn the option of (I'm
%              Feeling Lucky!) on!
%
%        param: Can be one of the following:
%              'pages':
%              'lang':
%              'ext':
%
% USER CONFIGURABLE OPTIONS
%  
%       Possible param/value options are:
%           'pages' - search in pages of specific language.  Can be: 
%                   'ar'	Arabic
%                   'bg'	Bulgarian
%                   'ca'	Catalan
%                   'zh-CN'	Chinese (Simplified)
%                   'zh-TW'	Chinese (Traditional)
%                   'hr'	Croatian
%                   'cs'	Czech
%                   'da'	Danish
%                   'nl'	Dutch
%                   'en'	English
%                   'et'	Estonian
%                   'fi'	Finnish
%                   'fr'	French
%                   'de'	German
%                   'el'	Greek
%                   'iw'	Hebrew
%                   'hu'	Hungarian
%                   'is'	Icelandic
%                   'id'	Indonesian
%                   'it'	Italian
%                   'ja'	Japanese
%                   'ko'	Korean
%                   'lv'	Latvian
%                   'lt'	Lithuanian
%                   'no'	Norwegian
%                   'pl'	Polish
%                   'pt'	Portuguese
%                   'ro'	Romanian
%                   'ru'	Russian
%                   'sr'	Serbian
%                   'sk'	Slovak
%                   'sl'	Slovenian
%                   'es'	Spanish
%                   'sv'	Swedish
%                   'tr'	Turkish
%
%           'lang' - google page language.  Can be one of the above.
%           'ext' - (country domain extension) 
%                   (ex, 'ae','us','uk','br','it','fr','mx','nl',... etc)
%
% Examples:
% 
%       google('Nasa Shuttle')
%       google('Nasa Shuttle','News')
%       google('free download','web')
%       google('free download','+web')
%       google('simpsons','images')
%       google('simpsons','images','pages','se')
%       google('Nasa Shuttle','web','ext','AE')
%       google('Nasa Shuttle','web','lang','fr')
%       google('Nasa Shuttle','web','lang','fr','pages','fr','ext','FR')
%
%   Copyright 2004 Fahad Al Mahmood
%   Version: 1.0 $  $Date: 13-Dec-2004
%            1.5 $  $Date: 22-Dec-2004


operator=varargin{1};

if length(varargin)==1
    web(['http://www.google.com/search?&q=' operator], '-browser');
else
    opt = varargin{2};
    
    % (I'm Feeling Lucky) Option
    if strcmpi(opt(1),'+')
        operator = [operator '&btnI=1'];
        varargin{2}=opt(2:end);
    end
    
    if length(varargin)>2
        opt_pairs = (length(varargin)-2)/2;
        for i=1:opt_pairs
            if strcmpi(varargin{2*i+1},'pages')
                operator=[operator '&lr=lang_' varargin{2*i+2}];
            elseif strcmpi(varargin{2*i+1},'ext')
                operator=[operator '&cr=country' upper(varargin{2*i+2})];
            elseif strcmpi(varargin{2*i+1},'lang')
                operator=[operator '&hl=' varargin{2*i+2}];
            end
        end
    end
        
    
    if strcmpi(varargin{2},'images')
        web(['http://images.google.com/images?q=' operator], '-browser');
    elseif strcmpi(varargin{2},'groups')
        web(['http://groups.google.com/groups?q=' operator], '-browser');
    elseif strcmpi(varargin{2},'web')
        web(['http://www.google.com/search?q=' operator], '-browser');
    elseif strcmpi(varargin{2},'news')
        web(['http://news.google.com/news?q=' operator], '-browser');
    elseif strcmpi(varargin{2},'froogle')
        web(['http://froogle.google.com/froogle?q=' operator], '-browser');
    elseif strcmpi(varargin{2},'scholar')
        web(['http://scholar.google.com/scholar?q=' operator], '-browser');
    elseif strcmpi(varargin{2},'catalogs')
        web(['http://catalogs.google.com/catalogs?q=' operator], '-browser');        
    else
        error(['(' varargin{2} ') is an Unknown Option!'])
    end
end
