function g_best=renewg_best(p_best,p_best_fit,N,Min_Max_flag,Gl_Lo_flag)
            
if Gl_Lo_flag == 1   %%% This part is for Global model          
    if Min_Max_flag == 1
        [m_g place_g]=min(p_best_fit);    % finding minimum
        g_best=p_best(place_g,:);
    else
        [m_g place_g]=max(p_best_fit);    % finding maximum
        g_best=p_best(place_g,:);
    end
else
    if Min_Max_flag == 1 %%% This part is for local model          
        for i=1:N
            if i==1
                temp_g=p_best_fit(N);
                temp_g(2:3)=p_best_fit(i:i+1,1);
                [min_g,place_g]=min(temp_g);     % finding minimum
                switch place_g
                    case 1
                        g_best(i,:)=p_best(N,:);
                    case {2,3}
                        g_best(i,:)=p_best(place_g+i-2,:);
                end
            elseif i==N
                temp_g=p_best_fit(1);
                temp_g(2:3)=p_best_fit(i-1:i,1);
                [min_g,place_g]=min(temp_g);   % finding minimum
                switch place_g
                    case 1
                        g_best(i,:)=p_best(1,:);
                    case {2,3}
                        g_best(i,:)=p_best(place_g+i-3,:);
                end
            else
                [min_g,place_g]=min(p_best_fit(i-1:i+1,1));  % finding minimum
                g_best(i,:)=p_best(place_g+i-2,:);
            end
        end
    else
        for i=1:N
            if i==1
                temp_g=p_best_fit(N);
                temp_g(2:3)=p_best_fit(i:i+1,1);
                [max_g,place_g]=max(temp_g);     % finding maximum
                switch place_g
                    case 1
                        g_best(i,:)=p_best(N,:);
                    case {2,3}
                        g_best(i,:)=p_best(place_g+i-2,:);
                end
            elseif i==N
                temp_g=p_best_fit(1);
                temp_g(2:3)=p_best_fit(i-1:i,1);
                [max_g,place_g]=max(temp_g);   % finding maximum
                switch place_g
                    case 1
                        g_best(i,:)=p_best(1,:);
                    case {2,3}
                        g_best(i,:)=p_best(place_g+i-3,:);
                end
            else
                [max_g,place_g]=max(p_best_fit(i-1:i+1,1));  % finding maximum
                g_best(i,:)=p_best(place_g+i-2,:);
            end
        end
    end
end