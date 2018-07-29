%% Initvvx
%%
%%

a = findobj('style','edit');
for i = 1:length(a),
   eval( [get(a(i),'tag') '=' get(a(i),'string') ';'] );
end

rho = 1000;
useoutput = get(findobj('tag','useoutput'),'value');
cocurrent = get(findobj('tag','cocurrent'),'value');

