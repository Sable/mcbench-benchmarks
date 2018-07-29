%ARMASA version 1.9
%==================
%   
%An AutoRegressive Moving Average Spectral Analysis toolbox for use 
%with Matlab.
%
%Release date: May 20, 2009
%
%The core of ARMASA consists of four programs: ARMASEL, ARMA2PSD, 
%ARMA2COR and MODERR. ARMASEL is a unique program, that is able to 
%estimate a time series model from a stationary stochastic signal with 
%unknown characteristics, without any user intervention. The automatic 
%estimation and selection of either an AR, a MA, or an ARMA model is 
%based on statistical criteria and defines a model with an expected 
%minimum model error. This model can be used to generate an optimal 
%power spectral density estimate, using ARMA2PSD, or alternatively, an 
%optimal autocorrelation function estimate, using ARMA2COR. MODERR is a 
%quality measure that can be used in simulation experiments to verify 
%the goodness of fit of the estimated model. Moreover it can be applied 
%in type selection applications, where estimated models from signal 
%segments are confronted with reference processes.
%
%The core programs rely on a set of additional programs, bundled in the 
%package, that can also be used individually. 
%A group of programs, bundled in directory 
%'\ARMASA\ASA' carrying the prefix ASA, are used to support the main 
%programs, without implementing any time series algorithm.
%
%Additional information is provided on ARMASA functions. It is 
%summarized in the outline below:
%
%Demonstration
%-------------
%
%  demo_armasa        - Demonstration of some ARMASA toolbox features
%  demo_tutor         - Demonstration of some ARMASA toolbox features
%  demo_simple        - Demonstration of core ARMASA toolbox statements
%
%Main functions
%--------------
%
%Core
%  armasel            - ARMAsel model identification
%  arma2cor           - ARMA parameters to autocorrelations
%  arma2psd           - ARMA parameters to power spectral density
%  arma2pred          - ARMA parameters to prediction
%  moderr             - Model error
%
%Estimation
%  sig2ar             - AR model identification
%  sig2ma             - MA model identification
%  sig2arma           - ARMA model identification
%  ASAglob_subtr_mean - Subtraction of signal mean
%  ASAglob_mean_adj   - Subtraction of the signal mean identifier
%  ASAglob_ar_cond    - ARMA/MA to AR order selection conditioning
%
%Estimator Tools
%  Burg               - Burg type AR estimator
%  Burg_s             - Burg type AR estimator for multiple data segments
%  cic                - CIC finite sample order selection criterion
%
%Parameter Conversion
%  ar2arset           - AR parameters to optimal lower-order AR models
%  rc2arset           - AR reflectioncoefficients to AR models
%  cov2arset          - AR autocovariances to AR models
%
%Signal Processing
%  armafilter         - Digital filter with ARMA filter coefficients
%  simuarma           - Generating data with ARMA filter coefficients
%  convol             - Convolution sum
%  convolrev          - Convolution sum with one vector reversed
%  deconvol           - Deconvolution
%
%Support Functions
%-----------------
%
%  ASAarg             - Input argument arrangement
%  ASAcontrol         - Function control variable
%  ASAglob            - Variables with a global scope
%  ASAglobretr        - ASAglob variable retrieval
%  ASAversionchk      - Function version check
%  ASAversion2numstr  - Version identifier to number as string type
%  ASAversionbkup     - Version-tagged function backup
%  ASAwarn            - Warning string from numbered file
%  ASAerr             - Error string from numbered file
