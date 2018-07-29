%% Systems of linear equations
% At its heart, the subject of linear algebra is concerned with how to
% solve the seemingly simple equation:
%
% $${\bf{A}}x=b$,
% where $${\bf{A}}$ is a matrix and $$x$ and $$b$ are vectors.
%%
%
% This might seem surprising, but this problem is right at the heart of
% almost all problems in scientific computing, from differential equations
% to eigenvalue problems to interpolation and curve fitting. 

%%
% Of course, for a single scalar variable, x, we know what that means:
% $$ a\times x = y$
% from which we can deduce that 
% $$ x = y/a$, for non-zero $$a$.
%%
% The question is how do we solve such a problem when we have more than one
% unknown variable, or, equivalently, when x is a vector? To investigate this
% question, let's consider the following electrical circuit:
%
[c,m]=imread('circuit2.gif','gif');

figure('color',[1 1 1]),
image(c), colormap(m), axis equal, axis off

%%
% We want to calculate the currents $$I_1,I_2,I_3$ 
%%
% Using Kirchoff's voltage laws we get the following three equations for
% the three unknown currents:
%%
% <latex>
% $\left\{\begin{array}{ccc}
% I_1 + 25(I_1-I_2)+50(I_1-I_3) & = & 10 \\
% 25(I_2-I_1) + 30I_2 + I_2 -I_3 & = & 0 \\
% 50(I_3-I_1)+I_3-I_2+55I_3 & = & 0 \end{array}\right . $
% </latex>
%%
% which, with a little re-arranging becomes:
%%
% <latex>
% $\left\{\begin{array}{ccc}
% 76I_1 - 25I_2-50I_3 & = & 10 \\
% -25I_1 +56I_2 -I_3 & = & 0 \\
% -50I_1-I_2+106I_3 & = & 0 \end{array}\right .$
% </latex>
%%
% Finally, we can gather all the coefficients into a matrix, and the
% unknowns into a vector, to write the single matrix linear equation:
%%
% <latex>
% $\left( {\begin{array}{ccc}
% 76 & -25 & -50 \\
% -25 & 56 & -1  \\
% -50& -1 & 106 \end{array}} \right)
% \times \left(\begin{array}{c}
% I_1\\
% I_2\\
% I_3 \end{array}\right) = \left( \begin{array}{c}
% 10 \\
% 0\\
% 0 \end{array}\right)$
% </latex>
%%
% In this way we have got the system of equations into the form that we
% described above, namely:
% $${\bf{A}}x=b$
%%
% Of course, for a small system (3 by 3 in this case) we can solve this by
% hand. For a larger system, however, we need a computer. The basic
% approach to solving such a system is an extension of that used by hand,
% namely we add and subtract multiples of one row to one another until we
% finally end up with an upper triangular matrix. This action
% of adding and subtrating multiples of one row to another is known as a
% basic row operation. Let us illustrate the process with MATLAB. Before we
% begin, we augment the right hand side vector to be an extra column in our
% matrix $$\bf A$, so it is now three rows by four columns.
A=[76 -25 -50 10;-25 56 -1 0; -50 -1 106 0]
rrefexample(A)
%%
% What is the advantage of reducing $${\bf A}$ to be upper triangular?
% Starting from the last row, we see that we now have an equation that
% depends only on $$I_3$, that is $$I_3 = 0.117$. The row above depends on
% $$I_3$ and $$I_2$ only, and we now know what $$I_3$ is! In this way, we
% work our way up through the rows substituting as we go, and in each row
% there is only a single unknown variable. This process is called _back
% substitution_. This entire process - that of reducing the matrix to a
% triangular form and solving via back substitution - is the way most
% computer packages solve these linear systems. In MATLAB, the shorthand
% way of solving such systems is with the backslash character ``\''
A=[76 -25 -50;-25 56 -1; -50 -1 106]
b =[10;0;0]
I= A\b
%%
% In the example above, we have performed a special case of what is a more 
% general idea - that of transforming a matrix into a special form, so that 
% the equations can be solved more easily. In general, the idea of
% transforming a matrix through a series of elementary row operations is a
% powerful one. May special types of _matrix factorisations_ exist, and two
% of the most important examples are:
%%
% *QR decomposition *
% In this case, a general matrix is written as the product of two matrices,
% one orthogonal and one upper triangular:
% $${\bf A = QR}$
% As the inverse of an orthogonal matrix is equal to its transpose, we find
% the solution to the general system $${\bf A}x=b$ can be calculated as:
%%
% <latex>
% $\begin{array}{l}
% {\bf A}x = b \\
% {\bf QR}x = b \\
% {\bf Q}({\bf R}x)=b \\
% {\bf R}x = {\bf Q^T} \times b \\
% x = {\bf R}\setminus{\bf Q^T} \times b \end{array}$
% </latex>
%%
% *LU Decomposition*
% In this case the matrix is decomposed into two, a lower and an upper
% triangular matrix. As both the matrices are triangular, the back (and
% forward) substitution process is very quick:
%%
% <latex>
% $\begin{array}{l}
% {\bf A}x = b \\
% {\bf LU}x = b \\
% {\bf U}({\bf L}x)=b \\
% {\bf U}x = {\bf L}\setminus b \\
% x = {\bf U}\setminus({\bf L}\setminus b) \end{array}$
% </latex>

%   Copyright 2008-2009 The MathWorks, Inc.
%   $Revision: 35 $  $Date: 2009-05-29 15:27:34 +0100 (Fri, 29 May 2009) $
