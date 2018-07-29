function templot
global C_controller
global C_signal
global C_type
h = findall(0,'tag','edit2');
Ti = str2num(get(h,'string'));
h = findall(0,'tag','edit3');
Td = str2num(get(h,'string'));
switch C_signal
    case 1    %**step**%  
        switch C_type
            case 1    %**Single**%
                switch C_controller
                    case 1   %**P**%
                        Td=0;
                        Ti=0;
                        single_temp(Ti,Td);
                    case 2   %**P.I**% 
                        Td=0;
                        single_temp(Ti,Td);
                    case 3   %**P.I.D**% 
                        single_temp(Ti,Td);
                end
            case 2   %**inter**
                switch C_controller
                    case 1  %P*
                        Td=0;
                        Ti=0;
                        non_single_temp(Ti,Td);
                    case 2  %P.I**
                        Td=0;
                        non_single_temp(Ti,Td);
                    case 3  %P.I.D** 
                        non_single_temp(Ti,Td);
                end
            
        end
    case 2   %**impulse
        switch C_type
            case 1
                switch C_controller
                    case 1
                        Td=0;
                        Ti=0;
                        single_temp(Ti,Td);                       
                    case 2
                        Td=0;
                        single_temp(Ti,Td); 
                    case 3
                        single_temp(Ti,Td);
                end
            case 2
                switch C_controller
                    case 1
                        Td=0;
                        Ti=0;
                        non_single_temp(Ti,Td);   
                    case 2
                        Td=0;
                        non_single_temp(Ti,Td);  
                    case 3
                        non_single_temp(Ti,Td);
                end
           
        end
    case 3  %****sin
        switch C_type
            case 1
                switch C_controller
                    case 1
                        Td=0;
                        Ti=0;
                        single_temp(Ti,Td);
                    case 2
                        Td=0;
                        single_temp(Ti,Td);
                    case 3
                        single_temp(Ti,Td);
                end
            case 2
                switch C_controller
                    case 1
                        Td=0;
                        Ti=0;
                        non_single_temp(Ti,Td);  
                    case 2
                        Td=0;
                        non_single_temp(Ti,Td);
                    case 3
                        non_single_temp(Ti,Td);
                end
            
        end
end
end