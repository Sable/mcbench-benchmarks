function FillBetween(Xdata,YLower,YUpper,AreaColor,Alpha)

if size(Xdata) == size(YLower)
    fill([vertcat(Xdata,Xdata(end:-1:1))],[vertcat(YLower,YUpper(end:-1:1))],AreaColor,'FaceAlpha',Alpha);
else
    warning('MATLAB:InvlaidArgumentSize','The size of the input is not consistent');
end
