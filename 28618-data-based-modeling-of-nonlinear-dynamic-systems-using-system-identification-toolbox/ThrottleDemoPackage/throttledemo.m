%% Data Based Modeling of Nonlinear Dynamic Systems

%   Copyright 2009-2010 The MathWorks, Inc.

% This demo discusses some popular data-driven modeling techniques using
% the engine throttle body as an example. Data collected by testing on the
% throttle is used for estimation of a variety of linear and nonlinear
% models. The models are created both from purely data-centric
% considerations as well as using knowledge from first principles. Various
% types of models available in System Identification Toolbox are described. 
%
% This demo is command-line based, that is, it discusses how one can write
% MATLAB commands that would perform the task of creating dynamic models
% using data-driven techniques. For GUI-centric approaches, see the
% document titled "Data Based Modeling of Nonlinear Dynamic Systems".
% It is recommended that you read that document before using MATLAB file
% anyway, since it provides many useful insights into the art of data-based
% modeling.

%% Data Preparation
% The following script loads raw data sets, decimates them and uses them to
% create IDDATA objects that are used with System Identification Toolbox. 
dataprep

%% Estimating Linear Models
% For linear analysis, we need a data set where the signals are constrained
% in the linear operating range of the system. The closest data set we have
% is data3:
plot(data3)

% The output barely touches the hard stops at 90 degrees, but when the
% input excitation is removed, it still shows an offset of 15 degrees. A
% linear model cannot capture such offsets. So to turn this data into
% something "suitable" for linear model estimation, we must subtract off
% the offset.
T = getTrend(data3);
T.OutputOffset = 15;
data3lin = detrend(data3, T);
plot(data3, data3lin)

%% Linear ARX Model
% Let us estimate a model of the form Ay = Bu + e, where A is a second
% order polynomial and B is a constant:
mlin1 = arx(data3lin, [2 1 0], 'Focus', 'simulation')

% Estimate a linear "output error" model which is represented by equation y
% = B/F u e. This is the well-known "transfer function" model of the
% system. We try two different sets of orders for polynomials B and F
% assuming input delay = 0.
% 
% Try [nb nf nk] = [2 2 0]
mlin2 = oe(data3lin, [2  2  0]);

%% 
% Try [nb nf nk] = [4 4 0]
mlin3 = oe(data3lin, [4 4 0]);

%%
% Note that we did not have to set the focus explicitly to 'simulation' for
% output error models mlin2 and mlin3 because there is no difference
% between prediction and simulation errors for such models.

%%
% Next we try linear state-space models. We need to specify the order of
% the system which is the number of states in the model. Suppose we do not
% know that. We can specify a range of values (say 1 to 10) and the
% software will suggest an optimal value based on analysis of Hankel
% singular values.
mlin4 = n4sid(data3lin, 1:10, 'nk',0, 'Focus', 'simulation');

%%
% We select order = 3. Thus mlin4 is a state-space model containing 3
% states. For comparison, let us also estimate a 2nd and a 4th order
% state-space models:
mlin5 = n4sid(data3lin, 2, 'nk', 0, 'Focus', 'simulation');
mlin6 = n4sid(data3lin, 4, 'nk', 0, 'Focus', 'simulation');

%%
% The above linear models were all discrete-time. If you want
% continuous-time models, you can convert the above models into
% continuous-time using the "d2c" command. Also, System Identification
% Toolbox provides "process models", represented by IDPROC objects, that
% are directly created in continuous-time. Let us create a continuous-time
% model containing 3 poles including an underdamped pair and one zero.
mlin7 = idproc('p3uz'); % template process model with 3 poles, 1 zero
mlin7 = pem(data3lin, mlin7)

%% Comparing Responses of Linear Models to Estimation data
% How good are these models? There are various measures of model quality
% both qualitative and quantitative. The most obvious measure is how
% closely the model's response fits the measured output signal when
% subjected to the same input. This can be determined by using the
% "compare" command. It creates a plot where the models responses are
% overlaid on the measured throttle angle data in data3lin. It shows a
% quantitative measure of goodness of fit using the formula:
% Fit = (1-norm(ydata-ymodel)/norm(ydata-means(ydata)))*100. 
% where Fit is a number reflecting percent fit, ydata is the measured
% response (=data3lin.OutputData here) and ymodel is the model's response
% to input signal corresponding to ydata; here, that input signal is
% data3lin.InputData.
compare(data3lin, mlin1, mlin2, mlin3, mlin4, mlin5, mlin6, mlin7)

%%
% Based purely on fit to estimation data as selection criterion, we would
% select mlin3 as the "best model". However there are also other criteria
% to pay attention to: 
% 1. Residual analysis: Are the model residual errors
%    white (no auto-correlation) and independent of input. See "resid"
%    command for more info.
%
% 2. Uncertainty analysis:  Each model has certain parameters that are
%    estimated by the software. How reliable are those estimates? Parameter
%    uncertainty information is contained in a model's "CovarianceMatrix":
mlin3.CovarianceMatrix

%%
%    However, viewing this matrix by itself is not very informative. We
%    should look at more instructive "views" such as 1. s.d. marginal
%    uncertainty on individual parameters, or even better, the effect of
%    uncertainties on model's poles/zeros, step response or bode response.
%    Such views give an idea about how reliable a model is and provide
%    quantifiers for this reliability: which poles/zeros are estimated more
%    reliably than others, or what frequency range the model is most
%    reliable in.

