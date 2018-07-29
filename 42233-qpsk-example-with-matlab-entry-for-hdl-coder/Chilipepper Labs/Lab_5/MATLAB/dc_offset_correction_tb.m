clear all

fid = fopen('dc.prn');
M = textscan(fid,'%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d','Headerlines',1);
%M = textscan(fid,'%d %d %d %d','Headerlines',1);
fclose(fid);
is = double(M{3});
qs = double(M{4});

l = zeros(1,length(is));

figure(1)
clf
subplot(2,1,1)
plot(is)
hold on
plot(l,'g');
title('Original: Inphase');
subplot(2,1,2)
plot(qs)
hold on
plot(l,'g');
title('Original: Quadrature');

disp(['Original Mean I: ',num2str(mean(is)),' Mean Q: ',num2str(mean(qs))]);


% L is the recovery time of the filter, i.e., it takes about that many
% samples for it to recover. 
% Becuase an averaging COMB filter is essentially a high pass filter it is
% best to have an offset in frequency above DC in order to be able to keep
% the filter length as short as possible
Ns = length(is);
io = zeros(1,Ns);
qo = zeros(1,Ns);
rssi = zeros(1,Ns);
ff_in = 2^3/2^12*2^12;
rssiH = 0;
for i1 = 1:length(is)
    i_in = is(i1);
    q_in = qs(i1);
 
    [i_out, q_out, rssi_out, rssi_en_out, dir_out, dir_en_out] = ...
        dc_offset_correction(i_in, q_in, 1, mod(i1,2), 500, 1500, i1>3000);
    
    io(i1) = i_out;
    qo(i1) = q_out;
    if rssi_en_out
        rssiH = rssi_out;
    end
    rssi(i1) = rssiH;
end

figure(2)
clf
subplot(2,1,1)
plot(io)
hold on
plot(l,'g');
title('Corrected: Inphase');
subplot(2,1,2)
plot(qo)
hold on
plot(l,'g');
title('Corrected: Quadrature');

disp(['Corrected Mean I: ',num2str(mean(io)),' Mean Q: ',num2str(mean(qo))]);

figure(3)
clf
s = complex(io,qo);
plot(s.*conj(s),'r')
hold on
plot(rssi,'b');
title('rssi');
