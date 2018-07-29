clc
clear all
tic
%***********************User inserted input for the problem***************

nosp = 5;             %reads the number of sales points considered
noft = 4;                %reads the number of factories
nopd = 3;         %number of planning period
trkcap = 70;                    %Capacity of the truck

%***********************inputs from excel file for the formulation ***************

demand = [35 35	60	80	100; 25	100	125	55	20; 150	120	100	60	110; 50	70	40	140	40 ; 90	110	90	50	30;0	110	90	40	50; 60	70	0	110	10; 140	70	90	100	30 ;10	130	130	40	140; 30	90	70	40	0; 70	100	100	50	90; 110	50	50	110	100 ]; %stores the demand in the time horizons for each sales point 
lostdemandcost = [30	35	25	40	55] ;  %lost demand per unit for each sales point
transcost = [ 100	400	800	1100	1700 ; 1500	1800	1200	2200	1500 ; 1400	1000	400	1000	700 ; 800	700	900	700	1200] ; %xlsread('greedyinput','Sheet1','O3:S6');        %transportation cost matrix
setupcost = [ 4500	2000	2500	3000 ] ;  %setup costs for individual factories
factorycap = [300	500	250	150]; % xlsread('greedyinput','Sheet2','B4:E4');       %capacity of the factories
factholdcost = [5	2	4	3]; %xlsread('greedyinput','Sheet2','B5:E5');     %holding cost per unit in a factory
for i = 1:nopd
quantityshipped{i} = zeros(noft,nosp);
factoryresiduals{i} = zeros(1,noft);
factoryactivation{i} = zeros(1,noft);
salespointresiduals{i} = zeros(1,nosp);
end

%*****************************counter-check if the inputs are well read*********

disp(demand);
disp(lostdemandcost);
disp(transcost);
disp(setupcost);
disp(factorycap);
disp(factholdcost);
for i = 1:nopd
disp(quantityshipped{i});
end


%****************************starts the calculation of the greedy alg********

initlostsales = calclostsales(demand,lostdemandcost,nopd,nosp); %Calculates the lost demand with the initial assumption that all the demand is lost
disp(initlostsales);
cumsetupcost = 0;
cumtransportcost = 0;
cumholdingcost = 0;
saveddemand = 0;
salespoint{nosp}= [0,0]; 
for ft = 1:noft                                          %Initialize the factory activation status and residual for each time preiod (zero for the first one)
           factory{ft}(1,1) = 0;
           factory{ft}(1,2) = 0;
end
for time = 1:nopd                                               %iterates for each planning period beginning from the 1st
    
                                                                
       
       for sp = 1:nosp
           salespoint{sp}(1,1) = 0;                             %the array stores the activation status and the demand of a sales point 
            salespoint{sp}(1,2) =  demand(time,sp);             %this populates the sales point for a time horizon with demand and filling status
       end
       
       
       
       
       for ft = 1:noft                                          %Initialize the factory activation status and residual for each time preiod (zero for the first one)
           factory{ft}(1,1) = 0;
           
       end
       
   % loadfactory(capacity,prevresidual);
   
    for points = 1:nosp
        [selectedsp,maxlostsales] = choosesalespt(lostdemandcost,salespoint,nosp);             %Chooses the salespoint with the highest possible lost sales
        disp('----------------------------');
        fprintf('Selected Sales Point: %d\n', selectedsp);
        fprintf('Potential Lost Sales cost: %.2f\n', maxlostsales);
        
        salespoint{selectedsp}(1,1)=1;
        
            [costunit,selectedf] = choosefactory(factorycap,factholdcost,transcost,setupcost,factory,trkcap,salespoint,selectedsp); %chooses the preferable factory to deliver to the selected salespoint
            fprintf('selected factory: %d\n',selectedf);
            fprintf('Cost of the selected factory: %.2f\n', costunit);
            quantityshipped{time}(selectedf,selectedsp) = salespoint{selectedsp}(1,2);
            if (factory{selectedf}(1,2)>= salespoint{selectedsp}(1,2))
            factory{selectedf}(1,2) = factory{selectedf}(1,2) - salespoint{selectedsp}(1,2);
            
            % saveddemand = saveddemand + salespoint{selectedsp}(1,2)*lostdemandcost(selectedsp);                             % accumulates the reduction of the lost demand for each sent item to a destination sales point
            end
            if(factory{selectedf}(1,1)==0 && factory{selectedf}(1,2)<= salespoint{selectedsp}(1,2))
                factory{selectedf}(1,2) = factory{selectedf}(1,2)+factorycap(selectedf)-salespoint{selectedsp}(1,2);
                cumsetupcost = cumsetupcost + setupcost(selectedf);                                                         %accumulates the activation cost for each factory when there is an accompanying activation
               % cumtransportcost = cumtransportcost + ceil(salespoint{selectedsp}(1,2)/trkcap)*transcost(selectedf,selectedsp);
                factory{selectedf}(1,1)=1;                
            end
            saveddemand = saveddemand + salespoint{selectedsp}(1,2)*lostdemandcost(selectedsp);
            cumtransportcost = cumtransportcost + ceil(salespoint{selectedsp}(1,2)/trkcap)*transcost(selectedf,selectedsp); %accumulates the transportaton cost for each iteration
            
            
            fprintf('Cumulative setupcost: %.2f\n',cumsetupcost);
            fprintf('Cumulative trasportation cost: %.2f\n',cumtransportcost);
    end
    currentholdingcost = 0;
    for i = 1:noft
        currentholdingcost= currentholdingcost + factory{i}(1,2)*factholdcost(i);                                         %the holding costs are accumulatedat each factory at the end of each planning period
        factoryresiduals{time}(i) = factory{i}(1,2);
        factoryactivation{time}(i) = factory{i}(1,1);
        factory{i}(1,1)= 0;
    end
    cumholdingcost = cumholdingcost + currentholdingcost;                                                                  % holding cost of the whole factory at the end of a planning period                                                                
    objectivesolution = initlostsales -saveddemand+ cumholdingcost+cumsetupcost+cumtransportcost
    end
%objectivesolution = initlostsales-saveddemand+cumsetupcost+cumtransportcost
%objectivesolution = initlostsales -saveddemand+ cumholdingcost+cumsetupcost+cumtransportcost
disp('====================shipped quantity matrix==================')
for i = 1:nopd
disp(quantityshipped{i});
end  
disp('=====================factory residual matrix=================')
for i = 1:nopd
disp(factoryresiduals{i});
end
disp('=====================factory activation status===============')
for i = 1:nopd
disp(factoryactivation{i});
end
objectivesolution
% New_transportation_costs=0;
% F_holding_cost=0;
% Act_cost= 0;
% for t=1:nopd
%     for i=1:noft
%         F_holding_cost = F_holding_cost + factholdcost(i) *factoryresiduals{t}(1,i); 
%         Act_cost = Act_cost + factoryactivation{t}(1,i)* setupcost(i);
%         
%         
%         for j =1:nosp
%     New_transportation_costs= ceil(quantityshipped{t}(i,j)/trkcap) * transcost(i,j)+ New_transportation_costs;
%         end
%     end
% end
% New_transportation_costs
% F_holding_cost
% Act_cost
% tot_cost = New_transportation_costs + F_holding_cost +Act_cost
% saveddemand
% initlostsales
% cumtransportcost
toc
        