%%
%    View individual parameter uncertainties:
present(mlin3)

%%
% View effect of uncertainties on pole-zero locations, step and frequency
% responses:
figure
pzmap(mlin3, 'sd', 1)
figure
bode(mlin3, 'sd', 1, 'fill')
figure
step(mlin3, 'sd', 1, 'fill') % shows rather large uncertainty

%%
% Ultimately, the user is the best judge of model quality. The model has to
% be sufficiently accurate in the operating region of the system that the
% user is interested in capturing. Other considerations like cost and
% feasibility of implementation also play a role in selecting a candidate
% model from the set of competing choices.

%% 
% The focus of this demo is nonlinear model creation. To motivate nonlinear
% approach, let us first look at the limitation of the linear models. They
% all do well on the detrended low-amplitude data. However, when validated
% on data sets containing higher input amplitudes, the fit is not good:
figure
compare(data1, mlin1, mlin2, mlin3, mlin4, mlin5, mlin6, mlin7)
figure
compare(data2, mlin3, mlin7)
% etc..
%%
% The linear models are not able to capture the hard stops at 15 and 90
% degrees even though they may capture the dynamics in the linear range. We
% clearly need nonlinear models.

%% Nonlinear ARX Models
% Nonlinear ARX models are nonlinear extensions of linear ARX models. This
% extension is achieved by allowing model regressors to be arbitrary,
% user-configurable (possibly nonlinear) mathematical functions and by
% letting the output to be a nonlinear function of its regressors (a linear
% ARX model by comparison uses a weighted sum of its regressors). The
% simplest Nonlinear ARX model one can create is one that is the same as
% the linear one, but allows for a non-zero offset. This is achieved by
% setting the nonlinear function of the model to 'linear' or simply [].
% Thus the simplest counterpart of model mlin1 is the following Nonlinear
% ARX model:
mnonlin1 = idnlarx([2 1 0], []);

%%
% The parameters of this nonlinear model can be estimated using the "nlarx"
% command. Suppose we use data3 as estimation data, we get:
mnonlin1 = nlarx(data3, mnonlin1, 'Focus', 'simulation')

%%
% The above estimation can also be carried out in one shot as follows:
mnonlin1 = nlarx(data3, [2 1 0], [], 'Focus', 'simulation');

%%
% If we now compare the responses of models mnonlin1 and mlin1 to data3, we
% find that their fits are almost identical, except that the nonlinear
% model is also able to capture the resting offset value of 15 degrees:
compare(data3, mlin1, mnonlin1)

%%
% This shows that having more (nonlinear) flexibility can improve model
% fidelity. However, if we compare the response of the model to other data
% sets, we find that it does not do well:
figure
compare(data1, mlin1, mnonlin1)
figure
compare(data2, mlin1, mnonlin1)

%%
% This means that the nonlinear model structure we used is not flexible
% enough to capture the nonlinear phenomena exhibited by the system. We
% need to add more teeth to our Nonlinear ARX model structure. Also, we
% must use data sets that excite the nonlinearities "sufficiently". data3
% is not a good candidate. data1 and data2 seem to be better candidates
% since their output plots show that the hard stop at 90 degrees is hit
% more obviously in them:
plot(data1, data2)

%%
% Hence we will use these two data sets together for further estimations.
% In order to use multiple data sets for estimation, we must first merge
% them into a "multi-experiment" data set using the "merge" command:
MultiExpData = merge(data1, data2)

%%
% Note that we have not detrended these data sets because the nonlinear
% models are expected to capture the offsets.

%%
% We have prepared the data now, but what model structure we are going to
% try? One option is to add targeted regressors to the model that are
% derived using physical insight into the nature of the system. The overall
% system seems to be behaving like a second order system (at least in
% linear range). When the throttle angle becomes 90 degrees, there is a
% hard stop which can be described by a very hard spring that resists the
% throttle angle to be greater than 90 degrees. Similarly, the 15 degree
% resting offset can be captured using a spring force that is activated
% only when the angle becomes less than 15 degrees and whose job is to
% restore the resting angle. Thus the nonlinear resistive force, which
% comes into play only when the throttle angle is either less than 15 or
% greater than 90 degrees can be expressed as: 
%
%  Fnl(t) = K1*(max(y(t),90)-90) + K2*(min(y(t),15)-15)
%
% where y(t) is the valve angle at time t. For simplicity we can assume K1
% = K2, so that the nonlinear spring force becomes: K1*(max(y(t), 90) +
% min(y(t),15)-105). We can include a formula such as "max(y(t), 90) +
% min(y(t),15)-105" as a regressor in the model and the job of the
% estimation method will be to determine the value of K1, in addition to
% previous coefficients. The model of this configuration can be estimated
% as follows:

mnonlin2 = nlarx(MultiExpData, [2 1 0], [], 'CustomRegressors', ...
   {'max(Valve Angle(t-1),90)+min(Valve Angle(t-1),15)-105'}, 'Focus', 'simulation');

%%
% Or, in multiple steps as follows:
C1 = customreg(@(x)max(x,90)+min(x,15)-105, {'Valve Angle'}, 1, true);
mnonlin2 = idnlarx([2 1 0],[],'InputName', 'Step Command', ...
   'OutputName', 'Valve Angle', 'CustomReg', C1);
mnonlin2 = nlarx(MultiExpData, mnonlin2, 'Focus','simulation')

