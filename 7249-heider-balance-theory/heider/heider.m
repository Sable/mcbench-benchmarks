function a = heider(adj2, iterasi)
%%
% Simulate the Heiderian Balance of Graph
% Before simulation, you must prepare the adjacency matrix in your
% spreadshet. The NxN adjacency matrix exhibit the value of the edges
% (representing the sentiment among NxN individuals. 
% After loading the adjacency matrix into the workspace (simply by
% double clicking the spreadsheet file in the current directory), thenafter
% you may run this function. 
% 
% Input: 1. adjacency matrix NxN
%        2. Number of iteration you want
% 
% Output: figure before and after the simulation
% Example: in the workspace you have adjacancy matrix in variable 'adj'
% ex.: adj = [0 0 -1; 1 0 1; 0 1 0];
% if you want to iterate the graph upto 20 iterations,
% type: >> heider(adj,20);
% 
% For Further Information refer the related paper:
% http://www.bandungfe.net/wp2004/2004n.pdf
% 
% Citation information of the paper:
% Khanafiah, Deni & Situngkir, Hokky. (2004). Social Balance Theory: 
% Revisiting Heider's Balance Theory for Many Agents. Working Paper WPN2004.
% Bandung Fe Institute. 
% 
% Hokky Situngkir & Deni Khanafiah
% Bandung Fe Institute, Indonesia
% BFI, May 2004
%%



                    %%%%%%%%%%%%%% VARIABEL GRAF %%%%%%%%%%%%%%
                    
N=length(adj2);                                   % Number of agents
matrik = 1:1:N;     

edges = combntns(matrik,2);
byk_edges = length(edges);
adj=zeros(N);

for i=1:1:byk_edges
    adj(edges(i,1), edges(i,2)) = adj2(edges(i,1), edges(i,2));
end

for i=1:1:N
    for j=1:1:N
        if adj(i,j) ~= 0
            adj(j,i)=adj(i,j);           % ADJACENCY MATRIX 
        end
    end
end


triad = combntns(matrik,3);
byk_triad = max(size(triad));
total_tri = zeros(byk_triad,8);


                    %%%%%%%%%%%%%% VARIABEL SIMULASI %%%%%%%%%%%%%%
indeks_balans = zeros(iterasi,1);
adj_awal = adj;
for i=1:1:iterasi
    
    hubungan = zeros(byk_edges,3);
    for m=1:1:byk_edges
        hubungan(m,3)=adj(edges(m,1), edges(m,2));
        hubungan(m,1) = edges(m,1);
        hubungan(m,2) = edges(m,2);
    end
    
    for j=1:1:byk_triad             % TRIAD MATRIX FORMATION
        total_tri(j,1) = j;
        total_tri(j,2) = triad(j,1);                                             %\
        total_tri(j,3) = triad(j,2);                                             % )> NODES
        total_tri(j,4) = triad(j,3);                                             %/
        total_tri(j,5) = adj(triad(j,1),triad(j,2));                             %\
        total_tri(j,6) = adj(triad(j,1),triad(j,3));                             % )> EDGE'S WEIGHTS
        total_tri(j,7) = adj(triad(j,2),triad(j,3));                             %/
        total_tri(j,8) = total_tri(j,5) * total_tri(j,6) * total_tri(j,7);    % NILAI TRIAD
    end
        
    indeks_balans(i)=balans(adj);;                %  COLLECTIVE BALANCE
    
    % Catatan awal...
    if i==1
        hubungan_awal = hubungan;
        triad_awal = total_tri;
    end
    
    % Mulai optimisasi...
    mutasi=randint(1,1,byk_edges)+1;    
    mutasi1=hubungan(mutasi,1);
    mutasi2=hubungan(mutasi,2);
    
    q=0;
    bal_lokal1=0;
    for j=1:1:byk_triad
        if (total_tri(j,2)==mutasi1 & total_tri(j,3)==mutasi2) | (total_tri(j,2)==mutasi1 & total_tri(j,4)==mutasi2) | (total_tri(j,3)==mutasi1 & total_tri(j,4)==mutasi2) 
            bal_tetangga = total_tri(j,8);
            q=q+1;
            if bal_tetangga == 1
                bal_lokal1 = bal_lokal1+1;
            end
        end
    end
    bal_lokal1=bal_lokal1/q;
    
    if hubungan(mutasi,3)==0
        hubungan(mutasi,3)=randint(1,1,3)-1;
    else 
        hubungan(mutasi,3)=hubungan(mutasi,3)*(-1);
    end
    memori=adj(hubungan(mutasi,1), hubungan(mutasi,2));
    adj(hubungan(mutasi,1), hubungan(mutasi,2)) = hubungan(mutasi,3);
    adj(hubungan(mutasi,2), hubungan(mutasi,1)) = hubungan(mutasi,3);
    
    q=0;
    bal_lokal2=0;
    for j=1:1:byk_triad
        if (total_tri(j,2)==mutasi1 & total_tri(j,3)==mutasi2) | (total_tri(j,2)==mutasi1 & total_tri(j,4)==mutasi2) | (total_tri(j,3)==mutasi1 & total_tri(j,4)==mutasi2) 
            q=q+1;
            bal_tetangga = adj(triad(j,1),triad(j,2)) * adj(triad(j,1),triad(j,3)) * adj(triad(j,2),triad(j,3));
            if bal_tetangga == 1
                bal_lokal2 = bal_lokal2 + 1;
            end
        end
    end
    bal_lokal2=bal_lokal2/q;
                
    if bal_lokal2<bal_lokal1
        adj(hubungan(mutasi,1), hubungan(mutasi,2)) = memori;
        adj(hubungan(mutasi,2), hubungan(mutasi,1)) = memori;
    end
    indeks_balans(i+1)=balans(adj);
%     if indeks_balans(i+1)==1
%         break;
%     end
    
end

plot(indeks_balans);
title('The balance of graphs throughout the iterations');

graf(adj_awal)
title('INITIAL CONDITION OF THE GRAPH');

graf(adj)    
title('FINAL CONDITION OF THE GRAPH');
    
