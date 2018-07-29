function [output_signal,output_time] = mvstat_Matlab_2007(Inputdata_signal,Inputdata_time,windowrange,reductionrange,fn)
%------------ Introduction ----------------------
%This file is created to calculate the mathematical operation like 'max' 
%on a pre-defined window range and with a pre-defined reduction range of an vector data.
%This function will need the following inputs in order to calculate the
%wished results:
%   1- Inputdata_signal: A vector containg your Y-Values that need to be
%   filtered.
%   2- Inputdata_time: A vector containg your x-Values that need to be
%   filtered (Normally is a time signal where the sampling rate can be
%   extracted).
%   3- windowrange: in unit of time (s) is the range to calculate the needed
%   mathematical function (The moving range ex. mvmean(y,x,0.02,0.02) or mvrms(y,x,0.02,0.02))
%   4- reductionrange: in unit of time (s) is the scalling reference for
%   the new data
%   5- fn : is used to define the wished mathmatical operation (ex. @max, @min, @mean, @rms, @int)
%The relation between the windowrange input and the reductionrange input 
%must be an integer value of 1:1.2:1..10:1. If not the reductionrange would 
%be corrected to get one of those relation. this specification give us the 
%possibility to calculate the 'mvstat_final' without using a for-Loop which will save a whole amount of time
% for example:
% fn = @mean
% [output_signal,out_put_time] = mvstat_final (y,x,10,10)
% the moving average will be calculated as a result of this function. every
% 10 s the mean value for the last 10 s will be calculated.
% fn = @max
% [output_signal,out_put_time] = mvstat_final (y,x,20,10)
% the moving max will be calculated as a result of this function. every
% 10 s the maximum value for the last 20 s will be calculated.
% fn = @min
% [output_signal,out_put_time] = mvstat_final (y,x,5,10)
% the moving min will be calculated as a result of this function. every
% 10 s the minmum value for the last 5 s will be calculated.
%Notice: when the input values of windowrange and reductionrange are not
%the same then at the beginning of the calculation the fn value of the a
%available data will be calculated.
% Is m.file will also allows you to calculate the intgration of your input
% data in a spesific windowrange. in this case the reductionrange input
% should be defined as in the example:
%fn = @int;
%[Ua_sin,Ua_sin_time] = mvstat(Ua_sin,U1_time,(1/f_grid),delta_t,fn); Ua_sin = Ua_sin*2*f_grid;
% in this example the integration of your input data (in this case U1_sin)
% will be calculated ever one period (normally this mean 0.02 s or 1/50 or
% 1/f_grid in our case). and then the reductionrange is in this case equal
% to the sampling time of the inputdata (delta = U1_time(2)-U1_time(1)).
% this work was done in order to bring FAMOS (IMC) software function into
% matlab.
%Auther: Msc.Eng. Aubai Alkhatib
%Datum: 10.09.2013
%-------- End of introduction ------------------
delta = Inputdata_time(2)-Inputdata_time(1);
length_window = windowrange/delta;
length_reduction = reductionrange/delta;
time = Inputdata_time(end);
if windowrange > reductionrange
    number = windowrange/reductionrange;
    integer = floor(number);
    fract = number-integer;
    if fract >= 0.5
        A = windowrange/(integer+1);
    else
        A = windowrange/(integer);
    end
    reductionrange_new = A;
    integer_A = floor(A);
    fract_A = A-integer_A;
    [ttoo,b] = rat(A);
    if b > 1
        length_reduction_new = round(reductionrange_new/delta);
    else
        length_reduction_new = reductionrange_new/delta;
    end
    i = length_reduction_new;
    ii = 1;
    output = zeros();
    while i < length(Inputdata_signal)
        if i >= length_window
            if fract_A == 0
                switch func2str(fn)
                    case 'mean'
                        output(ii) = mean(Inputdata_signal((i-length_window)+1:i));
                    case 'max'
                        output(ii) = max(Inputdata_signal((i-length_window)+1:i));
                    case 'sum'
                        output(ii) = sum(Inputdata_signal((i-length_window)+1:i));
                    case 'min'
                        output(ii) = min(Inputdata_signal((i-length_window)+1:i));
                    case 'int'
                        output(ii) = sum(Inputdata_signal((i-length_window)+1:i))*reductionrange_new;
                    otherwise
                        output(ii) = rms(Inputdata_signal((i-length_window)+1:i));
                end
            else
                switch func2str(fn)
                    case 'mean'
                        output(ii) = mean(Inputdata_signal((i-length_window):i));
                    case 'max'
                        output(ii) = max(Inputdata_signal((i-length_window):i));
                    case 'sum'
                        output(ii) = sum(Inputdata_signal((i-length_window):i));
                    case 'min'
                        output(ii) = min(Inputdata_signal((i-length_window):i));
                    case 'int'
                        output(ii) = sum(Inputdata_signal((i-length_window)+1:i))*reductionrange_new;
                    otherwise
                        output(ii) = rms(Inputdata_signal((i-length_window):i));
                end
            end
        else
            switch func2str(fn)
                case 'mean'
                    output(ii) = mean(Inputdata_signal(1:i));
                case 'max'
                    output(ii) = max(Inputdata_signal(1:i));
                case 'sum'
                    output(ii) = sum(Inputdata_signal(1:i));
                case 'int'
                    output(ii) = sum(Inputdata_signal(1:i))*reductionrange_new;
                case 'min'
                    output(ii) = min(Inputdata_signal(1:i));
                otherwise
                    output(ii) = rms(Inputdata_signal(1:i));
            end
        end
        i = i + length_reduction_new;
        ii = ii + 1;
    end
    
    if strcmp(func2str(fn),'int')
        output_signal = output(length_window:length(output));
        output_time = windowrange:reductionrange_new:(length(output)*reductionrange_new);
    elseif isinteger(reductionrange_new)
        output_signal = output;
        output_time = 0:reductionrange_new:(length(output)*reductionrange_new)-reductionrange_new;
    else
        output_signal = output;
        output_time = 0:(length_reduction_new*delta):(length(output)*(length_reduction_new*delta))-(length_reduction_new*delta);
    end
