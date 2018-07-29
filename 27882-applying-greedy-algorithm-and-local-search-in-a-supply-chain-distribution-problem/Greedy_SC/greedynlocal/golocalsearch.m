function newobjectivesolution = golocalsearch(inputquantityshipped, quantityshipped,objectivesolution);
nosp = 5;         %reads the number of sales points considered
global nopd salespointresiduals
noft = 4;         %reads the number of factories
%nopd = 6;         %number of planning period
trkcap = 70;      %Capacity of the truck

%***********************inputs from excel file for the formulation ***************

demand = [35 35	60	80	100; 25	100	125	55	20; 150	120	100	60	110; 50	70	40	140	40 ; 90	110	90	50	30;0	110	90	40	50; 60	70	0	110	10; 140	70	90	100	30 ;10	130	130	40	140; 30	90	70	40	0; 70	100	100	50	90; 110	50	50	110	100]; %stores the demand in the time horizons for each sales point 
lostdemandcost = [30	35	25	40	55] ;  %lost demand per unit for each sales point
transcost = [ 100	400	800	1100    1700 ; 1500	1800	1200	2200	1500 ; 1400	1000	400	1000	700 ; 800	700	900	700	1200] ; %xlsread('greedyinput','Sheet1','O3:S6');        %transportation cost matrix
setupcost = [ 4500	2000	2500	3000 ] ;  %setup costs for individual factories
factorycap = [300	500	250	150]; % xlsread('greedyinput','Sheet2','B4:E4');       %capacity of the factories
factholdcost = [5	2	4	3]; %xlsread('greedyinput','Sheet2','B5:E5');     %holding cost per unit in a factory
salesholdingcost = [ 12 14 23 50 8];
for i = 1:nopd
quantityshipped{i} = zeros(noft,nosp);
factoryresiduals{i} = zeros(1,noft);
factoryactivation{i} = zeros(1,noft);
salespointresiduals{i} = zeros(1,nosp);
end


%****************************starts the calculation of the greedy alg********

initlostsales = calclostsales(demand,lostdemandcost,nopd,nosp); %Calculates the lost demand with the initial assumption that all the demand is lost
%disp(initlostsales);
cumsetupcost = 0;
cumtransportcost = 0;
cumholdingcost = 0;
cumsalesholding = 0;
saveddemand = 0;
salespoint{nosp}= [0,0]; 
for ft = 1:noft                                          %Initialize the factory activation status and residual for each time preiod (zero for the first one)
           factory{ft}(1,1) = 0;
           factory{ft}(1,2) = 0;
end
for time = 1:nopd                                               %iterates for each planning period beginning from the 1st
    
                                                               
       
       for sp = 1:nosp
            salespoint{sp}(1,1) = 0;                             %the array stores the activation status and the demand of a sales point 
            salespoint{sp}(1,2) =  inputquantityshipped(time,sp);             %this populates the sales point for a time horizon with shipping demand filling status
            salespoint{sp}(1,3) = 0;                                           % represents the residual at each sales point 
            salespoint{sp}(1,4) = demand(time,sp);                            %this is the actual demand requested at the sales point
       end
       
             
       for ft = 1:noft                                          %Initialize the factory activation status and residual for each time preiod (zero for the first one)
           factory{ft}(1,1) = 0;
           
       end
       
   
    for points = 1:nosp
        [selectedsp,maxlostsales] = choosesalespt(lostdemandcost,salespoint,nosp);             %Chooses the salespoint with the highest possible lost sales
%         disp('----------------------------');
%         fprintf('Selected Sales Point: %d\n', selectedsp);
%         fprintf('Potential Lost Sales cost: %.2f\n', maxlostsales);
        
        salespoint{selectedsp}(1,1)=1;
%         if (points >1)
%         previousiteration  = points-1;
%         else
%             previousiteration = points;
%         end
%          for nfact = 1:noft
%              factoryresidualseachit{time}(points,nfact)=  factoryresidualseachit{time}(previousiteration,nfact);
%          end
if (salespoint{selectedsp}(1,3) < salespoint{selectedsp}(1,4))      %this part executes if the salespoint has a residual less than the demand required
            [costunit,selectedf] = choosefactory(factorycap,factholdcost,transcost,setupcost,factory,trkcap,salespoint,selectedsp); %chooses the preferable factory to deliver to the selected salespoint
%             fprintf('selected factory: %d\n',selectedf);
%             fprintf('Cost of the selected factory: %.2f\n', costunit);
            quantityshipped{time}(selectedf,selectedsp) = salespoint{selectedsp}(1,2);
            if (factory{selectedf}(1,2)>= salespoint{selectedsp}(1,2))
            factory{selectedf}(1,2) = factory{selectedf}(1,2) - salespoint{selectedsp}(1,2);
            
            
%             factoryresidualseachit{time}(points,selectedf)=  factory{selectedf}(1,2);
            % saveddemand = saveddemand + salespoint{selectedsp}(1,2)*lostdemandcost(selectedsp);                             % accumulates the reduction of the lost demand for each sent item to a destination sales point
            end
            if(factory{selectedf}(1,1)==0 && factory{selectedf}(1,2)<= salespoint{selectedsp}(1,2)) 
                factory{selectedf}(1,2) = factory{selectedf}(1,2)+factorycap(selectedf)-salespoint{selectedsp}(1,2);
%                 factoryresidualseachit{time}(points,selectedf)=  factory{selectedf}(1,2);
                cumsetupcost = cumsetupcost + setupcost(selectedf);                                                         %accumulates the activation cost for each factory when there is an accompanying activation
               % cumtransportcost = cumtransportcost + ceil(salespoint{selectedsp}(1,2)/trkcap)*transcost(selectedf,selectedsp);
                factory{selectedf}(1,1)=1;                
            end
            salespoint{selectedsp}(1,3) = salespoint{selectedsp}(1,3)+ salespoint{selectedsp}(1,2)-salespoint{selectedsp}(1,4);
end

            saveddemand = saveddemand + salespoint{selectedsp}(1,4)*lostdemandcost(selectedsp);
            cumtransportcost = cumtransportcost + ceil(salespoint{selectedsp}(1,2)/trkcap)*transcost(selectedf,selectedsp); %accumulates the transportaton cost for each iteration
                     
%             fprintf('Cumulative setupcost: %.2f\n',cumsetupcost);
%             fprintf('Cumulative trasportation cost: %.2f\n',cumtransportcost);
    end
    currentholdingcost = 0;
    currentsalesholding = 0;
    for i = 1:noft
        currentholdingcost= currentholdingcost + factory{i}(1,2)*factholdcost(i);                                        %the holding costs are accumulatedat each factory at the end of each planning period
        
        factoryresiduals{time}(i) = factory{i}(1,2);
        factoryactivation{time}(i) = factory{i}(1,1);
        factory{i}(1,1)= 0;
    end
    for i = 1:nosp
    currentsalesholding = currentsalesholding + salespoint{i}(1,3)*salesholdingcost(i);
    salespointresiduals{time}(i) = salespoint{i}(1,3);
    end
    cumsalesholding = cumsalesholding + currentsalesholding;
    cumholdingcost = cumholdingcost + currentholdingcost;                                                                  % holding cost of the whole factory at the end of a planning period                                                                
    end
%objectivesolution = initlostsales-saveddemand+cumsetupcost+cumtransportcost
newobjectivesolution =  initlostsales - saveddemand + cumholdingcost+cumsetupcost+cumtransportcost+cumsalesholding;
end
