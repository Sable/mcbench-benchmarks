function [hillCoeff ec50]=doseResponse(dose,response)

% DOSERESPONSE     Computes the Hill Coefficient and EC50 of a
% dose/response relationship given two vectors describing the doses and
% responses. A semilog graph is plotted illustrating the relationship, upon
% which the man and standard error of the response to each dose level is
% plotted along with the fitted Hill Equation sigmoid. The EC50 is also
% labelled. Requires nlinfit from statistics toolbox.
%
%   Example
%       d=[3.75 3.75 3.75 3.75 3.75 7.5 7.5 7.5 7.5 15 15 15 15 15 60 60 60 60]
%       r=[107 91 99 124 100 96 92 133 119 84 66 86 106 91 52 37 10 69]
%       [hill ec50]=doseResponse(d,r)
%
%   Inputs
%       Two vectors of the same length, the first containing the dose and
%       the second the response. If doses of 0 are contained in the data,
%       these are used as control values and the data are normalised by
%       their mean value.
%
%   Notes
%       This function was written to rapidly produce simple dose/response curves
%       and EC50s for publication.

%deal with 0 dosage by using it to normalise the results.
normalised=0;
if (sum(dose(:)==0)>0)
    %compute mean control response
    controlResponse=mean(response(dose==0));
    %remove controls from dose/response curve
    response=response(dose~=0)/controlResponse;
    dose=dose(dose~=0);
    normalised=1;
end

%hill equation sigmoid
sigmoid=@(beta,x)beta(1)+(beta(2)-beta(1))./(1+(x/beta(3)).^beta(4));

%calculate some rough guesses for initial parameters
minResponse=min(response);
maxResponse=max(response);
midResponse=mean([minResponse maxResponse]);
minDose=min(dose);
maxDose=max(dose);

%fit the curve and compute the values
[coeffs,r,J]=nlinfit(dose,response,sigmoid,[minResponse maxResponse midResponse 1]);

ec50=coeffs(3);
hillCoeff=coeffs(4);

%plot the fitted sigmoid
xpoints=logspace(log10(minDose),log10(maxDose),1000);
semilogx(xpoints,sigmoid(coeffs,xpoints),'Color',[0 0 0],'LineWidth',2)
hold on

%notate the EC50
text(ec50,mean([coeffs(1) coeffs(2)]),[' \leftarrow ' sprintf('EC_{50}=%0.2g',ec50)],'FontSize',16);

%plot mean response for each dose with standard error
doses=unique(dose);
meanResponse=zeros(1,length(doses));
stdErrResponse=zeros(1,length(doses));
for i=1:length(doses)
    responses=response(dose==doses(i));
    meanResponse(i)=mean(responses);
    stdErrResponse(i)=std(responses)/sqrt(length(responses));
    %stdErrResponse(i)=std(responses);
end

errorbar(doses,meanResponse,stdErrResponse,'o','Color',[0.5 0.5 0.5],'LineWidth',2,'MarkerSize',12)

%label axes
xlabel('Dose','FontSize',16);
if normalised
    ylabel('Normalised Response','FontSize',16);
else
    ylabel('Response','FontSize',16);
end
set(gca,'FontSize',16);

hold off;