%FUNCTION: Genetic
%PURPOSE:To create a new population based upon the parent genes
%			using crossover,muation,cloning and creation methods
%INPUT: Previous Population (32x4) Matrix
%OUTPUT: New Population (128x4) Matrix
%Created By David Ireland Email : david_jireland@hotmail.com

function T = genetic(T)
ind = 1;

%Cross Over
x = rand*4; % Randomly Chooses Which Bits Is To Be Swicthed
x = round(x); % Rounds The Value To The Nearest Integer
if (x==0)
	x = x + 1;% Makes Sure X Doesn't Equal 0
end

for i=1:32 % Performs Cross Over With The Randomly Choosen Bit
   T(i+9,:) = T(i,:);
	T(i+10,:) = T(i+1,:);
	T(i+9) = T(i+1,x);
	T(i+10,x) = T(i,x);
	x = rand*4;
	x = round(x);
   
   if (x==0)
	  	x = x + 1; % Makes Sure Bit Value Doesn't Equal 0
	end
end

%Mutation
for i=42:120
   ran = rand*4; % Randomly Chooses The Gene To Be Mutated
	ran = round(ran);
	
	% Randomly Chooses Which Parent Chromosone To Be Mutated
	ind = rand*20; 
	ind = round(ind);% Rounds To The Nearest Integer
   
   if (ran==0)
      ran = ran + 3; % Makes Sure The Choosen Chromosone != 0
   end
   
   if (ind==0)
      ind = ran + 10; % Makes Sure The Choosen Gene Doesn't Equal 0
   end
   
	% XOR The Bit With 31 To Invert The Gene
   T(i,:) = T(ind,:);
   T(i,ran) = xor((T(ind,ran)) , 31); 
end




 
%Cloning
for i=121:124
   ind = rand*3; % Randomly Chooses The Parent Chromosone to Be Cloned
   ind = round(ind); % Rounds To The Nearest Integer
	   if (ind==0)
   	   ind = ind + 5; % Makes Sure The Choosen Chromosone != 0
   	end
   T(i,:) = T(ind,:); % Clones The Choosen Chromsones
end
  
% Creation
% Randomly Creatres A 4x4 Population
Cret = rand(4,4);
Cret = Cret*6;
Cret = round(Cret);
Cret = Cret + 1;

% Inserts the 4x4 Population Into The Main Population 
for j=1:4
	  	for i=125:128
     T(i,j) = Cret(i-124,j);
  	end
end

for i=33:128
     for j=1:4
        T(i,j) = T(i,j) + 1; %Makes Sure No Gene Equals 0
     end
end
  
% End Of Function
  
     
  
  

