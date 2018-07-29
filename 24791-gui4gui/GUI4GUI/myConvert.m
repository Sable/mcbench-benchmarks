function myConvert(GID)
menu_names = {'File' 'Model' 'Articles' 'Tutorial' 'Examples' 'Run' 'Code' 'Help'};
fid = fopen('main_inputfile_tmp.m','w+');
Task = GID.task;
for menu=1:8

Nitems1 = sum(1 - strcmp(GID.task(menu).label(:,1,1),''));   % number of defined labels; complement of # of nulls
fprintf(fid,'Task(%d).name = ''%s'';\n',menu,char(menu_names(menu)));
fprintf(fid,'Task(%d).string = { ...\n',menu);
  N3 = 0;
  for Item1=1:Nitems1
    Nitems2 = sum(1 - strcmp(GID.task(menu).label(Item1,:,1),''));   % number of defined labels
    for Item2=1:Nitems2
      Nitems3 = sum(1 - strcmp(GID.task(menu).label(Item1,Item2,:),''));   % number of defined labels
      N3 = max(Nitems3,N3);
      for Item3=1:Nitems3
%       if Item1*Item2*Item3 == 1
%         fprintf(fid,'Task(%d).string(1:3,1:%d,1:%d,1:%d) = { ...\n',menu,Nitems1,Nitems2,Nitems3);
%       end
        number = Item1*100+Item2*10+Item3 - 11;
        fprintf(fid,' %3d ''%s''  ''%s''  ''%s'' ...\n',number,char(Task(menu).label(Item1,Item2,Item3)),char(Task(menu).type(Item1,Item2,Item3)),char(Task(menu).ops(Item1,Item2,Item3)));
      end
    end
  end
% fprintf(fid,'Task(%d).nlevels = %d;\n',menu,Task(menu).nlevels);
% fprintf(fid,'Task(%d).nm = [%d,%d,%d];\n',menu,Nitems1,Nitems2,N3);
  fprintf(fid,'};\n\n');
end
fclose(fid);
