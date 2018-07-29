function varargout = myComplement(MENUS,menu_defined)
tf = logical(zeros(1,length(MENUS)));
for menu=1:length(menu_defined)
    tf = tf + strcmp(menu_defined(menu),MENUS);
end
varargout{1} = MENUS(logical(1-tf));
