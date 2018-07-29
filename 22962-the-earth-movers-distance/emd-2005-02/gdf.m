function [E] = gdf(V1, V2)
%
% GDF   Ground distance between two vectors
%    [E] = GDF(F1, F2) is the ground distance between two feature vectors.
%
%    Example:
%    -------
%        v1 = [100, 40, 22];
%        v2 = [50, 100, 80];
%        ...
%        [e] = gdf(v1, v2);
%        ...
%
%    This file and its content belong to Ulas Yilmaz.
%    You are welcome to use it for non-commercial purposes, such as
%    student projects, research and personal interest. However,
%    you are not allowed to use it for commercial purposes, without
%    an explicit written and signed license agreement with Ulas Yilmaz.
%    Berlin University of Technology, Germany 2006.
%    http://www.cv.tu-berlin.de/~ulas/RaRF
%

E = norm(V1 - V2, 2);

end