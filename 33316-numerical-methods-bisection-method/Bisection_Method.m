%% Satendra Kumar
%  National Institute of Technology, India
%  Email:satendra.svnit@gmail.com 

clc    
syms x;      
func = input('Please enter a expression for f(x):');      
xl = input('Please enter the stating point of the interval :');   
xu = input('Please enter the end point of the interval :');            
decimalplaces=input ('Please enter the number of decimal places :');   
 
function_value_at_xl=subs(func,x,xl)            
function_value_at_xu=subs(func,x,xu)            
check_limits=function_value_at_xl*function_value_at_xu;    
sprintf('f(%f)*f(%f) = %f',xl,xu,check_limits)     
 
i=0;       
while(1)   
    disp('Iteration =') 
    disp(i)  
    sprintf('\nThe Interval is [%f,%f]',xl,xu) 
    xr=(xl+xu)/2        
    termination_check=abs(xl-xr);  
    sprintf('Termination Condition:\n|xl-xr| = |%f - %f| = %f ',xl,xr,termination_check)   
    if (termination_check<.5*10^-decimalplaces)  
           break
     end
   
    
    function_value_at_xr=subs(func,x,xr)    
    function_value_at_xl=subs(func,x,xl)    
    check=function_value_at_xr*function_value_at_xl; 
    sprintf('function value at xr * function value at xl=%f',check) 
    if(check<0) 
        disp('Therefore root lies in lower sub-interval')
        xu=xr   
    end
    if (check>0) 
        disp('Therefore root lies in upper sub interval')
        xl=xr;      
    end
   
     i=i+1;  
         
  end
    disp('-------------Solution---------------');
    sprintf('Ans=%f',xr)
    
            
        
            
