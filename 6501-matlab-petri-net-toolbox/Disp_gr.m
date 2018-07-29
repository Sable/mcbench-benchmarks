function [XX]=disp_gr(A,RM)

% function [XX]=disp_gr(A,RM)
% Input parameters this function are matrix A and matrix RM, which are output parameters of function graph.m
% Output parameter this function is matrix XX, which  contains these items: state, parent,subs,trans,Xi,Yi,Xf,Yf,col
%
%  state -  number of state, which corresponds to number of column in matrix RM;
%  parent - parent of this state;
%  subs - the number of subsequent states (subs);
%  trans -  index of fired transition (trans)
%  Xi, Xf, Yi, Yf -  initial and final X,Y positions needful for displaying the graph of reachable markings
%  col -  number of column of XX matrix corresponding to parent of processing state
%
% 
% colour solid lines determine direction from left to the right, dashdot white line determine 
% direction from right to left. 


k=1;
item=1;
rows_A=size(A,1);
pom=0;
pom1=0;
color=0;
colors=['y' 'm' 'c' 'r' 'g' 'b'];
vel_nula=0;

fig=figure;
axis('off');
hold;
% 1.uroven stromu dosazitelnosti
sub_1=size(find(A(1,:)),2);

XX([1 2 3 4 5 6 7 8 9],1)=[1 0 sub_1 0 0 0 0 0 0]';
text(-0.02,0,'x');
text(-0.1,-0.25,['m0']);

% next levels of graph of reachable markings

while k<=rows_A,
   
  column_of_subs=find(A(k,:)); 	%finding of subsequent states
  subs=size(column_of_subs,2);	% the number of subsequent states
  
  for j=1:subs	
   item=item+1;		
   trans=A(k,column_of_subs(j));
    if (isempty(trans))
	trans=0;
    end;
   trans_str=int2str(trans);
   transit=['T',trans_str];
    parent= k;
    number_subs_of_state=size(find(A(column_of_subs(j),:)),2);
    if k>6
       color=rem(k,6);
         if rem(k,6)==0
            color=6;
         end;
    else color=k;
    end; 
 
     if number_subs_of_state==0				%finding of states whose subsequent states are null
      nula=[nula column_of_subs(j)];
      vel_nula=size(nula,2);
     end;       

    for i=1:size(XX(1,:),2)
           
      if (parent==XX(1,i)) & (pom1~=1)	%finding column of matrix XX, which contains parents of state we work with.
        col=i;        		% coordinates of this state Xi, Yi equal  coordinates Xf,Yf of parent of this state
        pom1=1;
        Yi= XX(8,col);
        Xi= XX(6,col);
        uroven =Xi+2;
      end;
      
      if (column_of_subs(j)==XX(1,i)) & (pom~=1)   	% creating of row of matrix XX, when state already exists
        Xf=XX(6,i);				
        Yf=XX(8,i);
        pom=1;
      end;
    end; 
    pom1=0;

    if pom~=1	 			% creating of row of matrix XX, when state doesn't exist
      Yf= XX(8,col)+(j-1)*uroven;
      Xf=Xi+1;
     else pom=0;  
    end;
   
   
     % displaying of state and its transition, which returns to some state (direction from right to the left

   if column_of_subs(j)< k

	XX(:,item)=[column_of_subs(j) parent number_subs_of_state trans Xi Xf Yi Yf col]';

      if (Yi>1)  			% counting of coordinates of returning point ( we will go through this point)
       max_Yi=max(XX(7,:));
       max_Yf=max(XX(8,:));
       max_yy=max(max_Yi,max_Yf);   
	    plot([Xi Xf+1/2 Xf],[Yi max_yy+1 Yf],'w-.');
        text(Xf+1/2,max_yy+1,transit)
       else plot([Xi 1 Xf],[Yi -3 Yf],'w-.');text(1,-3,transit);     
      end;

       else plot([Xi Xf],[Yi Yf],colors(color));text(Xf-0.02,Yf,'x'); XX(:,item)=[column_of_subs(j) parent number_subs_of_state trans Xi Xf Yi Yf col]';
text(Xf-0.1,Yf-0.25,['m',int2str(column_of_subs(j)-1)]);  

  end;
   

% displaying name of transitions to particular arcs 
if column_of_subs(j)>= k
     if (Yi>Yf) 
      text(Xi+1/2,(Yf+(Yi-Yf)/2)+0.1,transit)

      else  text(Xi+1/2,(Yi+(Yf-Yi)/2)+0.07,transit); 	
     end;
   end;
 end;  % end of cycle for 
 
 
 % protection of not processing row of matrix A which is null
  k=k+1;
  for i=1:vel_nula	
     if k==nula(i);
    k=k+1;
   end;
  end;

end; 			% end of main cycle - while 