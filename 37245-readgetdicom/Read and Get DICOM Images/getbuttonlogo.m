function logo=getbuttonlogo(CDr,Name,n,P)

N={'Program''s Data'};
NPath=setnewpath(CDr,N,1);

TR=sprintf('%s',Name,num2str(n),'.jpg');
N={NPath(1:end-1),TR};

logoname=setnewpath(CDr,N);
logoname=logoname(1:end-1);
Nlog=exist(logoname); %#ok<EXIST>

if Nlog==0
    logo=0;
elseif Nlog==2
    logo=imread(logoname);

    if nargin>3
        logo=imresize(logo,[P(1),P(2)]);
    end
end