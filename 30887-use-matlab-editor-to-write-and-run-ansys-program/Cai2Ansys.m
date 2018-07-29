function [r ExecuteTime] = Cai2Ansys(MatlabFile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% good to use .cai file to write ansys program under matlab environment
%   Strongpoint of .cai File:
%   Cell and Cell Folding, 
%   Highlight of Comment, 
%   Block Comment, 
%   Smart Indent  
%   Syntax Examination

%   Weak point of .cai File
%   No Syntax and Keyword Highlight

%   Bug:
%   ! direct after "Command without ','" occur error!!!!
%% format of .cai file
%   Format of .cai File:
%   Cell: %%
%   Comment: %
%   Block Comment: %{...%}
%   Remark: all these Symbol must at the first position of a row!!!!
%   ! can also be used as Comment Symbol, either at the front or at the end
%   of a row!!!!!!
%% start timing
tic;
%% Keywords Container
fid3=fopen('Ansys.ini','r');
i=1;
tline = fgetl(fid3);
A(i,1)={double(tline)};
while ischar(tline)
    tline = fgetl(fid3);
    i=i+1;
    A(i,1)={double(tline)};
    Asize(i,1)=size(double(tline),2);
end
fclose(fid3);
%%
%MatlabFile='test';
fid1 = fopen([MatlabFile '.cai'],'r');
fid2 = fopen([MatlabFile '.inp'],'w');
comment=0;
i=1;
%j=1;
tline=fgets(fid1);
while ischar(tline)
    %Comment
    if tline(1,1)=='%'||comment==1;
        if tline(1,2)=='{'
            comment=1;
        end
        if tline(1,2)=='}'
            comment=0;
        end
        tline(1,1)='!';
        i=i+1;
    %Command
    else
        tlinetemp1=double(tline);
        %no examination
        %find '='
        Flagtemp=find(tlinetemp1==61, 1, 'first');
        %find '('
        Flagtemp1=find(tlinetemp1==40, 1, 'first');
        %find ')'
        Flagtemp2=find(tlinetemp1==41, 1, 'first');
        %Keywords examination
        if isempty(Flagtemp)&&isempty(Flagtemp1)&&isempty(Flagtemp2)
            %find the first ','
            ind = find(tlinetemp1==44, 1, 'first');
            %Command without ','
            if isempty(ind)
                %remove new line character
                tlinetemp2=tlinetemp1(tlinetemp1~=10);
                %remove ' '
                tlinetemp3=tlinetemp2(tlinetemp2~=32);
                %remove 'enter-key'
                tlinetemp3=tlinetemp3(tlinetemp3~=13);                  
            %Command with ','
            else
                %save the Command
                tlinetemp2(1:ind-1)=tlinetemp1(1:ind-1);
                %remove ' '
                tlinetemp3=tlinetemp2(tlinetemp2~=32);
            end
            %{
%         Variable Container
%         if tlinetemp3==[42 68 73 77]
%             indtemp=find(tlinetemp1==44,2);
%             B={double(tlinetemp1(indtemp(1,1)+1:indtemp(1,2)-1))};
%             Bsize(j,1)=size(double(tline),2);
%             j=j+1;
%         end
            %}
            %find the approximate Command (same Command length) in Keyword Container
            Aind=Asize==size(tlinetemp3,2);
            %cast cell to matrix
            Amat=cell2mat(A(Aind,1));
            %search Command in Keyword Container
            Alog=bsxfun(@eq,Amat',tlinetemp3');
            %Matrix and Vector must be individual treated!
            if size(Alog,1)==1
                Flag=find(Alog==1);
            else
                Flag=find(all(Alog));
            end
            %no matching->Syntax error!
            if isempty(Flag)
                %{
%             Check Variable!
%             ind1 = find(tlinetemp1==40, 1, 'first');
%             Bind=find(Bsize==size(tlinetemp4,2));
%             Bmat=cell2mat(B(Bind,1));
%             Blog=bsxfun(@eq,Bmat',tlinetemp4');
                %}
                error(['Syntax error at line: ' num2str(i)]);
            end
        end
        i=i+1;
    end
    %write in .inp file
    fwrite(fid2,tline,'char');
    %get next line in .cai file
    tline = fgets(fid1);
    %clear temperature variable
    clear tlinetemp1 tlinetemp2 tlinetemp3;
    clear Aind Amat;
end
%error handlung
message1= ferror(fid1);
message2= ferror(fid2);
%close file
fclose(fid1);
fclose(fid2);
%% return Value
if strcmp(message1,'At end-of-file.')==1&&isempty(message2)==1
    r=0;
else
    r=1;
end
%% stop timing
ExecuteTime=toc;
end

