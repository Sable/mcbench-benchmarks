% ************************************************************************
% Weather Generator Ecole de Technologie Superieure (WeaGETS)
% ************************************************************************
%
% WeaGETS is a Matlab-based versatile stochastic daily weather generator
% for producing daily precipitation, maximum and minimum temperatures 
% (Tmax and Tmin) series of unlimited length, thus permitting impact 
% studies of rare occurrences of meteorological variables. Furthermore, it 
% can be used in climate change studies as a downscaling tool by perturbing
% their parameters to account for expected changes in precipitation and 
% temperature. First, second and third-order Markov models are provided to 
% generate precipitation occurrence, and exponential and gamma distributions
% are available to produce daily precipitation quantity. Precipitation 
% generating parameters have options to be smoothed using Fourier harmonics.
% Two schemes (unconditional and conditional) are available to simulate
% Tmax and Tmin. Finally, a spectral correction approach is included to 
% correct the well-known underestimation of monthly and inter-annual 
% variability associated with weather generators.
%
%
% ****************************
% Input data
% ****************************
% The input data consists of daily precipitation, Tmax and Tmin. The model 
% does not take into account bissextile years. Any significant precipitation 
% occurring on a February 29th should be redistributed equally on February 
% 28th and March 1st. The maximum and minimum temperatures of a February 
% 29th can be simply removed. Missing data should be assigned a -999 value.
% The input file contains the following matrices and vectors: 
% (1)	P: matrix with dimensions [nyears*365], where nyears is the number 
%          of years, containing daily precipitation in mm.
% (2)	Tmax: matrix with dimensions [nyears *365], where nyears is the 
%             number of years, containing maximum temperature in Celsius.
% (3)	Tmin: matrix with dimensions [nyears *365], where nyears is the 
%             number of years, containing minimum temperature in Celsius.
% (4)	yearP: vector of length [nyears *1] containing the years covered 
%              by the precipitation.
% (5)	yearT: vector of length [nyears *1] containing the years covered 
%              by the Tmax and Tmin.
%
% ****************************
% Output data
% ****************************
% The output also consists of daily precipitation, Tmax and Tmin values. 
% It contains the following matrices:
% (1)	gP: matrix with dimensions [gnyears*365], where gnyears is the 
%           number of years of generated precipitation in mm without 
%           low-frequency variability correction.
% (2)	gTmax: matrix with dimensions [gnyears *365], where gnyears is the 
%              number of years of generated Tmax in Celsius without 
%              low-frequency variability correction. 
% (3)	gTmin: matrix with dimensions [gnyears *365], where gnyears is the 
%              number of years of generated Tmin in Celsius without 
%              low-frequency variability correction.
% If the low-frequency variability correction option is chosen, another 
% file will be produced. It also contains three matrices, named corP, 
% corTmax and corTmin, respectively.
% (1)	corP: matrix with dimensions [gnyears *365], where gnyears is the 
%             number of years of generated precipitation in mm with 
%             low-frequency variability correction.
% (2)	corTmax: matrix with dimensions [gnyears *365], where gnyears is 
%                the number of years of generated Tmax in Celsius with 
%                low-frequency variability correction. 
% (3)	corTmin: matrix with dimensions [gnyears *365], where gnyears is 
%                the number of years of generated Tmin in Celsius with 
%                low-frequency variability correction.
%
% ****************************
% Running the program
% ****************************
% There are many subprograms in the WeaGETS package, but the user only 
% needs to run the main program RUN_WeaGETS.m. All of the options will 
% then be offered in the form of questions, presented as follows: 
% (1)	Basic input
% a.	Enter an input file name (string):
% A name for the observed data shall be entered within single quotes, for 
% instance, ¡®filename¡¯ for the supplied file. 
% b.	Enter an output file name (string):
% A name for the generated data shall be entered within single quotes, for 
% example ¡®filename_generated¡¯. 
% c.	Enter a daily precipitation threshold:
% Precipitation threshold is the amount of precipitation used to determine 
% whether a given day is wet or not (0.1mm is the most commonly used value). 
% d.	Enter the number of years to generate:
% The number of years of the generated time series of precipitation and 
% temperatures is entered here.  
% (2)	Precipitation and temperature generation 
% a.	Smooth the parameters of precipitation occurrence and quantity (1)
%       or do not smooth (0). 
% b.	If option 1 is selected, enter the number of harmonics to be used 
%       (between 1 and 4). 
% c.	Select an order of Markov Chain to generate precipitation 
%       occurrence, 1: First-order; 2: Second-order; 3: Third-order.
% d.	Select a distribution to generate wet day precipitation amount: 
%       1: Exponential or 2: Gamma. 
% e.	Select a scheme to generate Tmax and Tmin: 1: Unconditional or 
%       2: Conditional.
% (3)	Low-frequency variability correction. 
% a.	Correct the low-frequency variability of precipitation, Tmax and 
%       Tmin (1) or do not correct (0).
% If option 1 is selected, a filename containing the corrected data will 
% need to be entered. 
% Once weather generation is completed, the first year of generated data 
% without and with the low-frequency variability correction will be plotted.
%
%
% It should be noted, due to sample number required by the spectral 
% correction method is an even, if the low-frequency variability correction
% is chosen, the years of observed time series must be an even and the years
% of generated data must be an integer multiple of the years of observe data.
%
% WeaGETS went through several iterations.  Prof. Robert Leconte (now at
% Sherbrooke University) wrote the original Matlab code based on WGEN
% (Richardson and Wright, 1984).  Prof. Francois Brissette then modified
% the code and streamlined it close to its current form.  Master student
% Annie Caron tested several aspects of the code and added higher order
% Markov Chains for precipitation occurrence (Caron et al., 2008).
% Finally, PhD student Jie Chen provided several additional options 
% including the correction scheme for the well know problem of the 
% underestimation of inter annual variability (Chen et al., 2010), and the 
% CLIGEN temperature scheme (Chen et al., 2010).
%
% References:
% (1) Caron, A., Leconte, R., Brissette, F.P, 2008. Calibration and 
% validation of a stochastic weather generator for climate change studies.  
% Canadian Water Resources Journal. 33(3): 233-256.
% (2) Chen J., Brissette, P.F., Leconte, R., 2011. Assessment and  
% improvement of stochastic weather generators in simulating maximum and 
% minimum temperatures.Transactions of the ASABE. (Under review)
% (3) Chen J., Zhang, X.C., Liu, W.Z., Li, Z., 2008. Assessment and  
% Improvement of CLIGEN Non-Precipitation Parameters for the Loess Plateau  
% of China.Transactions of the ASABE 51(3), 901-913.
% (4) Chen, J., Brissette, P.F., Leconte, R., 2010. A daily stochastic 
% weather generator for preserving low-frequency of climate variability.
% Journal of Hydrology 388, 480-490.
% (5) Chen, J., Brissette, P.F., Leconte, R., Caron, A. 2011. WeaGETS - a 
% Matlab-based daily scale weather generator for generating precipitation and
% temperature. Environmental modelling & software. (Under review)
% (6) Nicks, A.D., Lane, L.J., Gander, G.A., 1995. Weather generator, Ch. 2. 
% In USDA?Water Erosion Prediction Project: Hillslope Profile and Watershed
% Model Documentation, eds. D. C. Flanagan, and M. A. Nearing. NSERL Report
% No. 10. West Lafayette, Ind.: USDA-ARS-NSERL.
% (7) Richardson, C.W., 1981. Stochastic simulation of daily precipitation,
% temperature, and solar radiation. Water Resources Research 17, 182-190.
% (8) Richardson, C.W., Wright, D.A., 1984. WGEN: A model for generating 
% daily weather variables. U.S. Depart. Agr, Agricultural Research Service.
% Publ. ARS-8.


