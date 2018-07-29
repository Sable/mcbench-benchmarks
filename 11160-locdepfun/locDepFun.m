function [list,dif]=locDepFun(Fun)
%LOCDEPFUN determines the local m-files that a function depends upon
%    [LIST,DIF]=LOCDEPFUN(FUN)
%    FUN is a string with the function name
%    LIST is a cell array of strings with the local m-files that FUN
%    depends upon
%    DIF is a cell array of strings with the local m-files that FUN does
%    not depend upon
%
%    Example
%        [list,dif]=locDepFun('foo');
%    Determines which local m-files foo.m ooes and does not depend upon
%
%    See also DEPFUN.

%R.F. Tap, May 2006

list = depfun(Fun,'-quiet');
d = cd;
lcd = length(d);
I = [];
for i=1:length(list)
    if length(list{i})>=lcd
        if strcmp(d,list{i}(1:lcd))
            I=[I i];
        end
    end
end

dm=dir('*.m');
names = {dm.name};

ieq = [];
for i=1:length(names)
    LN = length(names{i});
    for j=1:length(I)
        if strcmp(names{i},list{I(j)}(end-LN+1:end))
            ieq = [ieq i];
            break
        end
    end
end

idif = setdiff(1:length(names),ieq);
dif = names(idif)';
list = names(ieq)';