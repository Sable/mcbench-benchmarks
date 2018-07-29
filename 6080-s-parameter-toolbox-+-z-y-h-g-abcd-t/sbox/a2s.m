function s = a2s(a)

% S = a2s(ABCD)
%
% ABCD to Scattering transformation
% only for 2x2xF matrices
%
% 3-d version 4 nov 1999
% octave support added 31.05.2005

if size(size(a),2) > 2
    nF = size(a,3);
else nF = 1;
end;

for i=1:nF
    d(i) = a(1,1,i) + a(1,2,i) + a(2,1,i) + a(2,2,i);
    while abs(d(i)) < 1e-8
        fcki = 1+round(rand);
        fckj = 1+round(rand);
        a(fcki, fckj,i) = a(fcki, fckj,i)*(1+rand*1e-8);
        d(i) = a(1,1,i) + a(1,2,i) + a(2,1,i) + a(2,2,i);
    end;
end;

if exist('OCTAVE_VERSION')
    for i=1:nF
        trace = (a(1,1,i) + a(1,2,i) - a(2,1,i) - a(2,2,i));
        s(1,1,i) = trace/d(i);
        trace = 2*(a(1,1,i).*a(2,2,i) - a(1,2,i).*a(2,1,i));
        s(1,2,i) = trace/d(i);
        s(2,1,i) = 2/d(i);
        trace = (- a(1,1,i) + a(1,2,i) - a(2,1,i) + a(2,2,i));
        s(2,2,i) = trace/d(i);
    end;
else
    trace(1,:) = (a(1,1,:) + a(1,2,:) - a(2,1,:) - a(2,2,:));
    s(1,1,:) = trace./d;
    trace(1,:) = 2*(a(1,1,:).*a(2,2,:) - a(1,2,:).*a(2,1,:));
    s(1,2,:) = trace./d;
    s(2,1,:) = 2./d;
    trace(1,:) = (- a(1,1,:) + a(1,2,:) - a(2,1,:) + a(2,2,:));
    s(2,2,:) = trace./d;
end;