function dataout = removeoutliers(datain)
%REMOVEOUTLIERS   Remove outliers from data using the Thompson Tau method.
%   For vectors, REMOVEOUTLIERS(datain) removes the elements in datain that
%   are considered outliers as defined by the Thompson Tau method. This
%   applies to any data vector greater than three elements in length, with
%   no upper limit (other than that of the machine running the script).
%   Additionally, the output vector is sorted in ascending order.
%
%   Example: If datain = [1 34 35 35 33 34 37 38 35 35 36 150]
%
%   then removeoutliers(datain) will return the vector:
%       dataout = 33 34 34 35 35 35 35 36 37 38
%
%   See also MEDIAN, STD, MIN, MAX, VAR, COV, MODE.
%   This function was written by Vince Petaccio on July 30, 2009.
n=length(datain); %Determine the number of samples in datain
if n < 3
    display(['ERROR: There must be at least 3 samples in the' ...
        ' data set in order to use the removeoutliers function.']);
else
    S=std(datain); %Calculate S, the sample standard deviation
    xbar=mean(datain); %Calculate the sample mean
    %tau is a vector containing values for Thompson's Tau
    tau = [1.150 1.393 1.572 1.656 1.711 1.749 1.777 1.798 1.815 1.829 ...
        1.840 1.849 1.858 1.865 1.871 1.876 1.881 1.885 1.889 1.893 ...
        1.896 1.899 1.902 1.904 1.906 1.908 1.910 1.911 1.913 1.914 ...
        1.916 1.917 1.919 1.920 1.921 1.922 1.923 1.924];
    %Determine the value of S times Tau
    if n > length(tau)
        TS=1.960*S; %For n > 40
    else
        TS=tau(n)*S; %For samples of size 3 < n < 40
    end
    %Sort the input data vector so that removing the extreme values
    %becomes an arbitrary task
    dataout = sort(datain);
    %Compare the values of extreme high data points to TS
    while abs((max(dataout)-xbar)) > TS 
        dataout=dataout(1:(length(dataout)-1));
        %Determine the NEW value of S times Tau
        S=std(dataout);
        xbar=mean(dataout);
        if length(dataout) > length(tau)
            TS=1.960*S; %For n > 40
        else
            TS=tau(length(dataout))*S; %For samples of size 3 < n < 40
        end
    end
    %Compare the values of extreme low data points to TS.
    %Begin by determining the NEW value of S times Tau
        S=std(dataout);
        xbar=mean(dataout);
        if length(dataout) > length(tau)
            TS=1.960*S; %For n > 40
        else
            TS=tau(length(dataout))*S; %For samples of size 3 < n < 40
        end
    while abs((min(dataout)-xbar)) > TS 
        dataout=dataout(2:(length(dataout)));
        %Determine the NEW value of S times Tau
        S=std(dataout);
        xbar=mean(dataout);
        if length(dataout) > length(tau)
            TS=1.960*S; %For n > 40
        else
            TS=tau(length(dataout))*S; %For samples of size 3 < n < 40
        end
    end
end

%vjp