%%
% In the above, we used the object representation of the custom regressor,
% which is more flexible and easier to manage than directly typing the
% formula as a string, which can get cumbersome if there are many custom
% regressors. Now compare this model to its estimation data:
compare(MultiExpData, mnonlin2)

%%
% We now see fairly good fits to the two data sets in MultiExpData although
% the model still seems to be having some trouble capturing the hard stop
% levels. A test for model's usefulness is how well it performs on an
% independent data set that is obtained under similar experimental
% conditions but not used for estimation. We have several such data sets:
% data3, data4 and data5.

figure, compare(data3, mnonlin2) % good
figure, compare(data4, mnonlin2) % not so good
figure, compare(data5, mnonlin2) % good 

%%
% So our quick conclusion is that adding the physically motivated custom
% regressor makes a difference! This leads to two questions that are good
% to consider:
% 1.  What if the physical insight is not handy? In many applications
%     mathematical relationships between input-output variables might be
%     difficult to realize; in fact, data-based "black box" modeling
%     approach is used largely to get around this problem! Also, even if
%     such equations could be derived they may not be amenable to
%     representation as custom regressors. In such cases, we will approach
%     the modeling task from purely a function-approximation point of view:
%     we will try out various model structures whose forms will not be
%     guided by any physical insights. We shall explore this approach in
%     detail in the following sections.
%
% 2.  Custom regressors need not correspond to physical relationships. It
%     is actually quite common to create nonlinear models that employ a set
%     of polynomials of various degrees as regressors. The idea then is to
%     simply increase the model's flexibility in capturing arbitrary
%     nonlinear phenomena without necessarily trying to relate individual
%     regressors to physically meaningful behavior. 

%% Nonlinear Models using Polynomial Regressors
% Let us first see how a nonlinear model that uses polynomial type custom
% regressors can be created. Note that the model will still be "linear in
% regressors", that is, the output will be expressed as a weighted sum of
% its regressors. Any nonlinear behavior is thus limited to the definition
% of its regressors. Later on, we will make use of nonlinear functions of
% regressors such as sigmoid and neural networks.

mnonlin3 = idnlarx([2 1 0], []); % nonlinear ARX model template
C2 = polyreg(mnonlin3, 'MaxPower', 3); % create polynomial type regressors; a set of 6 regressors
mnonlin3.CustomRegressors = C2; % insert the set of polynomial regressors as custom regressors of the model
getreg(mnonlin3) % display the set of model regressors

% Perform estimation with option to watch estimation progress.
mnonlin3 = nlarx(MultiExpData, mnonlin3, 'Focus', 'Simulation', 'Display', 'on')

%%
% This model works almost as good as mnonlin2, although the fit to data2
% (second experiment in estimation data) and data4 is not so good. This
% model thus makes use of regressors that are not motivated by physical
% insight. For easier validation, we create a new "validation" data set by
% merging data3, data4 and data5 into one multi-experiment data set. This
% will help us avoid issuing multiple "compare" commands, one for each data
% set.

ValidationData =  merge(data3, data4, data5);
figure, compare(MultiExpData, mnonlin3)   % comparison to estimation data sets
figure, compare(ValidationData, mnonlin3) % comparison to validation data sets

%%
% Note that the "polyreg" command is just a convenience function for
% quickly creating a set of polynomial type custom regressors. You can
% always create each regressor individually using the "customreg"
% constructor explicitly. Further note that the above model has 9
% regressors - 3 standard regressors added implicitly by defined model
% orders (=[2 1 0]) and the other 6 added as custom regressors explicitly.
% Refer to the product documentation for details on definition and
% management of regressors.

%% Estimating Models that Employ Nontrivial Nonlinear Functions
% All the Nonlinear ARX models estimated above used a linear weighted sum
% of regressors. System Identification Toolbox facilitates the use of
% several nonlinear functions of regressors. For example, you can create a
% wavelet network that transforms the regressors into model output by using
% a wavelet series. Similarly, you can use sigmoid networks, binary trees
% and multi-layer neural networks as nonlinear functions. These nonlinear
% functions may be used together with arbitrary, possibly nonlinear
% regressors, such as those defined above.

%%
% First, we create a Nonlinear ARX model that uses a Wavelet Network as its
% nonlinear function. We will create several models of this configuration
% by varying the types of regressors used.
mnonlin4 = nlarx(MultiExpData, [2 1 0], 'wavenet', 'Focus', 'Simulation'); % use only standard (implicit) regressors

% Use custom regressor C1 and determine number of wavelet units
% interactively
mnonlin5 = idnlarx([2 1 0], wavenet('Num','interactive'), 'InputName', 'Step Command', ...
   'OutputName', 'Valve Angle','CustomRegressors', C1); % use custom regressor C1
mnonlin5 = nlarx(MultiExpData, mnonlin5, 'Focus', 'Simulation', 'Display', 'on');

% Use polynomial type custom regressors with default wavelet network
mnonlin6 = idnlarx([2 1 0], 'wavenet', 'CustomRegressors', C2); % use custom regressor set C2
mnonlin6 = nlarx(MultiExpData, mnonlin6, 'Focus', 'Simulation', 'Display', 'on');

%% 
% Note that the nonlinear function, wavenet, can be specified in various
% ways; if a network with default configuration is to be used, you may
% simply specify its name as a string. However, if you need to configure
% the properties of the nonlinear function (such as setting its
% NumberOfUnits property), you must use the object form - invoke the
% nonlinear function's constructor and configure its properties. For model
% mnonlin5, the number of units was set to be determined interactively.
% This means that the user will be prompted to choose it based on the UOV
% criterion ("unexplained output variance") shown by a bar chart during
% estimation.

