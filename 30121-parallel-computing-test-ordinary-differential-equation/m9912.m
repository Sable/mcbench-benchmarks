%% Parallel Computing  example / Obliczenia równolegle
nc=2 % number of cores or processors, nc = 1,2,3,...
     % ilosc rdzeni lub procesorów    nc = 1,2,3...
matlabpool(nc)  % opening parallel session for nc cores
                % otwarcie sesji równoleglej dla nc rdzeni
NumberOfWorkers=matlabpool('size') %  
tic        % timer start
%% Start of parallel for loop / Petla for dla obliczen równoleglych
parfor tt=10:20 
[~,~]=ode23('ode1000',[0,tt],[1,-1]); % solving ode from ode1000.m
          % rozwi¹zywanie równania rózniczkowego z pliku ode1000.m
% [~,~] zrezygnowano z zapamietania wyników obliczen
end
toc
%% Closing parallel session / Zamyka sesje równolegla dla nc rdzeni
matlabpool close force
NumberOfWorkers=matlabpool('size')