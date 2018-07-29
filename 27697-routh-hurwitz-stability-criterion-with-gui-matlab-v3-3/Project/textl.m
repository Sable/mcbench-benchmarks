%=======================set string color============================
%---------first element zero-----------
switch get(handles.menu_file_dispcolor_fez,'UserData')
    case 1
        fezc='red';
    case 2
        fezc='blue';
    case 3
        fezc='green';
    case 4
        fezc='yellow';
    case 5
        fezc='gray';
end

%---------all elements zero-----------
switch get(handles.menu_file_dispcolor_aez,'UserData')
    case 1
        aezc='red';
    case 2
        aezc='blue';
    case 3
        aezc='green';
    case 4
        aezc='yellow';
    case 5
        aezc='gray';
end
%===================================================================

m=size(tab,1);
%==========recognize inf or -inf if exist in first column===========
state='';
for i=1:m
    if tab(i,1)==inf
        state='inf';
    elseif tab(i,1)==-inf
        state='-inf';
        break;
    end
end
if isempty(state)
    state='simp';
end
%===================================================================
pres=get(handles.input_edit,'Value');
matstr=num2str(tab,pres);

set(handles.table_ras,'Enable','Inactive');

%========calculate max dimension=========
str=htmlgen(tab(1,:),m,pres,state,'yellow');
len=2*length(str);
totstr(m+1,len)=' ';
%========================================
lrowaz=length(row_all_zero);
lrowfz=length(row_first_zero);

for j=1:lrowaz
    str_r=htmlgen(tab(row_all_zero(j),:),m-row_all_zero(j),pres,state,aezc);
    len_r=length(str_r);
    totstr(row_all_zero(j),1:len_r)=str_r;
end
for j=1:lrowfz
    str_b=htmlgen(tab(row_first_zero(j),:),m-row_first_zero(j),pres,state,fezc);
    len_b=length(str_b);
    totstr(row_first_zero(j),1:len_b)=str_b;
end

y=m-1;
for i=1:m
    if totstr(i,1)~='<'
        if y>9
            str_e=[sprintf('s^%g      ',y) matstr(i,:)];
        else
            str_e=[sprintf('s^%g        ',y) matstr(i,:)];
        end
        len_e=length(str_e);
        totstr(i,1:len_e)=str_e;
    end
    y=y-1;
end

set(handles.table_ras,'String',totstr);
set(handles.table_ras,'Value',m+1);