elseif reductionrange > windowrange
    Length_Output = fix(time/windowrange);
    Length_Input_New = Length_Output*windowrange/delta;
    delta_new = length_window;
    delta_time = windowrange;
    Input_reshaped = reshape(Inputdata_signal(1:Length_Input_New),delta_new,Length_Input_New/delta_new);
    switch func2str(fn)
        case 'mean'
            output_signal = mean(Input_reshaped);
        case 'max'
            output_signal = max(Input_reshaped);
        case 'sum'
            output_signal = sum(Input_reshaped);
        case 'int'
            output = sum(Input_reshaped)*delta_time;
        case 'min'
            output_signal = min(Input_reshaped);
        otherwise
            output_signal = rms(Input_reshaped);
    end
    if strcmp(func2str(fn),'int')
        output_signal = output(length_window:length(output));
        output_time = windowrange:delta_time:(Length_Output*delta_time)-delta_time;
    else
        output_time = 0:delta_time:(Length_Output*delta_time)-delta_time;
    end
elseif windowrange == reductionrange
    Length_Output = fix(time/windowrange);
    Length_Input_New = Length_Output*reductionrange/delta;
    delta_new = length_reduction;
    delta_time = windowrange;
    Input_reshaped = reshape(Inputdata_signal(1:Length_Input_New),delta_new,Length_Input_New/delta_new);
    switch func2str(fn)
        case 'mean'
            output_signal = mean(Input_reshaped);
        case 'max'
            output_signal = max(Input_reshaped);
        case 'sum'
            output_signal = sum(Input_reshaped);
        case 'int'
            output = sum(Input_reshaped)*delta_time;
        case 'min'
            output_signal = min(Input_reshaped);
        otherwise
            output_signal = rms(Input_reshaped);
    end
    if strcmp(func2str(fn),'int')
        output_signal = output(length_window:length(output));
        output_time = windowrange:delta_time:(Length_Output*delta_time)-delta_time;
    else
        output_time = 0:delta_time:(Length_Output*delta_time)-delta_time;
    end
end
end