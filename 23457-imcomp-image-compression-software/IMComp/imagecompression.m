clc
clear
w=cd;
[a pathname]=uigetfile({'*.jpg;*.jpeg','Image files(*.jpg,*.jpeg)'},'Select image files','Multiselect','on');
cd(pathname)
mkdir newdir
a1=cd;
h=waitbar(0,'Please wait...');
for i=1:length(a)
    b=char(a(i));
    I=imread(b);
    a2=char(strcat(a1,'\newdir\',a(i)));
    imwrite(I,a2,'jpg');
    waitbar(i/length(a));
end
close(h)
cd(w);
clc