function [] = islandsmx() % Help file for mex version.
%ISLANDSMX finds all islands of four-connected elements in a matrix.
% ISLANDSMX returns a matrix the same size as the input matrix, with all of 
% the four-connected elements assigned an arbitrary island number. A second
% return argument is an nx3 matrix.  Each row of this matrix has 
% information about a particular island:  the first column is the island    
% number which corresponds to the numbers in the first return argument, the     
% second column is the number of elements in the island, the third column   
% is the value of the elements in that island (the elements of the input
% matrix).  ISLANDSMX will also return a binary matrix with ones in the 
% positions of the elements of the largest four-connected island.  The 
% largest four-connected island is determined first by value; for example  
% if there are 2 islands each with 5 elements, one of which is made up of   
% 6's and the other of which is made up of 4's, the island with the 6's  
% will be returned.  In the case where there are 2 islands with the same    
% number of elements and the same value, an arbitrary choice will be 
% returned. ISLANDSMX does not work with character arrays, nor with arrays
% which contain NaN's.
% 
% Examples:  
%           a = floor(rand(10,50)*3);
%           [allislands,nsv,biggestisland] = islandsmx(a); 
%           % allislands(allislands~=nsv(1,1))=0 %shows the first island.
%           spy(biggestisland); % look at this island.
%        
%           a = floor(rand(1000)*9);
%           tic,AG = islandsmx(a);toc
%
% Notes:
%        Exact equality is tested in ISLANDSMX, so the usual floating-point
%        comparison warning applies!  It is up to the user to decide how to
%        deal with situations for which this may pose a problem.  As one
%        example, say the user is interested in a matrix which has random 
%        elements on [0,1].  Say one wishes to group elements into islands 
%        such that elements on [0,.25) can group together, elements on
%        [.25,.5) can group together, elements on [.5,.75), and elements on 
%        [.75,1] can group together.  The elements in the matrix must first 
%        be assigned to a specific value.  To illustrate this:
%
%                A = rand(5);  % Example data.
%                B = A;         % Preserve A.
%                B(B>=0.0 & B <.25) = 2;  % 2 is outside the range of B.
%                B(B>=.25 & B<.50) = 3;
%                B(B>=.50 & B<.75) = 4;
%                B(B>=.75 & B<=1.0) = 5; 
%                % Alternatively, one can use histc to make B.
%
%        Then ISLANDSMX can be called on the matrix B.
%
%        As the number and size of islands increase, ISLANDSMX can slow 
%        dramatically.  To see this, replace the second example above with
%        
%        a = floor(rand(1000)*2); % Larger islands than floor(rand(500)*6)
%        [G,G,G] = islandsmx(a);spy(G) % Interested in the largest island.
%
%        The mex version is between 2 to 25 times faster than the M-File
%        version, depending on the input matrix.
%        The mex file was compiled with Borland Free compiler ver. 5.5.1
% 
% Author:  Matt Fig
% Contact: popkenai@yahoo.com
% Date:  08/21/2008