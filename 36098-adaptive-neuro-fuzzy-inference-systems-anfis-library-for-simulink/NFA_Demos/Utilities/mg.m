function y = mg(DataDuration)

% Mackey-Glass chaotic time series generator. 

NumOfSamples = DataDuration;
discarded = 350;
x = zeros(NumOfSamples + discarded + 1);
y = zeros(1,NumOfSamples);    % Each column represents different time instants.
Ts = 1;
x(1) = 1.2;
tau  = 17;

for n = tau+1:(NumOfSamples + discarded)
   x(n+1) = Ts*(0.2*x(n-tau)/( 1 + (x(n-tau))^10)) + (1 - 0.1*Ts)*x(n);
end

% plot(x);
% title('Mackey-Glass Chaotic Time Series');
% xlabel('Time Sample');
% ylabel('Estimated Value');


for k=1:NumOfSamples
   y(k) = x(discarded+k);
end
