%% demls.m
%%
%% ir = demls(sinal,row,col,reps)
%%
%% Deconvolves the room response to a MLS excitation signal. An average of
%% several repetitions of the signal is done, excluding the first cicle.   
%% If the given excitation signal is stereo, it is assumed that the first
%% channel is the recorded room response and the second channel is the
%% excitation signal recorded through a closed loop.
%% If the give excitation signal is mono, the begin of the measurement is
%% determined with the room response signal.
%% The input are the excitation signal (sinal), the MLS permutation vectors
%% given by the "mlsXtap.m" function and the number of signal repetitions,
%% being two the minimum.
%% The output is the desired room impulse response.

function ir = demls(sinal,row,col,reps)

%%if  size(sinal,2) == 2
 %%   inicio = min(find(abs(sinal(:,2)) > max(abs(sinal(:,2)))/10));
%%elseif size(sinal,2) == 1
  %%  inicio = min(find(abs(sinal) > max(abs(sinal))/10));
%%end

%t = length(row);
%aux = sinal(inicio+t:end,1);
%media = zeros(t,1);

for n = 1:(reps-1)
    media = media + aux(1:t);
    aux(1:t)=[];
end
ir=media/(reps-1);

ir=ir(:);
ir=ir(row);
ir=[0; ir];
ir=fht(ir);
ir(1)=[];
ir=ir(col)/t;