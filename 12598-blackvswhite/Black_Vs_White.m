function Black_Vs_white()

disp('           GAME->BLACK Vs WHITE')
disp('')
%The original name of the game is Northcrott's game.
clc;
disp('DESCRIPTION:')
disp('')
disp('1. In every row of a rectangular board, there are two checkers: one white and one black.')
disp('2. A move consists in sliding a single checker in its original row without')
disp('jumping over another checker.')
disp('3. You play BLACK, computer plays WHITE. As usual, the player to make the')
disp('last move wins.')
disp('')
disp('Press any key to continue...')
pause;
%--------------------------------------------------------------------------
% defining the board

row = 5+mod(fix(10*rand(1,1)),4);         %5 to 8
column = 5+mod(fix(10*rand(1,1)),2);      %5 to 6
nick=2*ones(row,column);

for ii=1:row
    jj=1+mod(fix(10*rand(1,1)),column);         %1 to column      
    nick(ii,jj)=1;
    temp=0;
    while temp==0  
          kk=1+mod(fix(10*rand(1,1)),column);   %1 to column
          if jj~=kk
             nick(ii,kk) = 0;
             temp=1;
          end
     end
end

Board(nick,row,column);
%--------------------------------------------------------------------------
%game begins

clc
disp('           Press "0" for UUU to START');
disp('                          OR');
disp('           Press "1" for CPU to START');
turn=input('');

 bye=0;
 step=1;
while step~=0
     
%--------------------------------------------------------------------------
%user move

if mod(turn,2)==0
    clc
    win=0;
    disp('                BLACKs TURN...');
    disp('        Just Click On the Desired Location...');
    valid=0;
    
    while valid==0
        
        [BXnew BYnew Button] = ginput(1);
        
        if Button~=1    bye=1;  close;  break;  end
        
        if Button==1
          Xnew=floor(BYnew);
          Ynew=floor(BXnew);
          if nick(Xnew,Ynew)~=0
              
            if (Xnew>0 & Xnew<row+1 & Ynew>0 & Ynew<column+1)
                for ii=1:column
                    if nick(Xnew,ii)==0   BXpos=Xnew;  BYpos=ii;   end
                    if nick(Xnew,ii)==1   WXpos=Xnew;  WYpos=ii;   end                    
                end
            else
                disp('           Please check ur move...');
                continue;
            end       
            
           else
               disp('           Please check ur move...');
               continue;
           end

          if ((BYpos-WYpos>0 & Ynew-WYpos>0) | (BYpos-WYpos<0 & Ynew-WYpos<0))   
              valid=1;  
              nick(Xnew,Ynew)=0;
              nick(BXpos,BYpos)=2;
              Board(nick,row,column);
          end  
          
          if valid~=1
              disp('           Please check ur move...');
          end
          
        end
    end
end

if bye==1  clc;  break;  end
%--------------------------------------------------------------------------
%cpu move

if mod(turn,2)==1
    clc
    disp('                WHITEs TURN...');
    valid=0;
   while valid==0
       
    for Xnew1=1:row
        for Ynew1=1:column        
            
           if nick(Xnew1,Ynew1)==0   
              BXpos1(Xnew1)=Xnew1;  
              BYpos1(Xnew1)=Ynew1;   
           end
           
           if nick(Xnew1,Ynew1)==1   
              WXpos1(Xnew1)=Xnew1;  
              WYpos1(Xnew1)=Ynew1;   
           end       
           
       end
       differ1(Xnew1)=abs(BYpos1(Xnew1)-WYpos1(Xnew1))-1;
   end

   if mod(length(find(differ1>0)),2)==0
       %select one row make diff one
       for ii=1:row
           
           if differ1(ii)>1
               
               if BYpos1(ii)>WYpos1(ii)
                  nick(WXpos1(ii),WYpos1(ii))=2;
                  WYpos1(ii)=BYpos1(ii)-2;
                  valid=1;
                  win=1;
                  break;
               end
               
               if BYpos1(ii)<WYpos1(ii)
                  nick(WXpos1(ii),WYpos1(ii))=2; 
                  WYpos1(ii)=BYpos1(ii)+2;
                  valid=1;
                  win=1;
                  break;
               end              
               
           end          
       end       
   end
   
   if mod(length(find(differ1>0)),2)==1
       %close one row
       for ii=1:row
           
           if differ1(ii)>0
               
               if BYpos1(ii)>WYpos1(ii)
                  nick(WXpos1(ii),WYpos1(ii))=2; 
                  WYpos1(ii)=BYpos1(ii)-1;
                  valid=1;
                  win=1;
                  break;
               end
               
               if BYpos1(ii)<WYpos1(ii)
                  nick(WXpos1(ii),WYpos1(ii))=2; 
                  WYpos1(ii)=BYpos1(ii)+1;
                  valid=1;
                  win=1;
                  break;
              end
              
           end           
       end    
   end      
   
   if valid==0
      %choose some valid move
      for ii=1:row
          if differ1(ii)>0
               if BYpos1(ii)>WYpos1(ii)
                  nick(WXpos1(ii),WYpos1(ii))=2; 
                  WYpos1(ii)=BYpos1(ii)-1;
                  valid=1;
                  win=1;
                  break;
               end
               
               if BYpos1(ii)<WYpos1(ii)
                  nick(WXpos1(ii),WYpos1(ii))=2; 
                  WYpos1(ii)=BYpos1(ii)+1;
                  valid=1;
                  win=1;
                  break;
              end 
          end
      end
   end
   
  end
   nick(WXpos1(ii),WYpos1(ii))=1;
   pause(2);
   Board(nick,row,column);   
end  

%--------------------------------------------------------------------------
%who won who lost!

step=0;
    for Xnew2=1:row
        for Ynew2=1:column   
            
           if nick(Xnew2,Ynew2)==0   
              BXpos2(Xnew2)=Xnew2;  
              BYpos2(Xnew2)=Ynew2;   
           end
           
           if nick(Xnew2,Ynew2)==1   
              WXpos2(Xnew2)=Xnew2;  
              WYpos2(Xnew2)=Ynew2;   
           end            
           
        end
        
       differ2(Xnew2)=abs(BYpos2(Xnew2)-WYpos2(Xnew2))-1;
       if differ2(Xnew2)==0
          step=step+1;
       end
   end
   
if step==row      
    
    if win==0
       text(0.35*row,0.25*column,'UUU WON THE GAME','color','b','fontsize',20);
    end
    
    if win==1
       text(0.35*row,0.25*column,'CPU WON THE GAME','color','b','fontsize',20);
    end
    if (win==0 | win==1)
        disp('          THANX 4 PLAYING...');
        disp('          HAVE A GOOD DAY...');
    end
    pause(3);
    close;
    clc;
    break;
end

%--------------------------------------------------------------------------
turn=turn+1;
end
%--------------------------------------------------------------------------
%drawing the board
function Board(nick,row,column)

clc
clf
for ii=1:column
    for jj=1:row
        rectangle('Position', [0+ii 0+jj 1 1],'linewidth',3);        
        hold on
        if nick(jj,ii)~=2
            Xcir=(0.5+ii)+0.4*cos(0:1/50:2*pi);
            Ycir=(0.5+jj)+0.4*sin(0:1/50:2*pi);
            plot(Xcir,Ycir);       
            if nick(jj,ii)==1   fill(Xcir,Ycir,'w');   end
            if nick(jj,ii)==0   fill(Xcir,Ycir,'k');   end 
        end        
    end   
end

axis off
xlabel('Right click to exit');
title('Black Vs. White','fontsize',20,'color','b');
%--------------------------------------------------------------------------