clear all
 
%% *****************************************
% basic input
% ******************************************

display('**********************************************************START********************************************************')
display('*******************************************************basic input*****************************************************')

% basic inputs include names of input and output files, daily precipitation
% threshold and a number of years for generated data
filenamein=input('Enter an input filename (string):');
filenameout=input('Enter an output filename (string):');
PrecipThreshold=input('Enter a daily precipitation threshold:');
GeneratedYears=input('Enter the number of years to generate:');

%% *****************************************
% precipitation and temperatures generation
% ******************************************

display('****************************************precipitation and temperatures generation**************************************')

% smooth the precipitation parameters or not
Smooth=input('Smooth the parameters of precipitation occurrence and quantity (1) or do not smooth (0):');
if Smooth==0   % without smooth scheme
    % three orders (first, second and third) of Markov Chain are provided 
    % to generate precipitation occurrence    
    MarkovChainOrder=input('Select an order of Markov Chain to generate precipitation occurrence,1: First-order; 2: Second-order or 3: Third-order:');
    % two distributions (exponential and gamma) are provided to generate wet
    % day precipitation quantity
    idistr=input('Select a distribution to generate wet day precipitation amount,1: Exponential or 2: Gamma:');
    % the parameters are analysed at 2 weeks scale for each option of
    % Markov Chain order
    if MarkovChainOrder==1  % first order Markov Chain
        [idistr,ap00,ap10,alambda,nu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,...
            sD2,PrecipThreshold,MarkovChainOrder]=analyzer_order1_norad_no(filenamein,PrecipThreshold,idistr);
    elseif MarkovChainOrder==2  % second order Markov Chain
        [idistr,ap000,ap010,ap100,ap110,alambda,nu,A,B,aC0,aC1,aC2,...
            aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,MarkovChainOrder]=analyzer_order2_norad_no...
            (filenamein,PrecipThreshold,idistr);
    elseif MarkovChainOrder==3  % third order Markov Chain
        [idistr,ap0000,ap0010,ap0100,ap0110,ap1000,ap1010,ap1100,...
            ap1110,alambda,nu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,...
            MarkovChainOrder]=analyzer_order3_norad_no(filenamein,PrecipThreshold,idistr);
    end
    % two schemes (uncorrelated and correlated) are provided to generate Tmax and Tmin
    TempScheme=input('Select a scheme to generate maximum and minimum temperatures,1: Unconditional or 2: Conditional:');
    % run weather generator to produce sythesize data 
    if MarkovChainOrder==1  % first order Markov Chain
        generator_order1_norad_no(filenameout,GeneratedYears,TempScheme,idistr,...
            ap00,ap10,alambda,nu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,...
            sD2,PrecipThreshold,MarkovChainOrder);
    elseif MarkovChainOrder==2  % second order Markov Chain
        generator_order2_norad_no(filenameout,GeneratedYears,TempScheme,...
            idistr,ap000,ap010,ap100,ap110,alambda,nu,A,B,aC0,aC1,aC2,...
            aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,MarkovChainOrder);
    elseif MarkovChainOrder==3  % third order Markov Chain
        generator_order3_norad_no(filenameout,GeneratedYears,TempScheme,idistr,...
            ap0000,ap0010,ap0100,ap0110,ap1000,ap1010,ap1100,ap1110,alambda,nu,A,B,...
            aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,MarkovChainOrder);
    end   