figure, compare(MultiExpData, mnonlin4, mnonlin5, mnonlin6)
figure, compare(ValidationData, mnonlin4, mnonlin5, mnonlin6)

%%
% Of the three, only mnonlin6 seems to provide something close to a
% satisfactory result; others do not work at all. Overall, use of wavelet
% networks for this problem does not seem to work, even though we have only
% scratched the surface in terms to exploring all the estimation options
% (such as model orders, other types of custom regressors, nonlinear
% least-squares search algorithm options, configuration of wavelet network
% properties etc). One of the main lessons in nonlinear model estimation
% methodology is to take a trial and error perspective and patiently try
% out a variety of forms and estimation options. In this demo, we just
% explore some of these options; the trials shown here are not exhaustive
% by any means.

%% 
% Next we try sigmoid networks as choice of nonlinear function for the
% Nonlinear ARX model. 

%%
% Create a Sigmoid Network based nonlinear ARX model of order [2 1 0] and
% default configuration of the sigmoid network. Set the maximum number of
% iterations to 50.

mnonlin7 = nlarx(MultiExpData, [2 1 0], 'sigmoid', 'Focus', 'Simulation',...
   'MaxIter', 50, 'Display', 'on');

%%
% Create a model of order [3 3 0] that uses 10 sigmoid units.
NL = sigmoidnet('NumberOfUnits', 10);
mnonlin8 = nlarx(MultiExpData, [3 3 0], NL, 'Focus', 'Simulation', ...
   'Display', 'on');

%% 
% Use the above model but with additional polynomial regressors of orders 2
% and 3.
mnonlin9 = idnlarx([3 3 0], NL);
PolyReg = polyreg(mnonlin9, 'MaxPower', 3); % polynomial regressor set 
mnonlin9.CustomRegressors = PolyReg;
mnonlin9 = nlarx(MultiExpData, mnonlin9, 'Display', 'on', 'Focus', 'Simulation');

figure, compare(MultiExpData, mnonlin6, mnonlin7, mnonlin8, mnonlin9)
figure, compare(ValidationData, mnonlin6, mnonlin7, mnonlin8, mnonlin9)

%%
% The additional flexibility provided by custom regressors helps it to
% improve the fit to estimation data. However, fit to validation data
% reduces indicating that the extra flexibility adds variability in the
% model that may render it less robust, or difficult to extrapolate. Based
% on the above analysis, mnonlin8 seems to be the best candidate for use.

%% Using a Linear Model to Initialize the Nonlinear ARX Model
% We started the modeling exercise by trying out a variety of linear
% models. This gave us an idea regarding the orders to use. With linear ARX
% models we can go further: we can use it directly to initialize the
% configuration of a nonlinear ARX model whose parameters may then be
% updated using the "nlarx" command. This gives us an alternative way of
% initializing nonlinear models which may work better than the default
% initialization scheme in cases where the system is weakly nonlinear and
% we already have a very good representation (i.e. model) of its linear
% component. 

%%
% For example, we may have a good linear model of a system from experiments
% where it is subjected to low-amplitude excitations. We may want to
% "extend" this linear model by adding nonlinear elements in order to
% extend the applicability of the model into higher-amplitude input
% excitations that cause the nonlinearities (such as saturation) to kick
% in. Let us explore the syntax for achieving this type of initialization:

%%
% Suppose we estimate a linear ARX model of orders [3 3 1] for the low
% input amplitude dataset data3lin: 

LinearModel = arx(data3lin, [3 3 1], 'Focus', 'simulation')
compare(data3lin, LinearModel)

%%
% The plot shows a decent fit to the data. Now suppose we want to create a
% sigmoid network based nonlinear model that uses the above linear model as
% its linear component. We can achieve this configuration by using the
% "idnlarx" command that creates a nonlinear ARX model:

mnonlin10 = idnlarx(LinearModel, 'sigmoidnet') % a template nonlinear ARX model

%%
% We use the linear model as an input argument to idnlarx command, in place
% of the (more usual) orders matrix. This creates a nonlinear model whose
% orders. Plus, its linear component (see
% mnonlin10.Nonlinearity.Parameters.LinearCoef) has been pre-computed using
% the coefficients of the linear model. We can now update all the
% parameters of the nonlinear model to maximize fit to a higher-amplitude
% nonlinear data as before:

mnonlin10 = nlarx(MultiExpData, mnonlin10, 'Display', 'on', 'Focus', 'Simulation');

%%
% The above multi-step configuration (use of idnlarx to create a template
% followed by estimation using nlarx) can be combined together into one
% estimation call as follows:
mnonlin10 = nlarx(MultiExpData, LinearModel, 'sigmoidnet', ...
   'Display', 'on', 'Focus', 'Simulation')

%%
% Finally, let us compare mnonlin10 against a similar model that was
% estimated using default initialization scheme:
figure, compare(MultiExpData, mnonlin8, mnonlin10)
figure, compare(ValidationData, mnonlin8, mnonlin10)

%%
% mnonlin10 appears to be a good model based on validation test. Note that,
% in general, there is no automatic guarantee that a nonlinear ARX model
% created using a linear component (rather than orders) would work better.
% It simply offers an alternative to the default initialization scheme used
% when you specify the order matrix to create the nonlinear model. However,
% this alternative should be considered when a good linear model of the
% process is handy and when the nonlinearities are known to be
% weak/limited.


