function[gamma_s] = arfima_covs(uptolag,params1,arma_part)
%approximated ACF for ARFIMA(p,d,q) processes
%
% (c) György Inzelt 2011
%
%extracting the parameters
wn_var = params1(length(params1));
%muZ = params1(length(params1)-1);

d = params1(1,1);     
     if  arma_part(1) == 0 && arma_part(2) == 0, phi = params1(1,2:2+arma_part(1)-1)    ; theta =0;
       elseif arma_part(1) ==0 && arma_part(2) ~= 0 ,theta = params1(1,2:2+arma_part(2)-1)   ; phi =0;
       elseif arma_part(1) ~=0 && arma_part(2) ~=0, phi = params1(1,2:2+arma_part(1)-1);
              theta = params1(1,2+arma_part(1):2+sum(arma_part)-1);
       elseif arma_part(1) ~=0 && arma_part(2)==0, phi = params1(1,2:2+arma_part(1)-1);theta =0;       
     end     

gamma_s = zeros(uptolag,1);
%%%%%%%%%%%%%%%%%%%%%%%%%
switch(sum(arma_part))
    case(0)
%ARFIMA(0,d,0)
        for h = 0:uptolag-1
            if h < 100
            gamma_s(h+1) =  wn_var*(gamma(1-2*d)*gamma(h+d)/(gamma(1-d)*gamma(d)*gamma(1+h-d)));
            elseif h>=100
            gamma_s(h+1) = ((h+d)/(1+h-d))*gamma_s(h);
            end
        end
             
    otherwise
        if arma_part(1) ==0 && arma_part(2)~=0
        %ARFIMA(0,d,q)
        %the MA part
  
            theta = [1 theta];
            psilag = zeros(2*length(theta)-1,1);
            gamma_term = zeros(uptolag,2*length(theta)-1);

        for ll = -length(theta):1:length(theta)
            for ss = max([0 ll]):min([(length(theta)-1)  (length(theta)-1+ ll)])
                ss_minus_ll = ss - ll;
    
                if ss_minus_ll < 0, ss_minus_ll = abs(ss_minus_ll) + 1;
                    elseif ss_minus_ll >= 0, ss_minus_ll = ss_minus_ll +1;  
                end   
    
                psilag(ll + length(theta))  = psilag(ll + length(theta)) + theta( ss_minus_ll )*theta(ss+1);  
            
            end
        end
            theta = theta(2:length(theta));
    %the fractional part
        for h = 0:uptolag-1
            if h < 100
                for ll = -length(theta):1:length(theta)
                    gamma_term(h+1,ll + length(theta)+1) = (gamma(1-2*d)*gamma(d+h-ll))/(gamma(d)*gamma(1-d)*gamma(1+h-d-ll))    ; 
                end
                    gamma_s(h+1) = wn_var*sum(psilag'.*gamma_term(h+1,:),2) ;
            elseif h>=100
                for ll = -length(theta):1:length(theta) 
                    gamma_term(h+1,ll + length(theta)+1) = gamma_term(h,ll+length(theta)+1)*((d+h-ll)/(1+h-d-ll));
                end
                    gamma_s(h+1) = wn_var*sum(psilag'.*gamma_term(h+1,:),2) ;
            end
        end   
   elseif arma_part(1)~=0 
        %ARFIMA(p,d,q)
            gamma_s_temp = zeros(uptolag,1);
        for h = 0:uptolag+201
            if h < 100
            gamma_s_temp(h+1) =  wn_var*(gamma(1-2*d)*gamma(h+d)/(gamma(1-d)*gamma(d)*gamma(1+h-d)));
            elseif h>=100
            gamma_s_temp(h+1) = ((h+d)/(1+h-d))*gamma_s_temp(h);
            end
        end
        
        gamma_arma = arma_covs(201,params1(1,2:length(params1)),arma_part);
        
        gamma_s_temp =   [gamma_s_temp(201:-1:2) ; gamma_s_temp(1:length(gamma_s_temp))]   ;
            
        for k = 0:uptolag-1
          %%approximate algorithm for calculating the ACF of ARFIMA(p,d,q)
          gamma_s(k+1) = (1/wn_var)*sum( [gamma_s_temp(1+k:1+k+400 ) ].*[gamma_arma(201:-1:2);gamma_arma(1:201)]);
        end
        
        end
end
end