%==========================================================================
%                           PARAMETERS SETTING
%==========================================================================
%
% In the parameter setting window, users can specify desired parameters.
% When finish entering parameters, press the "OK" button to save the
% parameters and return to the main window.
%
%
% 1. OUTPUT OPTIONS
%
%    Users can save the calculated results in a file when the "Output File"
%    checkbox is checked.  The users can choose save either the Lyapunov
%    exponents or Lyapunov dimension or save both by checking the corres-
%    ponding checkboxes.  The precision pop-up menu allows the users to
%    specify the precision of the data printed in the file.  Note that
%    the results will be printed EVERY ITERATION, thus will slow down the 
%    overall calculation speed.
%
%
% 2. INTEGRATION PARAMETERS
%
%    a) ODE function is the name of the M-file that describes the ODEs
%       and variational equation of the concerned system.  For instance,
%       the Lorenz system's ODE function is saved in LORENZEQ.M, so we
%       have to enter LORENZEQ in the "ODE function" edit box.
%
%    b) There are 6 integration methods for users to choose from. "Discrete
%       map" is for discrete systems while the others are for continuous
%       systems. Details of the integration methods for continuous systems
%       are listed in the above pop-up menu.
%
%    c) For continuous systems, users have to specify the initial time,
%       time step, final time, relative tolerance as well as absolute
%       tolerance.  For discrete systems, the initial time must be zero and
%       the time step must be unity.
%
%       The default relative and absolute tolerances are 1E-5. For simpli-
%       fication, the same absolute tolerance is used for all state vari-
%       ables of the ODEs though MATLAB's integration functions allow users
%       to specify the absolute tolerance of each state variable.  The
%       relative and absolute tolerances are not applicable to discrete
%       maps, so a zero is displayed.  Moreover, for discrete systems, the
%       final time must be an integer since it is the total number of steps
%       taken in the calculation.
%
%    d) The number of initial conditions must be equal to the total number
%       of state variables of the system.  Users need not to specify the
%       initial conditions for the variational equation since the program
%       can generate the initial conditions for the variational equation as
%       long as the users provide the correct number of linearized ODEs.
%
%       In order to obtain correct results, users should provide suitable
%       initial conditions. Some initial conditions will drive the system
%       into a fix point.  In this case, one or more Lyapunov exponents
%       will stay on their initial values and never be changed, so it must
%       be avoided. Note: for non-autonomous systems, one of the Lyapunov
%       exponents (LEs) is always zero and constant, this is expected and
%       should not be considered as the above case as long as the other
%       LEs are not constant.
%
%       Some complex systems, especially high dimensional systems, have
%       several or more basins of attractions, so two sets of initial 
%       conditions in different basins of attractions will result in two
%       different sets of Lyapunov exponents.  Therefore, the users should
%       select the initial conditions carefully.
%
%    e) The number of linearized ODEs is equal to the total number of
%       elements in the Jacobian matrix.  Since the Jacobian matrix is
%       a squre matrix, the number must be the square of an integer.
%       For the Lorenz system, the number of linearized ODEs is 9 (3 x 3).
%       This number is required in generating the initial conditions for
%       the variational equation.
%
%
% 3. PLOTTING OPTIONS
%       
%    The program allows the users to control the drawing frequency. 
%    Updating the plot too frequent will result in a longer calculation
%    time while displaying the results not often enough may affect the
%    users to decide whether the results are convergent or not.  Thus,
%    the users should make a compromise between the speed of calculation
%    and the convergence of results.
%
%    Moreover, users can add x-axis, y-axis labels and title on the
%    figure.  They can also choose the line color for plotting.
%
%
% 4. ITERATION PARAMETERS
%
%    Due to transient behavior, the determined results may be inaccurate
%    if the integration time is not long enough.  Therefore, it is better
%    let the system to evolve some time before calculating the Lyapunov
%    exponents.  Note that this transient time is in terms of ITERATIONS
%    but not time steps (here, ITERATION means one iteration in determin-
%    ing the Lyapunov exponents, it may be more than one time step).
%    
%    The program updates the Lyapunov exponents every k time steps (one
%    ITERATION).  k should neither be chosen too small nor too large
%    since a too small k will result in overheads while a too large k
%    may cause overflow in the calculation (as the distances between
%    nearby trajectories increase exponentially).  When an NAN or
%    INF becomes one of the results, this indicates that the overflow
%    has occurred.
%
%    See also: ODE45, ODE23, ODE115, ODE23S, ODE15S, ODEFILE, README, 
%    and LETHELP
%
%

%    by Steve W. K. SIU, July 5, 1998.

help sethelp