%% Hammerstein-Wiener Models
% Hammerstein-Wiener models are nonlinear extensions of linear transfer
% functions wherein the extension is achieved by adding memoryless
% nonlinear functions to the input and/or output signal(s) of the linear
% system. These models are also called "models with I/O nonlinearities".
% Very often, the nature of the nonlinear functions connected to the linear
% function are determined based on physical insight, but that is not a
% necessity. In the following we will explore two configurations: one where
% the nature of nonlinearity is determined by physical reasoning and
% another where we use arbitrary functions in a "black box" spirit.

%%
% The simplest counterpart of a linear transfer function (for example,
% model mlin7 or mlin3) in Hammerstein-Wiener structure is a model with no
% nonlinearities. This is created by using [] for nonlinearity in the
% model constructor (idnlhw) or its estimator (nlhw).

hw1 = idnlhw([4 4 0], [], []) % Input NL = Output NL = []
hw1 = nlhw(data3lin, hw1, 'Display', 'on')

%%
% The above two calls can be combined into a single call to "nlhw" by
% specifying the orders and nonlinearities directly as input arguments to
% "nlhw":
hw1 = nlhw(data3lin, [4 4 0], [], [], 'Display', 'on')

%%
% The above nonlinear model (hw1) is structurally similar to the linear
% model mlin3, although its parameters are different owing to differences
% in handling of initial states. Of course, hw1 is no good at modeling
% nonlinear behavior since it has no nonlinear elements.

compare(MultiExpData, hw1)

%%
% Let us now start building some meaningful Hammerstein-Wiener models. We
% know intuitively that the system has a linear range. At angles less than
% 15 degrees and greater than 90 degrees resistive forces kick in. The ones
% at 90 degrees are strong and can be considered almost as a complete hard
% stop. Such phenomena can be described by a saturation function. Thus
% adding a saturation function at the output of the model should capture at
% least the 15 and 90 degree steady-state signal levels present in the
% output, if not the transient behavior. The saturation of output can be
% achieved by adding a saturation nonlinearity at the output port of the
% linear system. In other words, let us create a Hammerstein-Wiener model
% that uses saturation as its "output nonlinearity" but has no input
% nonlinearities. The mathematical name for this configuration is a "Wiener
% model":

hw2 = nlhw(MultiExpData,[3 3 0], [], 'saturation'); % a template Wiener model

%%
% hw2 uses saturation nonlinearity in its default configuration. But we
% know more: we know that the saturation limits ought to be close to 15
% (lower limit) and 90 degrees (upper limit). We can add this information
% by customizing a saturation nonlinearity object before adding it to the
% Hammerstein-Wiener model:

SatNL = saturation([15 90])  % a saturation nonlinearity with prescribed saturation bounds

%%
% or, we could also do:
SatNL = saturation;
SatNL.LinearInterval = [15 90];

%%
% Now use SatNL as a component of the Hammerstein-Wiener model:
hw3 = nlhw(MultiExpData,[3 3 0], [], SatNL, 'Display', 'on');
hw3.OutputNonlinearity % post-estimation values of saturation limits

%%
% The above models (hw2, hw3) have implicitly used zero initial conditions.
% Sometimes estimation of initial conditions along with the model's
% parameters improves the fit to data.

hw4 = nlhw(MultiExpData,[3 3 0], [], SatNL, 'Display', 'on', 'InitialState', 'Estimate');


figure, compare(MultiExpData, hw2, hw3, hw4)

%%
% While hw2 and hw3 are more or less the same, hw4 is better at fitting the
% estimation data. Let us now validate these models on independent
% validation data sets:

figure, compare(ValidationData, hw2, hw3, hw4)

%%
% The validations are good for hw4, except that it performs markedly worse
% on third experiment in the validation data set. We will now explore if
% the situation can be improved by increasing model orders:

hw5a = nlhw(MultiExpData,[4 4 0], [], SatNL, 'Display', 'on', 'InitialState', 'Estimate');
hw5b = nlhw(MultiExpData,[4 4 0], [], SatNL, 'Display', 'on', 'InitialState', 'Zero');

figure, compare(MultiExpData, hw2, hw3, hw4, hw5a, hw5b)
figure, compare(ValidationData, hw2, hw3, hw4, hw5a, hw5b)

%%
% Thus, using orders [4 4 0] with the option to estimate initial states
% seems to help; hw5a seems to be a better model overall. However, the fits
% are not as good as those obtained using nonlinear ARX models. This, by
% itself, is not a cause for concern: not all model structures are suited
% for a particular problem. However, we can continue to explore other types
% of I/O nonlinearities in the Hammerstein-Wiener models. We can consider
% more flexible forms such as piecewise linear functions in place of
% saturation. Note that such a choice is made simply as a trial-and-error
% alternative (the idea being use of more flexible nonlinear elements) and
% is not guided by any physical insight.

%%
% Consider now a model structure that uses piecewise linear functions as a
% form of nonlinearity and order = [3 3 0]

hw6 = nlhw(MultiExpData,[3 3 0], [], 'pwlinear', 'MaxIter', 200);
hw7 = nlhw(MultiExpData,[3 3 0], pwlinear('NumberOfUnits',7), ...
   pwlinear('NumberOfUnits',10), 'MaxIter', 200, 'Display', 'on');

