% Contents of fminconset.  Minimization with set constraints.
%
% fminconset	A function for general nonlinear optimization where some
%              variables must belong to sets of discrete values.
%              
%              Useful where the underlying problem is (or can be formulated to be)
%              continous.
%
%              Examples: 
%              Optimizing pipes and valves where standard dimensions should be used.
%              The 'knapsack' problem.  
%
%					Requires the Optimization Toolbox from The MathWorks as it calls
%              FMINCON for solving the underlying continous problem.  An error should
%              be fixed in the NLCONST function in the PRIVATE part of the toolbox
%              if NLCONST has the following revision date:
%                  $Revision: 1.20 $  $Date: 1998/08/24 13:46:15 $
%              The correction is to make it so that the EXITFLAG = -1 statement
%              is independent of the verbosity parameter.
%
%              If you don't have this toolbox, you may be able to rewrite it for
%              another optimization function.
%
% helttest     A test program calling fminconset
%              for minimization of
% j134org      the function to minimize
%              with
% h134org      the constraints.
%
% ex134.tex    The example explained (in Norwegian)
%
% heltall.tex  The algorithm explained (also in Norwegian)
%
% I am sorry that I don't have the time to translate the documentetion.
% You will probably be able to find the "branch and bound" algorithm in a textbook.
% The process is the example 13.4 from the textbook: Optimization of Chemical Processes.
%
% The most of this stuff was made when lecturing optimization in Trondheim, Norway
% It is rewritten the autumn 1999 for the fmincon function in the Optimization Toolbox.
%
% Ingar Solberg
% ingar.solberg@vefsn.online.no

