function plotpoint(i,x1,y1)


%x1=[source dest]--in x axis
%y1=[source dest]--in y axis

   Color='r';
  % N=1000;
       


 
 
    if abs(x1(1)-x1(2))>=abs(y1(1)-y1(2))

    
     if x1(1)<=x1(2)
        %x=x1(1):x1(2);
        x=x1(1)+i;
        p=1;
     else
        %x=x1(1):-1:x1(2);    
        x=x1(1)-i;
        p=2;
     end   
             if ((p==1 && x<=x1(2)) || (p==0 && x>=x1(2)))
                 
                %%
                Radius=i;%sqrt((abs(i))^2 + (abs(i))^2);
                plotcircle(x1(1),y1(1),Radius,Color)
                %%
                 
                 
                y=(((x-x1(1))./((x1(2)-x1(1)))).*((y1(2)-y1(1))))+y1(1);


                plot(x,y,'.','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','y',...
                    'MarkerSize',8);
                hold on

                plot(x1,y1,'^r')

             end 
    else

      if y1(1)<=y1(2)
        %x=x1(1):x1(2);
        y=y1(1)+i;
        p=1;
      else
        %x=x1(1):-1:x1(2);    
        y=y1(1)-i;
        p=0;
      end   
    
          if ((p==1 && y<=y1(2)) || (p==0 && y>=y1(2)))
                x=(((y-y1(1))./((y1(2)-y1(1)))).*((x1(2)-x1(1))))+x1(1);

                %%
                Radius=i;%sqrt((abs(i))^2 + (abs(i))^2);
                plotcircle(x1(1),y1(1),Radius,Color)
          
                
                %%
                plot(x,y,'.','LineWidth',1,...
                    'MarkerEdgeColor','k',...
                    'MarkerFaceColor','y',...
                    'MarkerSize',8);
                hold on

                plot(x1,y1,'^r')

          end   
    end


end