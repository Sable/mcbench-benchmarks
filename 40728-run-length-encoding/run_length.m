function e = run_length(x) %Entering input string for run length encoding
%Pankaj Joshi India 
% encode input matrix according to runlength encoding
%e=run_length(x) where x is input matrix and e is encoded version of x
%if input is a cractor string then return a run length encoded stream
%with ASCII CODE WITH ITS RESPECTIVE RUNS.
% by run length encoding
%example1 
% x=[1,1,1,1,1,1,0,0,0,0];
%y=run_length(x);
%y= 6 1 4 0
%example2
%x=[1,1,1,1,1,1,0,0,0,0;1,1,1,1,1,1,0,0,0,0];
%y=run_length(x)
%y=
%6 1 4 0
%6 1 4 0
%example3
%encoding of image file
%x=im2bw('Image_name')
%y=run_length(x)
%encoding
%first step count number of changes ouccers in bit stream
c=size(x);
if c(1)==1
    n=0;
for i=1:length(x)-1
    if x(i)~=x(i+1);
        n=n+1;
    end
end
%initialise starting value for each run of count 
for i=1:n+1
    l(i)=1;
end
%count each run of different massage
j=1;
i=1;
while j<length(x)
    if x(j)==x(j+1)
        l(i)=l(i)+1;
    else
        b(i)=x(j);
        i=i+1;
    end
    j=j+1;
end
b(n+1)=x(length(x));
i=1;
j=1;
%storing run length encoded data to e
while i<=length(l)&&j<=2*length(l)
    e(j)=l(i);
    e(j+1)=b(i);
    i=i+1;
    j=j+2;
end
%showing encoded data
else
    for p=1:c(1)
        n=0;
        for i=1:length(x(p,:))-1
            if x(p,i)~=x(p,i+1);
                n=n+1;
            end
        end
%initialise starting value for each run of count 
        for i=1:n+1
            l(i)=1;
        end
    %count each run of different massage
            j=1;
            i=1;
        while j<length(x(p,:))
            if x(p,j)==x(p,j+1)
                l(i)=l(i)+1;
            else
                b(i)=x(p,j);
                i=i+1;
            end
            j=j+1;
        end
        b(n+1)=x(p,length(x(p,:)));
        i=1;
        j=1;
%storing run length encoded data to e
        while i<=length(l)&&j<=2*length(l)
            e(p,j)=l(i);
            e(p,j+1)=b(i);
            i=i+1;
            j=j+2;
        end
%showing encoded data
   end
end
end