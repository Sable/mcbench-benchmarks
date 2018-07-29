function Daylight_Savings = is_Daylight_Savings(Date)
%Function takes a date as a string in 'mm/dd/yyyy' format and outputs a
%logical, true if the date is during daylight savings time for that year. See
%definition of daylight savings time in the USA
Month = str2double(Date(1:2));
if (Month > 3) && (Month < 11) %If the month is between April and October, true
    Daylight_Savings = true;
elseif (Month < 3) || (Month == 12) %If month is January, February, or December, false
    Daylight_Savings = false;
elseif Month == 3 %If month is March
    Sunday_Vect = [];
    for i = 1:31 %Loop through all 31 days of March, finding the Sundays
        if i < 10
            Day_str = sprintf('0%s',num2str(i));
        else
            Day_str = num2str(i);
        end
        March_Date = sprintf('03/%s/%s',Day_str,Date(7:10)); %String of looping march date
        DOW = weekday(March_Date,'mm/dd/yyyy'); 
        if DOW == 1 %DOW is 1 if the day is a Sunday
            Sunday_Vect = [Sunday_Vect i];
        end
    end
    DS_Day = Sunday_Vect(2); %Take the 2nd Sunday in March
    My_Day = str2double(Date(4:5));
    if My_Day >= DS_Day %If on or after 2nd Sunday, true
        Daylight_Savings = true; 
    else
        Daylight_Savings = false;
    end
elseif Month == 11 %If month is November
    Sunday_Vect = [];
    for i = 1:30 %Loop through all 30 days of November, finding the Sundays
        if i < 10
             Day_str = sprintf('0%s',num2str(i));
        else
            Day_str = num2str(i);
        end
        Nov_Date = sprintf('11/%s/%s',Day_str,Date(7:10)); %String of looping november date
        DOW = weekday(Nov_Date,'mm/dd/yyyy'); 
        if DOW == 1 %DOW is 1 if the day is a Sunday
            Sunday_Vect = [Sunday_Vect i];
        end
    end
    DS_Day = Sunday_Vect(1); %Take the 1st Sunday of the month
    My_Day = str2double(Date(4:5));
    if My_Day < DS_Day %If it is before the 1st Sunday, true
        Daylight_Savings = true;
    else
        Daylight_Savings = false;
    end
end
end