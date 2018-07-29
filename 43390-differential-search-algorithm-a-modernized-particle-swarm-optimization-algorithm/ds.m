%
%
% DIFFERENTIAL SEARCH ALGORITHM (DSA) (in MATLAB)
% STANDARD VERSION of DSA (16.July.2013)
%
%
% usage : > ds(method,fnc,mydata,popsize,dim,low,up,maxcycle)
%
% method
%--------------------------------------------------------------
% 1: Bijective DSA (B-DSA)
% 2: Surjective DSA (S-DSA)
% 3: Elitist DSA (strategy 1) (E1-DSA)
% 4: Elitist DSA (strategy 2) (E2-DSA)
% if method=[. . . ...],   Hybrid-DSA (H-DSA)
%--------------------------------------------------------------
% example : 
% ds(1,'circlefit',mydata,10,3,-10,10,2000) ; % B-DSA
% ds(2,'circlefit',mydata,10,3,-10,10,2000) ; % S-DSA
% ds(3,'circlefit',mydata,10,3,-10,10,2000) ; % E1-DSA
% ds(4,'circlefit',mydata,10,3,-10,10,2000) ; % E2-DSA
% ds([1 2],'circlefit',mydata,10,3,-10,10,2000) ; % Hybrid-DSA, in this case B-DSA and S-DSA are hybridized.
%--------------------------------------------------------------
% Please cite this article as;
% P.Civicioglu, "Transforming geocentric cartesian coordinates to geodetic coordinates by using differential search algorithm",  Computers & Geosciences, 46 (2012), 229-247.
% P.Civicioglu, "Understanding the nature of evolutionary search algorithms", Additional technical report for the project of 110Y309-Tubitak,2013, Ankara, Turkey.
%
% 
%
%
%--------------------------------------------------------------
%{
19.March.2013
Copyright Notice
Copyright (c) 2012, Pinar Civicioglu
All rights reserved.
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution
      
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
%}


function ds(method,fnc,mydata,size_of_superorganism,size_of_one_clan,low_habitat_limit,up_habitat_limit,epoch)

% size_of_superorganism ; size of population.
% size_of_one_clan ; size of problem dimension (1,2,3,...,d), where each clan (i.e. sub-superorganism) includes d-individuals.
% mydata ; additional parameters for objective function, use mydata=[], if it is not needed. See Best-Fit Circle example (circlefit.m) for usage of mydata.

%Initialization

% control of habitat limits
if numel(low_habitat_limit)==1,
    low_habitat_limit=low_habitat_limit*ones(1,size_of_one_clan);
    up_habitat_limit=up_habitat_limit*ones(1,size_of_one_clan);
end


% generate initial individuals, clans and superorganism.
superorganism=genpop(size_of_superorganism,size_of_one_clan,low_habitat_limit,up_habitat_limit);
% success of clans/superorganism
fit_superorganism=feval(fnc,superorganism,mydata);


for epk=1:epoch
    

    % SETTING OF ALGORITHMIC CONTROL PARAMETERS
    % Trial-pattern generation strategy for morphogenesis; 'one-by-one morphogenesis'. 
    % p1=0.0*rand;  % i.e.,  0.0 <= p1 <= 0.0
    % p2=0.0*rand;  % i.e.,  0.0 <= p2 <= 0.0
    
    % Trial-pattern generation strategy for morphogenesis; 'one-or-more morphogenesis'. (DEFAULT)
    p1=0.3*rand;  % i.e.,  0.0 <= p1 <= 0.3
    p2=0.3*rand;  % i.e.,  0.0 <= p2 <= 0.3
    
    %-------------------------------------------------------------------
    
   [direction,msg]=generate_direction(method(randi(numel(method))),superorganism,size_of_superorganism,fit_superorganism);
    
   map=generate_map_of_active_individuals(size_of_superorganism,size_of_one_clan,p1,p2);
          
  %-------------------------------------------------------------------
    % Recommended Methods for generation of Scale-Factor; R 
    % R=4*randn;  % brownian walk
    % R=4*randg;  % brownian walk
    % R=lognrnd(rand,5*rand);  % brownian walk
     R=1./gamrnd(1,0.5);   % pseudo-stable walk
    % R=1/normrnd(0,5);    % pseudo-stable walk

    %-------------------------------------------------------------------
    
    % bio-interaction (morphogenesis) 
    stopover=superorganism+(R.*map).*(direction-superorganism);


   % Boundary Control
    stopover=update(stopover,low_habitat_limit,up_habitat_limit); 
    
    % Selection-II
    fit_stopover=feval(fnc,stopover,mydata);
    ind=fit_stopover<fit_superorganism; 
    fit_superorganism(ind)=fit_stopover(ind); 
    superorganism(ind,:)=stopover(ind,:);

    
   % update results
    [globalminimum,indexbest]=min(fit_superorganism);
    globalminimizer=superorganism(indexbest,:);
    
    % export results
    assignin('base','globalminimum',globalminimum);
    assignin('base','globalminimizer',globalminimizer);
    fprintf('%s  | %5.0f   --->   %10.16f\n',msg,epk,globalminimum)
        