elseif Smooth==1 % with a smooth scheme
    % four options (first,second,third and fourth orders of Fourier harmonics)
    % are provided to smooth the parameters
    harm_order=input('Select an order of harmonics to smooth the parameters,1: First order;2: Second order;3: Third order or 4: Fourth order:');
    % three orders (first, second and third) of Markov Chain are provided
    % to generate precipitation occurrence
    MarkovChainOrder=input('Select an order of Markov Chain to generate precipitation occurrence,1: First order; 2: Second order or 3: Third order:');
    % two distributions (exponential and gamma) are provided to generate 
    % wet day precipitation quantity
    idistr=input('Select a distribution to generate wet day precipitation amount,1: Exponential or 2: Gamma:');
    % the parameters are analysed at 2 weeks scale for each option of
    % Markov Chain order
    if MarkovChainOrder==1  % first order Markov Chain
        [idistr,parp00,parp10,parlbd,parnu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,...
            sD2,PrecipThreshold,MarkovChainOrder]=analyzer_order1_norad(filenamein,...
            PrecipThreshold,idistr,harm_order);
    elseif MarkovChainOrder==2  % second order Markov Chain
        [idistr,parp000,parp010,parp100,parp110,parlbd,parnu,A,B,aC0,aC1,aC2,...
            aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,MarkovChainOrder]=...
            analyzer_order2_norad(filenamein,PrecipThreshold,idistr,harm_order);
    elseif MarkovChainOrder==3  % third order Markov Chain
        [idistr,parp0000,parp0010,parp0100,parp0110,parp1000,parp1010,parp1100,...
            parp1110,parlbd,parnu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,...
            MarkovChainOrder]=analyzer_order3_norad(filenamein,PrecipThreshold,idistr,harm_order);
    end
    % two schemes (uncorrelated and correlated) are provided to generate Tmax and Tmin
    TempScheme=input('Select a scheme to generate maximum and minimum temperatures,1: Unconditional or 2: Conditional:');
    % run weather generator to produce sythesize data
    if MarkovChainOrder==1  % first order Markov Chain
        generator_order1_norad(filenameout,GeneratedYears,TempScheme,idistr,...
            parp00,parp10,parlbd,parnu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,...
            sD2,PrecipThreshold,MarkovChainOrder);
    elseif MarkovChainOrder==2  % second order Markov Chain
        generator_order2_norad(filenameout,GeneratedYears,TempScheme,...
            idistr,parp000,parp010,parp100,parp110,parlbd,parnu,A,B,aC0,aC1,aC2,...
            aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,MarkovChainOrder);
    elseif MarkovChainOrder==3  % third order Markov Chain
        generator_order3_norad(filenameout,GeneratedYears,TempScheme,idistr,...
            parp0000,parp0010,parp0100,parp0110,parp1000,parp1010,parp1100,parp1110,...
            parlbd,parnu,A,B,aC0,aC1,aC2,aD1,aD2,sC0,sC1,sC2,sD1,sD2,PrecipThreshold,...
            MarkovChainOrder);
    end
