function [std_ratio2]=stand_dev_ratio2(observed_data,yearly_corrected_precip)

% after interannual correction, the monthly variability is somewhat overestimated.
% this program is desiged to estimate the overestimation of monthly std of
% precip between before yearly adjusted and after yearly adjusted

% calulate the overestimation of monthly std (before yearly adjusted/ after yearly adjusted)
% calculate std of monthly adjusted precipitation (before yearly adjusted)

% calculate the std of observed monthly precipitation
load(observed_data)
s=size(P,1);
monthly_observed=zeros(s,12);
for i=1:s
    monthly_observed(i,1)=sum(P(i,1:31));
    monthly_observed(i,2)=sum(P(i,32:59));
    monthly_observed(i,3)=sum(P(i,60:90));
    monthly_observed(i,4)=sum(P(i,91:120));
    monthly_observed(i,5)=sum(P(i,121:151));
    monthly_observed(i,6)=sum(P(i,152:181));
    monthly_observed(i,7)=sum(P(i,182:212));
    monthly_observed(i,8)=sum(P(i,213:243));
    monthly_observed(i,9)=sum(P(i,244:273));
    monthly_observed(i,10)=sum(P(i,274:304));
    monthly_observed(i,11)=sum(P(i,305:334));
    monthly_observed(i,12)=sum(P(i,335:365));
end
for i=1:12
    monthly_std_observed(1,i)=std(monthly_observed(:,i));
end

% calculate std of monthly adjusted precipitation (after yearly adjusted)
load(yearly_corrected_precip)
m=size(yearly_corrected_precip,1);
yearly_adjusted_after=zeros(m/365*12,1); 
j=1;
yearly_adjusted_after(1,1)=yearly_corrected_precip(1,4);
for i=2:m
    if yearly_corrected_precip(i,2)==yearly_corrected_precip(i-1,2)
        yearly_adjusted_after(j,1)=yearly_adjusted_after(j,1)+yearly_corrected_precip(i,4);
    else
        j=j+1;
        yearly_adjusted_after(j,1)=yearly_corrected_precip(i,4);
    end
end  
yearly_adjusted_after=reshape(yearly_adjusted_after,12,[]);
for i=1:12
    monthly_std_after(1,i)=std(yearly_adjusted_after(i,:));
end

% calculte the ratio of monthly std that yearly adjusted before to yearly
% adjusted after
std_ratio=zeros(1,12);
for i=1:12
%     std_ratio(1,i)=monthly_std_before(1,i)/monthly_std_after(1,i);
      std_ratio(1,i)=monthly_std_observed(1,i)/monthly_std_after(1,i);
end
std_ratio2=std_ratio;
save('std_ratio2','std_ratio2')