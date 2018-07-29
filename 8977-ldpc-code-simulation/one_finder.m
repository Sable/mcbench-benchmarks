%function to find the
%max_check_degree,check_node_ones,BIGVALUE_COLS,max_variable_degree,variable_node_ones,BIGVALUE_ROWS
%function [max_check_degree,check_node_ones,BIGVALUE_COLS,max_variable_degree,
%                                   variable_node_ones,BIGVALUE_ROWS]=one_finder(H)
function [max_check_degree,check_node_ones,BIGVALUE_COLS,max_variable_degree,variable_node_ones,BIGVALUE_ROWS]=one_finder(H)

% ind=find(H==1);
[rows,cols]=size(H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find maximum check degree
% [nn,xx]=hist(sum(H,2));
% max_check_degree=1+ceil(xx(max(find(nn>0))));                 %!!!!!! make sure this will work each time
check_degrees=zeros(1,rows);
for uu=1:rows
    check_degrees(uu)=length(find(H(uu,:)==1));
end
max_check_degree=max(check_degrees);
check_node_ones=zeros(rows,max_check_degree);   %matrix to store column indeces in each row which contain '1'

%find column indeces in each row which contain '1'
for rr=1:rows
    temp=[];
    temp=find(H(rr,:)==1);
    if length(temp)<max_check_degree
        temp=[temp zeros(1,max_check_degree-length(temp))];
    end
    check_node_ones(rr,:)=temp;
end


BIGVALUE_COLS=cols+2000;     % value to take place of '0' in check_node_ones: has to be larger than number of columns in H
check_node_ones(find(check_node_ones==0))=BIGVALUE_COLS; % setting '0' to arbitrary big values

check_node_ones=check_node_ones-1;  %since in C the matrix index starts from '0'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Find maximum variable degree
% [nn,xx]=hist(sum(H,1));
% max_variable_degree=1+ceil(xx(max(find(nn>0))));                 %!!!!!! make sure this will work each time
variable_degrees=zeros(1,cols);
for uu=1:cols
    variable_degrees(uu)=length(find(H(:,uu)==1));
end
max_variable_degree=max(variable_degrees);
variable_node_ones=zeros(max_variable_degree,cols);   %matrix to store column indeces in each row which contain '1'

for rr=1:cols
    temp=[];
    temp=find(H(:,rr)==1);
    if length(temp)<max_variable_degree
        temp=[temp;zeros(max_variable_degree-length(temp),1)];
    end
    variable_node_ones(:,rr)=temp;
end

BIGVALUE_ROWS=rows+2000;  % value to take place of '0' in variable_node_ones: has to be larger than number of rows in H
variable_node_ones(find(variable_node_ones==0))=BIGVALUE_ROWS;
variable_node_ones=variable_node_ones-1;     %since in C the matrix index starts from '0'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%