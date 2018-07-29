% Nomenclature
% ---------------
% st1 => singleton type-1 FLS
% fcs => forecasted series
% mydata => MG time series sample data


% TO RUN
% ---------
% mydata = mgts(3000);
% n = 0;
% RMSE = ttsf(mydata)

function fcs = st1(mydata, n)

for i = 1:504                           % Training Data points 504
    tgd(i) = mydata(i+n);
end

k = 0;
for i = 1:500
    for j = 1:5
        s(i, j) = tgd(k+j);
    end
    k = k+1;
end

M = 500;                             % No. of Rule pairs
x = 0:.01:2;
% hold on;
for j = 1:M
    fs1 = gaussmf(x, [0.1 s(j, 1)]);
    fs2 = gaussmf(x, [0.1 s(j, 2)]);
    fs3 = gaussmf(x, [0.1 s(j, 3)]);
    fs4 = gaussmf(x, [0.1 s(j, 4)]);
    fs5 = gaussmf(x, [0.1 s(j, 5)]);
    R(j, :) = fs1.*fs2.*fs3.*fs4.*fs5;
    Memg(j) = max(R(j, :));
%     plot(x, R(j,:))
end
% hold off;


for j=1:M
    for i = 1:201
        if max(R(j, i)) == max(R(j, :))
            y(j) = i*0.01;        
        end
    end
end


% Height Defuzzification Method

Snum = 0;
Sden = 0;
for j = M
    Snum = Snum+y(j)*Memg(j);
    Sden = Sden + Memg(j);
end
HDfuzz = Snum/Sden;

fcs = HDfuzz;

% -----------------------------------------
% For Better Display
% -----------------------------------------
dsp = n;
disp('~~~~~~~')
disp(' ')
disp('  FCast  ')
disp (dsp)

% -------------------------------------------------
% End of st1(mydata, n)
% -------------------------------------------------