end

%% *****************************************
% low-frequency variability correction
% ******************************************

display('********************************************low-frequency variability correction****************************************')

% correct the low-frequency variability of precipitation and temperatures or not
LowFrequency=input('Correct the low-frequency variability of precipitation and maximum and minimum temperatures (1) or do not correct (0):');
% the monthly and intenannual variability of precipitation and interannual
% variability of Tmax and Tmin are corrected used a power spectral scheme
if LowFrequency==1
    load(filenamein) % observed precipitation ans temperatures time series
    load(filenameout) % WeaGETS generated time series without low-frequency correction
    
    nn=size(gP,1)/size(P,1);
    if nn~=round(nn) % check the length of generted data whether equal to a integer multiples of observed data
        display('Note: When the low-frequency variability correction scheme is used,the length of generated data must be an integer')
        display('multiple of the observed. Please run the program again and enter a valid number of years for generation.');
        display('***********************************************************END**********************************************************')
        break
    else
        
        filenamecorrection=input('Enter a filename of low-frequency variability corrected data (string):');
        save('years_ratio','nn')
        monthly_yearly_data(filenamein) % calculate monthly and yearly precipitation and yearly Tmax and Tmin
        low_frequency_correction_precip(filenamein,filenameout); % correct monthly and interannual variability of precipitation
        interannual_correction_temp(filenamein,filenameout);% correct the interannual variability of maximum and minimum temperature
        load('yearly_corrected_precip') % read the precipitation after interannual variability correction
        corP=reshape(yearly_corrected_precip(:,4),365,[]);
        corP=corP';
        load('yearly_corrected_tmax')  % read the maximum temperature after interannual variability correction
        corTmax=reshape(yearly_corrected_tmax,365,[]);
        corTmax=corTmax';
        load('yearly_corrected_tmin')  % read the minimum temperature after interannual variability correction
        corTmin=reshape(yearly_corrected_tmin,365,[]);
        corTmin=corTmin';

        % plot the corrected data of the first year
        figure
        subplot(2,1,1)
        bar(1:365,corP(1,:))
        ylabel('daily precip. mm')
        titre=['Corrected daily precip of the first year'];
        title(titre)
        subplot(2,1,2)
        plot(1:365,corTmax(1,:),1:365,corTmin(1,:),'r-')
        ylabel(' air temp,oC')
        titre=['Corrected daily Tmax and Tmin of the first year'];
        title(titre)
        legend('Tmax','Tmin','Location','Best')

        save(filenamecorrection,'corP','corTmax','corTmin') % save the corrected data

        % delete the variables produced in the process of running this program
        delete monthly_corrected_precip.mat monthly_observed_P.mat phase_tmax.mat ... 
            Pnew_precip.mat Pnew1.mat Pnew2.mat Pnew3.mat Pnew4.mat Pnew5.mat ...
            Pnew6.mat Pnew7.mat Pnew8.mat Pnew9.mat Pnew10.mat Pnew11.mat ...
            Pnew12.mat Pnew_tmax.mat Pnew_tmin.mat std_ratio.mat std_ratio2.mat ... 
            yearly_corrected_precip.mat yearly_observed_P.mat yearly_observed_tmax.mat ...
            yearly_observed_tmin.mat years.mat years_ratio.mat yearly_corrected_tmax.mat ...
            yearly_corrected_tmin.mat
    end
end
display('************************************************************END*********************************************************')







 
 