figure, compare(MultiExpData, hw5a, hw6, hw7)
figure, compare(ValidationData, hw5a, hw6, hw7) % hw7 appears to validate well

%%
% There are several other types of nonlinear functions you could explore
% using in a Hammerstein-Wiener model. These include Wavelet Network
% (wavenet),  1-dimensional Polynomial (poly1d), Dead Zone (deadzone),
% Sigmoid Network (sigmoidnet).

%%
% Note that estimation command calls do not use 'Focus'/'simulation' as
% property-value pair input argument. This is because the
% Hammerstein-Wiener models can only minimize the simulation error between
% model and measured output data, while a nonlinear ARX model can minimize
% both prediction error (focus = 'prediction') and simulation error (focus
% = 'simulation')

%% Using a Linear Model to Initialize the Hammerstein-Wiener Model
% We started the modeling exercise by trying out a variety of linear
% models. This gave us an idea regarding the orders to use. With linear OE
% models (models created using "n4sid" or "oe") we can go further: we can
% use it directly to initialize the configuration of a Hammerstein-Wiener
% model whose parameters may then be updated using "nlhw" command. This
% gives an alternative way of initializing nonlinear models which may work
% better than the default initialization scheme in cases where the system
% is weakly nonlinear and we already have a very good representation (i.e.
% model) of its linear component.

%%
% For example, we may a good linear model of a system when it is subjected
% to low-amplitude excitation. We may want to "extend" this linear model by
% sandwiching it between nonlinear elements in order to extend the
% applicability of the model into higher-amplitude input excitations that
% cause the nonlinearities (such as saturation) to kick in. Let us explore
% the syntax for achieving this type of initialization:

%%
% Suppose we estimate a linear transfer function model of orders [4 3 0]
% for the low input amplitude dataset data3lin:

LM = oe(data3lin, [4 3 0])
compare(data3lin, LM)

%%
% The plot shows a decent fit to the data. Now suppose we want to create a
% nonlinear model that uses the above linear model (LM) as its linear
% component and pwlinear functions as its input and output nonlinearities.
% We can achieve this configuration by using the "idnlhw" command that
% creates a Hammerstein-Wiener model:

hw8 = idnlhw(LM, pwlinear('num',7), 'pwlinear')

%%
% We use the linear model as an input argument to idnlhw command, in place
% of the (more usual) orders matrix. This creates a nonlinear model whose
% orders are same as those of linear model LM. Plus, its linear component
% (see hw8.LinearModel) is same as LM. We can now update all the parameters
% of the nonlinear model to maximize fit to a higher-amplitude nonlinear
% data as before:

hw8 = nlhw(MultiExpData, hw8, 'Display', 'on', 'MaxIter', 200);

%%
% The above multi-step configuration (use of idnlhw to create a template
% followed by estimation using nlhw) can be combined together into one
% estimation call as follows:

hw8 = nlhw(MultiExpData, LM, pwlinear('num',7), 'pwlinear', 'Display', 'on', 'maxiter', 200);
hw8 = nlhw(MultiExpData, hw8, 'SearchMethod', 'lm'); % run more iterations using 'Levenberg-Marquardt' search method

%%
% Finally, let us compare the various Hammerstein-Wiener models
figure, compare(MultiExpData, hw5a, hw6, hw7, hw8)
figure, compare(ValidationData, hw5a, hw6, hw7, hw8) 

%%
% hw8 appears to be a good model based on validation test. Note that, in
% general, there is no automatic guarantee that a Hammerstein-Wiener Model
% model created using a linear component (rather than orders) would work
% better. It simply offers an alternative to the default initialization
% scheme used when you specify the order matrix to create the nonlinear
% model. However, this alternative should be considered when a good linear
% model of the process is handy and when the nonlinearities are known to be
% weak/limited.

%% Residue Test
% In all of the above experiments, we have used fit to output as the sole
% criterion for judging the quality of a model. While that test is the
% primary qualification test, there are other tests of model quality that
% are often employed. One particular type of test, called "residue test"
% analyses the information content in the error signal, wherein the error
% is defined as the difference between the predicted response of the model
% and the measured data. The prediction error can be analyzed in two ways:
% by studying its auto-correlation ("whiteness test") and its correlation
% to input ("independence test"). These tests can be carried out using the
% "resid" command. For example, the residues of models mnonlin8 and hw8 can
% be studied as follows:

figure, resid(MultiExpData, mnonlin8)
figure, resid(ValidationData, mnonlin8)

figure, resid(MultiExpData, hw8)
figure, resid(ValidationData, hw8)

%%
% A good model should produce an error that is as close as possible as
% possible to white noise, indicating that it has no useful information
% left in it. This is indicated by the plotted values being inside the
% "statistically insignificant" region shown by the yellow region in the
% plot. The top axis shows error correlation (should be zero for all lags
% except 0) and cross correlation between input and error (should be zero
% for all lags). The model mnonlin8 seems to pass the residue test since
% the error correlation values are more or less inside the yellow region.
% However, the same cannot be said of the Hammerstein-Wiener model hw8
% where the error signal auto-correlation is significant. However, this is
% no cause for concern as long as the error is uncorrelated with inputs.
% This is because a Hammerstein-Wiener model, by structure, as no
% flexibility (i.e. dedicated dynamic elements) to model noise. This is
% unlike nonlinear ARX model which implicitly models both the measured
% behavior (relationship of input to output) and noise (i.e. output
% disturbances). Even with auto-correlated error, the Hammerstein-Wiener
% model can be considered a good model if it fits the validation data well
% and its residues are uncorrelated with input signal.

