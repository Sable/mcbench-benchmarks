function [V,W] = art1s(p,rho,flag,V,W)
%ART1S    ART1 simulation function.
% 
%         [V,W] = ART1S(P,rho,flag)
%           P   - F1xQ matrix of input vectors.
%           rho - the vigilance parameter, 0<= rho <=1.
%           flag  - (Optional) Printing flag. Any value of flag
%                   enables printing of events.
%         Returns:
%           V - the new top-down (T-D) weight matrix F1xF2.
%           W - the new bottom-up (B-U) weight matrix F2xF1.
%               F2 is the number of nodes in layer F2 (max # of categories)
%	  Example:  	P = letno;
%			art1s(P,0.7);
%	  
%		See also LETNO

%	  Author: Val Ninov, e-mail: valninov@total.net
%		  Grad. Student, Dept. of Electrical Engineering
%	          Concordia University, Montreal, Canada
%		  (c) April, 1997
%	  References:
%	   [1]	Carpenter, G. A. and S. Grossberg, "ART2: self-organization
%		of stable category recognition codes for analog input patterns."
%		Applied Optics, vol. 26, no. 23, Dec. 1987, pp. 4919-4930.
%	   [2]	J. Freeman and D. Skapura, Neural Networks: Algorithms,
%		Applications, and Programming Techniques. Addison Wesley


if nargin<2 | nargin>5  error('Wrong number of input arguments.');  end

% NETWORK PARAMETERS
 [R,Q] = size(p);
 F1 = R;
 F2 = Q;
 L = 2;
 categ = zeros(F2,F2); % category table
 count = ones(1,F2);   % counter for patterns in one category

% INITIALIZE WEIGHTS
if nargin < 4
 W = ones(F2,F1)*(L/(L-1+F1));
 V = ones(F1,F2);
 %fprintf('INITIAL TOP-DOWN MATRIX :');  V
 %fprintf('INITIAL BOTTOM-UP MATRIX :'); W
end

% INITIALIZE RETURN VARIABLES
a1 = zeros(F1,Q);   % output of F1
i = zeros(1,Q);     % winner index
win = 1;	    % First time node 1 in F2 is the winner
nActive = 1;        % The number of active neurons in F2

% PRESENT EACH INPUT VECTOR
for q=1:Q
    Reset = 0; 
    B2 = zeros(F2,1);
    resonance = 0;
  while ~resonance    % REPEAT UNTIL: LAYERS F1 & F2 RESONATE
          % Initially a1 = p;
          % Calculate the winning node in F2 (among the active nodes)
	  A2 = compet(W(1:nActive,:)*p(:,q)+B2(1:nActive,1));
          i(q) = find(A2 == 1);
          win = i(q);
      % RECALCULATE a1 WITH FEEDBACK FROM A2
      a1(:,q) = (p(:,q) & V(:,win));

      % RESET if the new a1 is too different from p
	S= sum(a1(:,q));
	X= sum(p(:,q));
      Reset = (S/X) < rho;

       % IF RESET: TAKE WINNING NEURON IN F2 OUT OF COMPETITION
       if Reset
          B2(win) = -100;
             if nargin == 3
              fprintf('              RESET: Pattern %0.f resets F2 neuron %0.f.\n',q,win);
             end	

           % IF ALL NEURONS IN A2 OUT OF COMPETITION ADD NEURON TO LAYER 2
           if all(B2(1:nActive,1) == -100)
	     nActive = nActive + 1;
                if nargin == 3
                 fprintf('            A new category %d created\n',nActive);
                end
               win = nActive;
           end
         
      % ELSE RESET NEURON DOES NOT FIRE: LAYERS 1 & 2 RESONATE 
      else
           if nargin == 3
             fprintf('Pattern %d classified in %d category.\n',q,win);
           end
      resonance = 1;
      end  

    end  % end of WHILE loop

    	% Update B-U LTM and T-D LTM
    	V(:,win) = a1(:,q)&V(:,win);	
    	W(win,:) = (a1(:,q)*L/(L-1+sum(a1(:,q))))';
	%V(:,win) = V(:,win).*p(:,q);
	%W(win,:) = (V(:,win).*p(:,q))'/(0.5 + sum(V(:,win).*p(:,q)));
	 categ(win, count(win)) = q;
         count(win) = count(win)+1;
end	% end of FOR loop

% Display final classification
fprintf('\n  Category      Pattern\n  -----------------------------------------------\n');
 for i = 1:nActive
  fprintf('     %d           ',i);
   for j= 1:F2
	if categ(i,j) 
         fprintf('%s, ',(categ(i,j)+64));
        end
   end
   fprintf('\n  ------------------------------------------------\n');
 end
     