function dirn = getcameradirection( camera )
%GETCAMERADIRECTION: return the view direction of a camera
%
%   DIRN = GETCAMERADIRECTION(CAMERA) returns a unit vector giving the
%   direction from the camera centre along the camera principal axis.

%   Copyright 2005-2009 The MathWorks, Inc.
%   $Revision: 1.0 $    $Date: 2006/06/30 00:00:00 $


% First, get the centre in image coordinates
x = [
    size( camera.Image, 2 ) / 2
    size( camera.Image, 1 ) / 2
    1.0
    ];

X = camera.K \ x;
X = camera.R'*X;
dirn = X ./ norm( X );