end


function pop=genpop(a,b,low,up)
pop=ones(a,b);
for i=1:a
    for j=1:b 
        pop(i,j)=rand*(up(j)-low(j))+low(j);
    end
end


function p=update(p,low,up)
[popsize,dim]=size(p);
for i=1:popsize
    for j=1:dim
        % first (standard)-method
        if p(i,j)<low(j), if rand<rand, p(i,j)=rand*(up(j)-low(j))+low(j); else p(i,j)=low(j); end, end
        if p(i,j)>up(j),  if rand<rand, p(i,j)=rand*(up(j)-low(j))+low(j); else p(i,j)=up(j); end, end
        
        %{
       %  second-method
        if rand<rand,                    
            if p(i,j)<low(j) || p(i,j)>up(j), p(i,j)=rand*(up(j)-low(j))+low(j); end
        else
            if p(i,j)<low(j), p(i,j)=low(j); end
            if p(i,j)>up(j),  p(i,j)=up(j); end            
        end
        %}
    end        
end


function [direction,msg]=generate_direction(method,superorganism,size_of_superorganism,fit_superorganism);
 switch method
        case 1,            
            % BIJECTIVE DSA  (B-DSA) (i.e., go-to-rnd DSA);             
            % philosophy: evolve the superorganism (i.e.,population) towards to "permuted-superorganism (i.e., random directions)" 
            direction=superorganism(randperm(size_of_superorganism),:); msg=' B-DSA';
        case 2,    
            % SURJECTIVE DSA (S-DSA) (i.e., go-to-good DSA)
            % philosophy: evolve the superorganism (i.e.,population) towards to "some of the random top-best" solutions
            ind=ones(size_of_superorganism,1); 
            [null_,B]=sort(fit_superorganism); 
            for i=1:size_of_superorganism, ind(i)=B(randi(ceil(rand*size_of_superorganism),1)); end; 
            direction=superorganism(ind,:);  msg=' S-DSA';   
        case 3,
            % ELITIST DSA #1 (E1-DSA) (i.e., go-to-best DSA)
            % philosophy: evolve the superorganism (i.e.,population) towards to "one of the random top-best" solution
            [null,jind]=sort(fit_superorganism); ibest=jind(ceil(rand*size_of_superorganism)); msg='E1-DSA'; 
            direction=repmat(superorganism(ibest,:),[size_of_superorganism 1]); 
        case 4,
            % ELITIST DSA #2 (E2-DSA) (i.e., go-to-best DSA)
            % philosophy: evolve the superorganism (i.e.,population) towards to "the best" solution
            [null_,ibest]=min(fit_superorganism); msg='E2-DSA';
            direction=repmat(superorganism(ibest,:),[size_of_superorganism 1]);             
 end
return
 
 
function map=generate_map_of_active_individuals(size_of_superorganism,size_of_one_clan,p1,p2);
    % strategy-selection of active/passive individuals
    map=zeros(size_of_superorganism,size_of_one_clan);
        if rand<rand,
            if rand<p1, 
                % Random-mutation #1 strategy
                for i=1:size_of_superorganism
                    map(i,:)=rand(1,size_of_one_clan) < rand;              
                end
            else
                % Differential-mutation strategy
                for i=1:size_of_superorganism 
                    map(i,randi(size_of_one_clan))=1;
                end
            end
        else
             % Random-mutation #2 strategy
            for i=1:size_of_superorganism                
                map(i,randi(size_of_one_clan,1,ceil(p2*size_of_one_clan)))=1;                
            end
        end
return