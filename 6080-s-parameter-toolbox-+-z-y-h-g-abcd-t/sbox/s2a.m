function A = s2a(S);

% ABCD = s2a(S)
%
% Scattering to ABCD transformation
% only for 2x2 matrices
%
% 3-d version 4 nov 1999
% octave support added - 31.05.2005

if size(size(S),2) > 2
    nF = size(S,3);
else nF = 1;
end;

for i=1:nF
    d(i) = 2 * S(2,1,i);
    while abs(d(i)) < 1e-8
        S(2,1,i) = S(2,1,i)*(1+rand*1e-8);
        d(i) = 2* S(2,1,i);
    end;
end;

if exist('OCTAVE_VERSION')
    for i=1:nF
        trace = ((1 + S(1,1,i)) *(1 - S(2,2,i)) + S(1,2,i) * S(2,1,i));
        A(1,1,i) = trace /d(i);
        trace = ((1 + S(1, 1,i)) *(1 + S(2,2,i)) - S(1,2,i) * S(2,1,i));
        A(1,2,i) = trace /d(i);
        trace = ((1 - S(1, 1,i)) *(1 - S(2,2,i)) - S(1,2,i) * S(2,1,i));
        A(2,1,i) = trace /d(i);
        trace = ((1 - S(1, 1,i)) *(1 + S(2,2,i)) + S(1,2,i) * S(2,1,i));
        A(2,2,i) = trace /d(i);
    end;
else
    trace(1,:) = ((1 + S(1, 1,:)) .*(1 - S(2,2,:)) + S(1,2,:) .* S(2,1,:));
    A(1,1,:) = trace ./d;
    trace(1,:) = ((1 + S(1, 1,:)) .*(1 + S(2,2,:)) - S(1,2,:) .* S(2,1,:));
    A(1,2,:) = trace ./d;
    trace(1,:) = ((1 - S(1, 1,:)) .*(1 - S(2,2,:)) - S(1,2,:) .* S(2,1,:));
    A(2,1,:) = trace ./d;
    trace(1,:) = ((1 - S(1, 1,:)) .*(1 + S(2,2,:)) + S(1,2,:) .* S(2,1,:));
    A(2,2,:) = trace ./d;
end;