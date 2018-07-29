function S=wiki(str)
%WIKI Read Wikipedia articles
%   S=wiki(str) returns the Wikipedia article for string 'str'
%
%   S=wiki returns a random Wikipedia article
%
%   For most articles the parsing is done almost correctly, however there
%   may be minor parsing errors that may occur in the output. Suggestions
%   to improve the code and/or parsing are welcome, with contact information
%   in comments.
%
%   The input can be any alpha-numeric character, or symbol, including
%   spaces. Entire input is converted to hexadecimal for Wikipedia to read
%   and interpret. This helps with articles that contain special characters.
%   If a redirect exists the redirected article will be returned.
%
%   If no article is found an error will be given. An article may still
%   exist just the input may be in the wrong format or misspelled. No
%   automatic corrections are attempted.
%
%   The output is formatted to the size of the Command Window such that
%   the article wraps around to the next line, with no word being cut-off.
%
%   For long articles using 'wiki' along with 'more' helps in reading
%
%   EXAMPLES:
%   S=wiki('Mathworks')                     %Entire Article
%   more on, S=wiki('Boston'), more off     %Long Article, using 'more'
%   S=wiki('¿')                             %Inverted Question Mark
%   S=wiki('Partial differential equation') %Spaces Allowed
%   S=wiki                                  %Random article

%   Mike Sheppard
%   Last Modified: 14-Jan-2011




if (exist('str'))&&(~isempty(str))
    %If input exists and is nonempty convert input into hexadecimal for
    %Wikipedia to interpret as part of the URL. It is easier to convert
    %everything to hexadecimal than to handle special cases and
    %characterts. Wikipedia understands either input.
    hexcode=dec2hex(double(str));
    percents=repmat('%',size(hexcode,1),1);
    urlstr=sprintf('%s',strcat(percents,hexcode)');
    [orig, status]=urlread(['http://en.wikipedia.org/wiki/' urlstr]);
else
    %If no input is given, or is empty, read a random article
    [orig, status]=urlread(['http://en.wikipedia.org/wiki/Special:Random']);
end



%If unable to read article, give error. Article may still exist but it may
%be the input is wrong format or not spelled correctly.
if ~status
    error('WIKI: Unable to read URL. Article may exist, but input was incorrect. Please check input as program made no attempt to correct it.')
end


%FIND BEGINNING
%--------------
%Beginning of output string is not the beginning to the actual article. Most
%articles begin with '<p>' in the code, except if there are tables. Find
%where beginning tables are, which may be nested, and delete everything
%within them.
%Tables include 'Info boxes', and other boxes on the right hand side
beg1=findstr(orig,'<table');
beg2=findstr(orig,'table>');
beg3=findstr(orig,'<p>');
if ((~isempty(beg1))&&(~isempty(beg2)))&&(beg1(1)<beg3(1))
    %Tables may be nested, delete them one by one
    %(Should be a better/faster method?)
    ind=1;
    temp=orig;
    while ind
        beg1=findstr(temp,'<table');
        beg2=findstr(temp,'table>');
        if ((~isempty(beg1))&&(~isempty(beg2)))
            if beg2(1)>beg1(1)
                temp(beg1(1):beg2(1)+5)=[];
            else
                ind=0;
            end
        else
            ind=0;
        end
    end
    beg4=findstr(temp,'<p>');
    temp=temp(beg4(1):end);
else
    temp=orig(beg3(1):end);
end
%------------



%FIND END
%--------
%Find where article ends
%Exclude all 'See also', 'Notes', 'References', and/or 'External Links'
%(if they exist)
str1='<span class="mw-headline" id="See_also">See also</span>';
str2='<span class="mw-headline" id="Notes">Notes</span>';
str3='<span class="mw-headline" id="References">References</span>';
str4='<span class="mw-headline" id="External_links">External links</span>';
str5='<span class="mw-headline" id="Footnotes">Footnotes</span>';
str6='<span class="mw-headline" id="Source">Source</span>';
str7='<div class="printfooter">';
ti1=findstr(temp,str1);
ti2=findstr(temp,str2);
ti3=findstr(temp,str3);
ti4=findstr(temp,str4);
ti5=findstr(temp,str5);
ti6=findstr(temp,str6);
ti7=findstr(temp,str7);
minind=min([ti1 ti2 ti3 ti4 ti5 ti6 ti7])-1;
if ~isempty(minind)
    temp=temp(1:minind);
    %else, use full string and do nothing
end
%---------



%REMOVE HTML AND WIKIPEDIA TAGS
%------------------------------
%delete all http and wiki hypertext
s=regexprep(temp, '<[^>]+>', ' ');

%Remove all Wikipedia tabs
s=regexprep(s, '\x{5B}[\x{20}]+edit[\x{20}]+\x{5D}',' ');            %[edit]
s=regexprep(s, '\x{5B}[\x{20}]+[0-9]+[\x{20}]+\x{5D}',' ');          %[##] (references)
s=regexprep(s, '\x{5B}[\x{20}]+citation needed[\x{20}]+\x{5D}',' '); %[citation needed]
s=regexprep(s, '\x{5B}[\x{20}]+who\x{3F}[\x{20}]+\x{5D}',' ');       %[who?]

%Replace HTML symbols
for i=32:64 %Replace HTML number to symbol 
    s=regexprep(s, ['&#' num2str(i) ';'],char(i));
end
s=regexprep(s, '&#160;',' ');
s=regexprep(s, '&lt;', '<');
s=regexprep(s, '&gt;', '>');
s=regexprep(s, '&quot;', '"');
s=regexprep(s, '&apos;', '''');
s=regexprep(s, '&amp;', '&');

%Remove double white space
s=regexprep(s, '[ \f\r\t\v]+', ' ');

%Remove double lines, which may also contain white space
s=regexprep(s, '\n(\s){0,}\n', '\n\n');
s=regexprep(s, '\n\s', '\n\n');
%------------------------------




%For ease of reading, replace spaces with new lines - if need be -
%according to size of Command Window for wrapping text to output
q=wrapstring2(s,5);



%s: Not wrapped
%q: Wrapped according to Command Window Size
%S: Output
S=q;


end



function OutString=wrapstring2(InString,delta)

if (~exist('delta'))
    delta=0;
end

OutString=InString;
sv=get(0,'CommandWindowSize'); %Get Command Window Size
ind=1;
spacing=sv(1)-delta;

while ind
    %Keep adding new lines until every line is less than 'spacing'
    sp = find(isspace(OutString));                 %Find Spaces
    cc = [0 find(isstrprop(OutString, 'cntrl'))];  %Find Control characters
    nlb=cc(arrayfun(@(c) find(c>cc,1,'last'),sp)); %Find location of new line before each space
    sp2nl=sp-nlb;                                  %Spacing to previous new line
    indx=find((sp2nl(1:end-1)<spacing)&(sp2nl(2:end)>=spacing)); %indx of spaces greater than spacing
    OutString_temp=OutString;
    OutString_temp(sp(indx))=char(10);
    if strcmp(OutString,OutString_temp) %stop if no change, no infinite loop
        ind=0;
    end
    OutString=OutString_temp;
    if max(sp2nl)<spacing
        ind=0;
    end
end



end