function [ ] = montyhall(n,d,o)
%montyhall(n,d,o) Simulates n rounds of the Monty Hall problem and
%                 gives win/loss ratio
%
%                n   : Number of rounds to simulate (Any positive integer)
%                d   : Number of doors (Positive integer >= 3)
%                o=0 : Show final win/loss score and estimated probability
%                o=1 : Show win/loss tally chart and estimated probability
%                o=2 : Show results for each round
%
% All parameters are optional, by default they will take the values:
%  n=1, d=3, o=0.
%          
% The Monty Hall problem is a probability puzzle based on the American
% television game show Let's Make a Deal. The name comes from the show's
% host, Monty Hall. The problem is also called the Monty Hall paradox,
% as it is a veridical paradox in that the result appears absurd but is
% demonstrably true.
% http://en.wikipedia.org/wiki/Monty_Hall_problem
% 
%
%------------------------%

win=0;lose=0;tally=[0;0];Monty=0;
%-- Check for nonexistent variables and set to defaults
if exist('n')~=1, n=1; end
if exist('d')~=1 || d<3 || d~=round(d), d=3; end
if exist('o')~=1, o=0; end
%--

if o==2
    for i = 1:n
        %-- Picks a random door for the car to be behind
        Car = randi(d)-1;
        %-- Player picks a random door
        Choose = randi(d)-1;
        %-- Monty recursively picks a random door until he has chosen
        %   the door that neither has the car behind it or has been
        %   chosen by the player
        while (Monty==Car || Monty==Choose), Monty=randi(d)-1; end
        %-- If you originally choose the car, no matter what door Monty
        %   opens, you will lose by switching.
        %   If you originally choose a goat, Monty has to open a door to
        %   reveal the other goat, and switching will switch to the car
        %   meaning you win.
        %   Simply put, if you originally choose the car, switching wins
        %   and if you don't, switching loses.
        %   This is the basis of the score tally system
        if Choose==Car, lose=lose+1; else win=win+1; end
        %-- Display round results after game has been played.
        disp(['Round ',num2str(i)]);
        disp('Chosen door:');disp([zeros(1,Choose),1,zeros(1,(d-1)-Choose)]);
        if Car<Choose, disp('Monty opens:');disp([ones(1,Car),0,ones(1,Choose-Car-1),0,ones(1,(d-1)-Choose)]); end
        if Car>Choose, disp('Monty opens:');disp([ones(1,Choose),0,ones(1,Car-Choose-1),0,ones(1,(d-1)-Car)]); end
        if Car==Choose
            if Car<Monty, disp('Monty opens:');disp([ones(1,Car),0,ones(1,Monty-Car-1),0,ones(1,(d-1)-Monty)]); else disp('Monty opens:');disp([ones(1,Monty),0,ones(1,Car-Monty-1),0,ones(1,(d-1)-Car)]); end
        end
        disp('Car is behind:');disp([zeros(1,Car),1,zeros(1,(d-1)-Car)]);
        if Choose==Car, disp('Switching loses'); else disp('Switching wins'); end
        disp(' ');disp('   Win | Lose');disp([win,lose]);
        disp('---------------------');
    end
else
    for i = 1:n
        %-- When detail~=2, the next few lines simulate the game
        %   instead. This is a lot simpler as all unnecessary commands are
        %   removed. In the original block of code (where detail=2), the
        %   code can be summarised as;
        %   Pick 2 random numbers (Car and Choose), pick a random number
        %   not equal to those numbers (Monty) and finally check if the two
        %   original numbers are equal.
        %   The number that is chosen for Monty does not affect whether a
        %   win or a loss is tallied, so it is not needed for the simulation.
        Car = randi(d)-1;
        Choose = randi(d)-1;
        %-- Defining 'Monty' is not needed to decide a win or a loss.
        %   while (Monty==Car || Monty==Choose), Monty=randi(d)-1; end
        if Choose==Car, lose=lose+1; else win=win+1; end
        tally=[tally,[win;lose]];
    end
end
if o==1
    disp(['W: ',num2str(tally(1,1:n+1))]); 
    disp(['L: ',num2str(tally(2,1:n+1))]); 
else
    disp(['Won  ',num2str(win)]); 
    disp(['Lost ',num2str(lose)]); 
end
if n>=10, disp(['Estimated Chance Of Winning After Switch: ',num2str(win/n)]); end
end