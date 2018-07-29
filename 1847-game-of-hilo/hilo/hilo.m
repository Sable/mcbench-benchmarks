function hilo
%
% WELCOME TO GAME OF HILO
% ~~~~~~~~~~~~~~~~~~~~~~~
%
% Created by Benjamin Leow
% Date: 25/2/2002
% E-mail: ben_leow@hotmail.com
% Website: http://freshblue.virtualave.net
%
% Please send any info on bugs to me
% 
% OVERVIEW
%
% You are presented 6 cards from a 52 cards deck.
% All except first card are faced down. All you have
% to do is to guess the preceeding card as higher or
% lower than than current card. If you correctly guessed
% all the cards then you win a game. The sequence from
% lowest to highest is A,2,3,4,5,6,7,8,9,10,J,Q,K.
%
%
% INSTRUCTION
% 
% - Place your bet. Your bet must not exceed total amount in
%   your bank account or less than 0. Empty to walk away.
% - Enter your guess. H or h for higher and L or l for lower.
%   Numerical values are also accepted; 1 for higher and 0 for
%   lower.
%   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear all
help hilo;
fprintf('\nPress any key to start game... ');
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Change this value if desired %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bank=100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not edit below this line  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=1;h=1;L=0;l=0;
fid=fopen('winner.dat','rt');
winner=fscanf(fid,'%c');
fclose(fid);
[prize]=textread('money.dat','%s');
prize=str2num(char(prize));
repeat=6;

while bank>0
   clc
   fprintf('_______________________________________\n\n');
   fprintf('          WELCOME TO HILO              \n');
   fprintf('     (Created by Benjamin Leow)        \n');
   fprintf('_______________________________________\n\n');
   fprintf('ALL TIME WINNER IS %s AT $%1.2f\n',winner,prize);
   fprintf('_______________________________________\n\n');
   fprintf('\nCurrent Bank Amount = $%1.2f\n',bank);
   bet=input('Your Bet [empty to quit] = $');
   while bet>bank | bet<=0
      bet=input('Your Bet [empty to quit] = $');
   end
   if length(bet)~=1
      if bank>=prize
         fprintf('\nCongratulation! You are all time winner...\n\n');
         winner=input('Name : ','s');
         while length(winner)==0
            winner=input('Name : ','s');
         end
         winner=upper(winner);
         prize=bank;
         fid=fopen('winner.dat','wt');
         fprintf(fid,'%s',winner);
         fclose(fid);
         fid2=fopen('money.dat','wt');
         fprintf(fid2,'%1.2f',prize);
         fclose(fid2);
      end
      fprintf('\nYou walk away with $%g\n\n',bank);
      break
   end
   
   deck=[1:13;1:13;1:13;1:13];
   randindex=randperm(52);
   for arr=1:repeat
      card(arr)=deck(randindex(arr));
   end
   
   num=1;
   proceed=1;
   while proceed==1 & num<repeat
      dispcard=ajqk(card(num));
      fprintf('\nCard is %s\n',dispcard);
      guess=input('Hi or Lo? [Hi = H, Lo = L]  ');
      while length(guess)~=1 | guess>1 | guess<0 | guess~=fix(guess)
         guess=input('Hi or Lo? [Hi = H, Lo = L]  ');
      end
      if card(num+1)>card(num)
         cg=1;
      elseif card(num+1)==card(num)
         guess=1;
         cg=1;
      else
         cg=0;
      end
      if guess==cg
         proceed=1;
         fprintf('\nCorrect!\n');
         num=num+1;
         if num==repeat
            won=1;
            dispcard=ajqk(card(num));
            fprintf('\nCard is %s\n\nCongratulation! you won $%1.2f\n',dispcard,bet);
         end
      else
         proceed=0;
         won=0;
         dispcard=ajqk(card(num+1));
         fprintf('\nWrong. (card is %s)\n\nYou lost $%1.2f\n',dispcard,bet);
      end
   end
   if won==1
      bank=bank+bet;
      fprintf('\nPress any key to proceed to next game');
      pause
   else
      bank=bank-bet;
      if bank<=0
         fprintf('\nSorry! You are bankrupt...\n\nGAME OVER\n\n');
      else
         fprintf('\nPress any key to proceed to next game');
      end
      pause
   end
end


function cardtype = ajqk(card)

if card==1
   cardtype='A';
elseif card==11
   cardtype='J';
elseif card==12
   cardtype='Q';
elseif card==13
   cardtype='K';
else
   cardtype=card;
   cardtype=num2str(cardtype);
end