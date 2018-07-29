function [OutSpec]=SumSpec(CellSpec,TotPart)

%% Adds spectra together?
%% RC Moffet, 2010
en=[280,320];

Spec=0;
cnt=0;
for i = 1:length(CellSpec) %% loop over average stack spectra
    enidx=find(CellSpec{i}(:,1)>=en(1) & CellSpec{i}(:,1)<=en(2)); %% Find C or O spectra
    if isempty(enidx)
        continue
    else
        if Spec==0 %% if this is the first spectrum
            Spec=CellSpec{i}(enidx,2); %% Initialize spectra to start averaging
            Specen=CellSpec{i}(enidx,1);
            cnt=cnt+1;
        elseif length(Spec)==length(CellSpec{i}(enidx)) %% if spectral resolutions are the same
            Spec=nansum([CellSpec{i}(enidx,2),Spec]')'; %% add last with current
            cnt=cnt+1;
        else  %% if the spectral resolutions are not the same
            sp=spline(Specen',Spec(:,1)');  %% interpolate
            Spec = nansum([ppval(sp,CellSpec{i}(enidx,1)')',...  %% evaluate interpolation at energies
                CellSpec{i}(enidx,2)]')';
            Specen=CellSpec{i}(enidx,1);
            cnt=cnt+1
        end
    end
end
% for i=1:length(CellSpec)
%      figure,plot(CellSpec{i}(:,1),CellSpec{i}(:,2));
% end

Spec=Spec/TotPart;
OutSpec=[Specen,Spec];



