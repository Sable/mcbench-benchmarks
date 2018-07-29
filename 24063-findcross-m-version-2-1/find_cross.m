%                              find_cross.m
%
%                         Dr. Phillip M. Feldman
%
%                   Northrop Grumman Aerospace Systems
%
%                       Version 2.1   May 9, 2009
%
% Overview
%
% find_cross() uses a combination of search and interpolation to estimate
% the X values at which the dependent variable Y crosses a specified target
% level y_target.  If there are multiple level crossings, find_cross finds
% all of the level crossings.  This function has been designed to work with
% both continuous- and discrete-valued Y's.  Thus, if the input sequence
% "kisses" the specified level but does not actually cross it, this is not
% counted as a crossing.  If there are two or more consecutive Y values
% that match the specified target, each of them is counted as a crossing.
%
% Calling syntax:
%
% X_cross= find_cross(X, Y, Y_target)
%
% where:
%
% X is a column vector containing a sequence of monotone increasing
% values of the independent variable.
%
% Y is a column vector containing values of the dependent variable.
%
% Y_target is the desired level crossing.
%
% X_cross (the returned value) is the estimated value of X at which the
% dependent variable crosses the level Y_target.
%
%
% ACKNOWLEDGMENT
%
% This code uses a vectorized algorithm that was suggested to me by Paul
% Kienzle of the National Institute of Standards and Technology,
% Gaithersburg, MD.


%{
COMMENTS ON THE ALGORITHM

The algorithm consists of two phases. In the first phase, the target level
is subtracted out to reduce the problem to one of finding zero crossings,
and indices in the vicinity of crossings are then identified in a
computationally-efficient manner using vector operations. In the second
phase, each crossing is considered in turn. "Exact crossings", i.e., where
a zero is surrounded by values having opposite signs, are simply copied to
the output array. Non-exact crossings, i.e., where a pair of Y coordinates
bracket zero, are handled via interpolation.

After the initial phase, the number of indices to consider should be very
small, so there is no longer much impetus for using vector operations. If I
were going to try to vectorize this phase of the process, then I would find
all of the exact zeroes first and remove them so that the linear
interpolation could be done via vector operations with no risk of a
divide-by-zero condition. The two sets of zero-crossings (the exact zeros
and the estimated zeroes found by interpolation) would have to be merged
together and sorted. I'm not convinced that this would be either cleaner or
generally faster.


REVISION HISTORY

Version 2.1, 9 May 2009, Phillip M. Feldman:

As per a suggestion from Antoni J. Canós, I added a line of code at the end
of the function to eliminate repeated values in the output.

Version 2.0, 9 Nov. 2005, Phillip M. Feldman:

Vectorized the code for faster execution. The underlying assumption is
that, even for a large dataset, the number of level crossings tends to be
small, so that the initial step of finding array indices in the vicinity of
level crossings is the critical one from the standpoint of performance. The
subsequent step of estimating level crossing locations via interpolation
can be done within a loop.

Version 1.1, Phillip M. Feldman:

Fixed code to handle situation where Y_target exactly matches Y(i), with
Y(i-1) and Y(i+1) bracketing Y_target.  Previously, this was not being
recognized as a crossing.
%}

function X_cross= find_cross(X, Y, Y_target)


% Section 1: Preliminaries.

% Check dimensions of input arrays:

[m n]= size(X);
[r p]= size(Y);

if (n ~= 1 | p ~= 1)
   error('X and Y must be column vectors.');
end

if (m ~= r)
   error('Lengths of X and Y vectors must be the same.');
end

% Initialize output array to guarantee that it is defined:

X_cross= [];

% To prevent a subscript-out-of-bounds error in Section 2, augment Y by
% duplicating the last element of the array.  (We are operating on a
% copy of the Y array, so the Y array in the calling program is not
% affected).

Y(m+1)= Y(m);

% Subtract Y_target to simplify subsequent code:

Y= Y - Y_target;


% Section 2: Find array indices in crossing vicinities.

% Find potential crossings:

idx= find ( Y(1:end-2) .* Y(2:end-1) <= 0 );

% At this point, the largest possible element of idx is m-1, and the
% Y array has m+1 elements.

% Eliminate "kisses", i.e., cases where a zero is surrounded by two
% same-sign values:

idx(Y(idx+1)==0 & Y(idx).*Y(idx+2) > 0) = [];


% Section 3: Examine each of the crossing vicinities to determine
% whether the crossing in question is an exact crossing.  If it is not
% an exact crossing, use linear interpolation to estimate crossing
% point.  (idx should be a very small array, so we can afford to use a
% loop).

for i= 1 : size(idx,1)

   j= idx(i);


   % There are now two cases to consider:

   % Case 1: (Non-kiss) zero ==> Exact crossing.

   if (Y(j) == 0)
      X_cross(i)= X(j);


   % Case 2: Level crossing occurs between X(j) and X(j+1).

   else

      % Estimate crossing point via linear interpolation.  Note that we
      % cannot have Y(j) == Y(j+1) unless both are zero, but the case
      % Y(j) == 0 has already been handled above.

      X_cross(i)= ...
        X(j) + (X(j+1) - X(j)) * Y(j) / (Y(j) - Y(j+1));

   end

end

% As per a suggestion from Antoni J. Canós, repeated values in the output
% can be removed as follows:

X_cross= unique(X_cross);
