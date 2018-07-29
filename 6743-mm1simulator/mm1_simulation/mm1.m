%implementation of a simple M/M/1

queue_lim=200000;				 % system limit
arrival_mean_time(1:65)=0.01;    
service_mean_time=0.01;		     
sim_packets=750;                 %number of clients to be simulated 
util(1:65) = 0;
avg_num_in_queue(1:65) = 0;
avg_delay(1:65) = 0;
P(1:65) = 1;

for j=1:64 %loop for increasing the mean arrrival time
            
    arrival_mean_time(j+1)=arrival_mean_time(j) + 0.001;
    
num_events=2;						    

% initialization
sim_time = 0.0; 		    

server_status=0; 			
queue_size=0; 				
time_last_event=0.0;       

num_pack_insys=0;		 
total_delays=0.0;		  
time_in_queue=0.0;        
                          
time_in_server=0.0;       
delay = 0.0;
  
time_next_event(1) = sim_time + exponential(arrival_mean_time(j+1));
 
time_next_event(2) = exp(30);    
  
disp(['Launching Simulation...',num2str(j)]); 
 
while(num_pack_insys < sim_packets) 

min_time_next_event = exp(29); 
  type_of_event=0;       
    for i=1:num_events 


      if(time_next_event(i)<min_time_next_event)     
         min_time_next_event = time_next_event(i);    
         type_of_event = i;                           
      end;

  end

  if(type_of_event == 0)
     disp(['no event in time ',num2str(sim_time)]);
  end

  sim_time = min_time_next_event;    

time_since_last_event = sim_time - time_last_event;   
time_last_event = sim_time;   

   time_in_queue = time_in_queue + queue_size * time_since_last_event ; 
    
   time_in_server = time_in_server + server_status * time_since_last_event; 
  
 
  if (type_of_event==1) 
  
  %disp(['packet arrived']);
  % -------------------------larrival-------------------------
  time_next_event(1) = sim_time + exponential(arrival_mean_time(j+1)); 
  % epomenos xronos afiksis
  
  if(server_status == 1) 
     
     num_pack_insys = num_pack_insys + 1;
     queue_size = queue_size + 1 ; 
     
     if(queue_size > queue_lim)
        disp(['queue size = ', num2str(queue_size)]);
        disp(['System Crash at ',num2str(sim_time)]);
        pause
     end

     arr_time(queue_size) = sim_time;

  else 	
    
  
     server_status = 1;                     
     time_next_event(2) = sim_time + exponential(service_mean_time);
	  
   
  end
 
    
  elseif (type_of_event==2) 
      
      % ---------------service and departure---------------			
 
      if(queue_size == 0) 
        server_status = 0;                  
        time_next_event(2) = exp(30);  
    else
    
      
       queue_size = queue_size - 1;

       delay = sim_time - arr_time(1);
       total_delays = total_delays + delay;
      

       time_next_event(2) = sim_time + exponential(service_mean_time);
	
 
       for i = 1:queue_size
          arr_time(i)=arr_time(i+1);
       end
    
    end         
  
 end 

end 

%results output
util(j+1) = time_in_server/sim_time;
avg_num_in_queue(j+1) = time_in_queue/sim_time;
avg_delay(j+1) = total_delays/num_pack_insys;
P(j+1) = service_mean_time./arrival_mean_time(j+1);


end

%----------------------graphs--------------------------------
figure('name','mean number of clients in system diagram(simulated)');
plot(P,avg_num_in_queue,'r');
Xlabel('P');
Ylabel('mean number of clients');
axis([0 0.92 0 15]);

figure('name','mean delay in system diagram (simulated)');
plot(P,avg_delay,'m');
Xlabel('P');
Ylabel('mean delay (hrs)');
axis([0 0.92 0 0.15]);

figure('name', 'UTILISATION DIAGRAM');
plot(P,util,'b');
Xlabel('P');
Ylabel('Utilisation');
axis([0 0.92 0 1]);



