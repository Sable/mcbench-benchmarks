%=======Traveling Salesman Problem Dynamic Programming Function ===========
%= This function solves the Traveling Salesman Problem (TSP) using Dynamic=
%= programming (DP).                                                      =
%= The function is based on the paper by Held and Karp from 1962. The DP  =
%= is guaranteed to provide the accurate (optimal) result to the TSP, but =
%= the time complexity of this algorithm is O(2^n n^2), which limits the  =
%= the use of this algorithm to 15 cities or less.                        =
%= NOTE: For reasonable runtime, please do not try to calculate a tour of =
%        more than 13 cities. DP is not for large sets of cities.         =
%= Inputs:                                                                =
%       Cities: an n-by-2 (or n-by-3) matrix of city locations. If this   =
%               input is not given, a set of 10 cities will be randomly   =
%               generated.                                                =
%       Dmatrix: This is an n-by-n matrix of the distances between the    =
%               cities. If not given, this matrix will be calculated at   =
%               initialization.                                           =
%= Outputs:                                                               =
%       OptimalTour: a vector with indices of the cities, according to the=
%               the optimal order of cities to visit. It is a closed tour =
%               that will return to city 1, which is assumed to be the    =
%               salesman's origin (depot).                                =
%=      mincost: the total length of the optimal route.                   =
%= Developed by: Elad Kivelevitch                                         =
%= Version: 1.0                                                           =
%= Date: 15 May 2011                                                      =
%==========================================================================

function [OptimalTour,mincost]=tsp_dp1(cities, Dmatrix)
% Initialization Process
if nargin==0
    cities=random('unif',0,100,10,2);
end
[NumOfCities,dummy]=size(cities);
Primes=primes(NumOfCities*10);

if nargin<2 %No Dmatrix used    
    D=diag(inf*ones(1,NumOfCities)); %Assign an inifinite cost to traveling from a city to itself
    for i=1:NumOfCities %Assign the distances between pairs of cities
        for j=i+1:NumOfCities
            D(i,j)=norm(cities(i,:)-cities(j,:));
            D(j,i)=D(i,j);
        end
    end
else
    D=Dmatrix;
end
NumOfDataSets=1;
for i=2:NumOfCities
    NumOfDataSets=NumOfDataSets+nchoosek(NumOfCities,i);
end
Data(NumOfDataSets).S=[];
Data(NumOfDataSets).l=0;
Data(NumOfDataSets).cost=inf;
Data(NumOfDataSets).pre=[];
Data(NumOfDataSets).m=[];
LookUpTable(NumOfDataSets)=0;
%Define a data structure that holds the following pieces of data we need
%for later. This data structure uses the same notation used in the paper 
%by Held and Karp (1962):
% S - the set of cities in the tour.
% l - the last city visited in the set S. 
% cost - the cost of a tour, which includes all city in S and ends at l.
%In addition, the following data items are used in the dataset for reducing
%runtime:
% Pre - the index of predecessor dataset, i.e. the one with Spre=S-{l}
% m - the city in S-{l} that yielded the lowest cost C(Spre,m)+D(m,l).
% This index will facilitate the generation of the optimal tour without
% further calculations.
Data(1).S=[1];
Data(1).l=1;
Data(1).cost=0;
Data(1).Pre=[];
Data(1).m=[];
for s=2:NumOfCities
    Data(s).S=[Data(1).S,s];
    Data(s).l=s;
    Data(s).cost=D(s,1);
    Data(s).Pre=1;
    Data(s).m=1;
    LUT=calcLUT(Data(s).S,s,Primes);
    LookUpTable(s)=LUT;
end
IndexStartPrevStep=2; %index into Data that marks the beginning of the previous step
IndexLastStep=NumOfCities; %index into Data that marks the end of the previous step
CurrentData=IndexLastStep; %index into Data that marks the current dataset

%This is the main Dynamic Programming loop
for s=3:NumOfCities
    %generate possible sets with s-1 cities out of the possible N-1 cities
    %(not including city 1)
    TempSets=nchoosek(2:NumOfCities,s-1);
    NumOfSets=size(TempSets);
    for j=1:NumOfSets(1) %iterate through all the sets
        for k=1:NumOfSets(2) %iterate through all the elements in each set
            SminuskSet=[1,TempSets(j,1:k-1),TempSets(j,k+1:NumOfSets(2))]; %this is the set S-{k}               
            candidatecost(2:length(SminuskSet))=inf;
            indices=[];
            for mm=2:length(SminuskSet) %choose a city in S-{k} that will be last
                LUV=calcLUT(SminuskSet,SminuskSet(mm),Primes);
                index=find(LUV==LookUpTable(IndexStartPrevStep:IndexLastStep));  
                index=index+IndexStartPrevStep-1;
                if index==0
                    candidatecost(mm)=inf;                    
                else
                    candidatecost(mm)=Data(index).cost+D(SminuskSet(mm),TempSets(j,k));
                    indices(mm)=index;
                end                
            end
            [mincost,indexcost]=min(candidatecost(2:end));
            CurrentData=CurrentData+1;
            Data(CurrentData).S=[1,TempSets(j,:)];
            Data(CurrentData).l=TempSets(j,k);
            Data(CurrentData).cost=mincost;
            Data(CurrentData).Pre=indices(indexcost+1);
            Data(CurrentData).m=SminuskSet(indexcost+1);
            LookUpTable(CurrentData)=calcLUT(Data(CurrentData).S,TempSets(j,k),Primes);
        end
    end
    IndexStartPrevStep=IndexLastStep+1;
    IndexLastStep=CurrentData;    
end
mm=0;
%Now add the distance back from the last city to city 1
for i=IndexStartPrevStep:IndexLastStep
    mm=mm+1;
    candidatecost(mm)=Data(i).cost+D(Data(i).l,1);
end
%Find the one that minimizes the total distance
[mincost,indexcost]=min(candidatecost);
Temp=Data(IndexStartPrevStep+indexcost-1);
%Generate the optimal tour by traversing back from the last city to its
%predecessors
OptimalTour=1;
while ~isempty(Temp.Pre)
    OptimalTour=[OptimalTour,Temp.l];
    Temp=Data(Temp.Pre);
end
OptimalTour=[OptimalTour,1];


function LUT=calcLUT(vec,last,Primes)
j=length(vec);
LUT=Primes(last);
for i=2:j
    LUT=LUT*Primes(vec(i));
end