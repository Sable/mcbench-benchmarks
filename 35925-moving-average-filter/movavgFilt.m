function Out = movavgFilt (In, Len, Param)
% The moving average filter operates by averaging a number of points from the
% input signal to produce each point in the output signal.  In equation form,
% this is written:
% 
%         1  M-1
% Y[i] = --- SUM X[i + j]
%         M  j=0
% Example Usage:
% t = 1:1/100:2;
% x1 = sin (2*pi*5*t);
% x2 = rand(1,101);
% In = x1 + x2;
% Param = 'Center';
% Len = 5;
% Out = movavgFilt (In, Len, Param);
% plot (t, x1); title ('Original Signal')
% figure
% plot (t, In); title ('Noisy Signal')
% figure
% plot (t, Out); title ('Filtered Signal')

Siz = size (In);
Siz_In = Siz (1, 2);

if (isequal (Param, 'Left'))
    Pad = zeros (1, Len - 1);
    New_In = [Pad In];
    for i = 1:Siz_In
        temp = 0;
        for j = 1:Len
            temp = temp + New_In(i + j - 1);
        end
        Out(i) = temp / Len;
    end
       
elseif (isequal (Param, 'Center'))
    len1 = mod (Len, 2);
    if isequal (len1, 0)
        error ('Cannot use the Len as an even number for this option. Use Left or Right');
    else
        Pad_Len = (Len - 1)/2;
        Pad = zeros (1, Pad_Len);
        New_In = [Pad In Pad];
        for i = 1:Siz_In
            temp = 0;
            for j = 1:Len
                temp = temp + New_In(i + j - 1);
            end
            Out(i) = temp / Len;
        end
    end
    
elseif (isequal (Param, 'Right'))
    Pad = zeros (1, Len - 1);
    New_In = [In Pad];
    for i = 1:Siz_In
        temp = 0;
        for j = 1:Len
            temp = temp + New_In(i + j - 1);
        end
        Out(i) = temp / Len;
    end
        
end