%% Concluding Remarks on Black Box Modeling
% This concludes our black-box modeling exercise. We created several
% linear, nonlinear ARX and Hammerstein-Wiener models of orders in the 2-4
% range. We explored several nonlinear functions such as Wavelet Network,
% Sigmoid Network, saturation and Piecewise linear functions as components
% of our nonlinear models. We configured the properties of these nonlinear
% functions in some cases by specifying the number of units for
% network-type nonlinear functions and setting linear interval for
% saturation. In the estimation process, we tweaked some estimation options
% such as MaxIter, and SearchMethod.
%
% Most experiments were trial-and-error in nature. However, we used
% physical insight to configure the model structures in some cases:
% constructing custom regressor for nonlinear ARX models, choosing
% saturation as output nonlinearity for Hammerstein-Wiener models as well
% as specifying the initial guess for saturation limits. Furthermore, we
% explored how a good linear model of ARX form and OE form (transfer
% function) may be directly used as a component of the nonlinear model;
% options for such incorporation exist both in the model constructors
% (idnlarx, idnlhw) as well as their estimators (nlarx, nlhw).

%% Grey Box Modeling of Throttle Dynamics: An ODE Coefficient Estimation Approach
% In many cases, the nonlinear dynamics of the observed phenomenon are
% well understood and mathematical equations for their motion can be
% derived. In a lumped-parameter representation, the equations of motion
% can often be represented by a set of nonlinear differential equations. 

%%
% To study this approach, let us investigate the dynamics of throttle valve
% system more closely. The DC motor operating the valve responds very
% quickly to the step command. Hence compared to the throttle valve, the
% dynamics of the motor can be captured simply as a steady-state gain.  The
% butterfly valve behaves like a mass-spring-damper system (second order),
% except for the hard stops. The hard stops can be described by a resistive
% hard spring. Hence the overall dynamics can be represented by a second
% order differential equation that uses a nonlinear resistive torsional
% spring:

%%
% J d^2/dt^2 + c dy/dt + ky + K sat(y,[15 90]) = b F(t)
%
% where J is the rotational inertia of the throttle valve, c is its damping
% coefficient, k is its torsional spring constant (linear stiffness) and K
% is the stiffness constant related to the nonlinear resistive force. The
% nonlinear displacement (displacement to which the nonlinear spring
% responds) is sat(y,[15 90]) is (max(y,90)-90+min(y,15)-15).

%%
% The parameters of this model are the coefficients J, c, k, K and b. We
% can reduce one parameter by dividing the whole equation by J. The
% (normalized) equation of motion forms the basis for grey-box estimation.
% We can compute the values of the constants c, k, K and b by following
% the following 3-step approach:

%%
% 
% # Represent the ODE as a set of first order differential equations in a
%   MATLAB or MEX function. The function must return the value of the
%   output and state-derivatives at a given time, computed as a function of
%   input values, state values, and parameter values.
%
% # Instantiate an IDNLGREY model object that uses the above ODE file by
%   calling the IDNLGREY constructor. The "parameters" of the IDNLGREY
%   model are the ODE coefficients.
%
% # Use the "pem" command to estimate the parameters of the IDNLGREY model.

%%
% If x1(t) = y(t) and x2(t) = dy/dt are used as state variables, the 2nd
% degree equation of motion can be represented by a set of two 1st order
% equations in state variables. This form is called "state-space" form. An
% ODE file that returns y(t), dx1(t)/dt and dx2(t)/dt as output arguments
% is throttleODE.m.

type throttleODE.m

%%
% The parameters defined by this ODE file are c, k, K and b, all normalized
% by moment of Inertia J. 


%% 
% Create an IDNLGREY model that wraps this ODE function in a dynamic model.
% To do this we need the following: (1) name of ODE file (2) number of
% inputs, outputs and states in the system (3) initial (guess) values of
% system parameters. Optionally we may also specify (4) the initial guess
% values for state values at time t = 0 and (5) model sample time. Let us
% consolidate this information first.

%% 
% ODE file name:
ODEFile = 'throttleODE'; % file must exist in current working directory or be on MATLAB path

%%
% Dimensions [ny nu nx]
Orders = [1 1 2]; % we have 2 states: displacement x1(t) and velocity x2(t)

%% 
% Initial parameter values
% For our example, some values could come from a linear modeling exercise:
% estimating a black box linear model of second order would suggest values
% for c, k and b. The nonlinear spring constant could be a large value
% (some multiple of linear spring constant k). The following values were
% chosen following such analysis.
c0 = 50;
k0 = 120;
K0 = 1e6; % mostly a wild guess
b0 = 4e4;
Par0 = {c0; k0; K0; b0}; % initial guess of parameter values

%%
% We also know that the rest position of the valve is 15 degrees. So initial
% value of state x1(t) is known. Initial velocity could be assumed to be
% zero. Now we have a reasonable guess for model's initial states:
x0 = [15; 0];

%%
% We want to create a continuous-time model (since our description is in
% terms  of differential equations, not difference equations). So we choose
% the model sample time to be zero.
Ts = 0;

%% 
% Now we are ready to call the IDNLGREY constructor using the above
% variables as input arguments:
Model0 = idnlgrey(ODEFile, Orders, Par0, x0, Ts);

