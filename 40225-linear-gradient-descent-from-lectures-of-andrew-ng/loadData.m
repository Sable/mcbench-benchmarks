function [ data ] = loadData( type )
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

    if(strcmp(type,'2Dset'))
         x=textscan(fopen('2Dset.txt'),'%f/%f');
         data=cell2mat(x);
         scatter(data(:,1),data(:,2));
    end

end

