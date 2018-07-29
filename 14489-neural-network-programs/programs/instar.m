% %Question No 6
% Using the Instar learning law, group all the sixteen possible binary
% vectors of length 4 into four different groups. Use suitable values for
% the initial weights and for the learning rate parameter. Use a 4-unit
% input and 4-unit output network. Select random initial weights in the
% range [0,1]

in=[0 0 0 0;0 0 0 1;0 0 1 0;0 0 1 1;0 1 0 0;0 1 0 1;0 1 1 0;0 1 1 1;1 0 0 0;1 0 0 1;1 0 1 0;1 0 1 1;1 1 0 0;1 1 0 1;1 1 1 0;1 1 1 1];
wgt=[0.4 0.1 0.2 0.7; 0.9 0.7 0.4 0.7; 0.1 0.2 0.9 0.8 ; 0.5 0.6 0.7 0.6];
eta=0.5;
it=3000;

 for t=1:it
   for i=1:16
      for j=1:4
            w(j)=in(i,:)*wgt(j,:)';
      end
        [v c]=max(w);
        wgt(c,:)=wgt(c,:)+eta*(in(i,:)-wgt(c,:));
        k=power(wgt(c,:),2);
        f=sqrt(sum(k));
        wgt(c,:)=wgt(c,:)/f;
   end
end
     for i=1:16
        for j=1:4
            w(j)=in(i,:)*wgt(j,:)';
        end
        [v c]=max(w);
        if(v==0)
            c=4;
        end
        s=['Input= ' int2str(in(i,:)) ' Group= ' int2str(c)];
        display(s);
  end
  wgt