%%
% We can assign input-output and state names to this model so that it is
% compatible with the estimation data:
Model0.InputName = 'Step Command';
Model0.OutputName = 'Valve Angle';
setinit(Model0,'Name',{'Position';'Velocity'}) % set state names
display(Model0)

%%
% Before we perform estimation, we can check how good the initial guess
% model Model0 is in emulating observed output. To do this, we compare the
% output signals in estimation data to simulated response of the model. In
% doing so, let us also use the model's own guess of initial states
% (chosen by using 'init'/'model' as property-value pair input to the
% "compare" command):

compare(MultiExpData, Model0, 'init', 'model')

%%
% The guess model gives about 60% fit to estimation data. Now let us
% perform an estimation using "pem" command to improve the fit to
% estimation data. Note that by default, the initial states are fixed to
% their initial values and only parameters are updated. You can also
% estimate initial state values, fix certain parameters to their original
% values and/or specify min/max bounds for estimation using the
% "Parameters" and "InitialStates" properties of the model. There are also
% some dedicated commands that simplify such settings: "setpar" and
% "setinit".

Model1 = pem(MultiExpData, Model0, 'Display', 'on', 'MaxIter', 20);

%%
% By default, the estimation algorithm uses 'lsqnonlin' search method which
% requires Optimization Toolbox. If that toolbox is not available on user's
% copy of MATLAB, then System Identification Toolbox's built-in solvers are
% used. For example, we could use 'Levenberg-Marquardt' solver that does
% not require Optimization Toolbox:
Model2 = pem(MultiExpData, Model0, 'Display', 'on', 'SearchMethod', 'lm', 'MaxIter', 40);

%%
% As before, let us compare the response of these models to estimation and
% validation data sets:
figure, compare(MultiExpData, Model1, Model2, 'Init', 'Model')
figure, compare(ValidationData, Model1, Model2, 'Init', 'Model') 

%%
% The results are mixed: some outputs are reproduced well, others are not.
% The trick to getting good results in grey-box case is trying out various
% initial guesses for parameters, as well as freeing initial states for
% estimation. For example, we could add x2(0) to our list of entities to
% estimate. This will not only estimate x2(0) value for each experiment in
% the estimation dataset (MultiExpData has two experiments), but also
% change the parameter estimates by separating out the influence of
% non-zero initial velocity from overall response.
Model0.InitialStates(2).Fixed = false;
Model3 = pem(MultiExpData, Model0, 'Display', 'on', 'SearchMethod', 'lm', 'MaxIter', 40);

%%
% However, in doing so, we have estimated initial states that are
% tailor-made for estimation data sets. Validating using independent data
% sets may require initial states to be estimated separately for those
% datasets. This can be achieved by using 'Init'/'Estimate' in "compare"
% command.

figure, compare(MultiExpData, Model2, 'Init', 'Model') % estimated initial states may be used for estimation data

% Prepare for validation using 3 data sets. We have to create a new model
% because we are validating using a dataset that has a different number of
% experiments (3) than the estimation dataset (2). 
x0val = {[15 15 15];[0 0 0]};
Model3a = idnlgrey(ODEFile, Orders, getpar(Model3), x0val, Ts);
Model3a.InputName = Model3.InputName;
Model3a.OutputName = Model3.OutputName;

%%
% The new model Model3a has same parameters as those of the estimated model
% Model3. Its initial states will be estimated to maximize fit to
% individual datasets in ValidationData.

figure, compare(ValidationData, Model3a, 'Init', 'Estimate')

%%
% To view/fetch parameter values use the "getpar" command.
getpar(Model2)

%% Uncertainty Analysis
% A nice feature of grey-box estimation is that its parameters are few and
% have clear physical meaning. The parameters of a black box model are
% often arbitrary coefficients. Because the parameters are well defined for
% grey-box models, it is possible to view the standard deviations which
% provides another measure of the reliability of their estimates. Remember
% that the estimated parameter values are simply nominal values of
% uncertain entities that have a covariance matrix associated with them. To
% view the parameter values of the model along with their +/- 1 std errors,
% use the "present" command:

present(Model2)

%%
% For those who are mathematically inclined, the entire covariance matrix
% may be fetched from the "CovarianceMatrix" property of the model, as in:
Cov = Model2.CovarianceMatrix

%%
% This concludes our discussion of grey-box modeling approach. With this
% approach there are two main tasks that users have to do: 
% (1) Deriving accurate equations of motion that use well defined
%     parameters. 
% (2) Use reasonable initial guesses for parameter values. 
%
% Some related requirements are: 
% - Parameterize the equation in a well conditioned way. Avoid parameters
% that can potentially make the output values or state derivative values
% infinite for finite parameter values.
% - Reduce search space by fixing known parameters or prescribing min/max
% bounds on free parameters.

%% Simulink Blocks For Simulation and Code Generation
% Identified nonlinear models can be simulated using the "sim" command.
% They can be linearized about chosen operating points. They can be
% exported to Simulink. System Identification Toolbox provides dedicated
% blocks that facilitate importing estimated models into Simulink.

% Simulation of estimated models
sim(mnonlin8, getexp(MultiExpData,1))
sim(Model2, getexp(MultiExpData,2))
sim(hw8, getexp(ValidationData,3))

% Simulink block library
slident 

open_system('Models_in_Simulink') % an example diagram

%%
% RTW supports code generation for black box models, as long as custom
% regressors are not used in them.  
