% ==========================================================================
%                    LYAPUNOV EXPONENTS TOOLBOX
% ==========================================================================
%
% 1. ABOUT THE PROGRAM
%
%    Lyapunov Exponents Toolbox (LET) provides a graphical user interface
%    (GUI) for users to determine the full sets of Lyapunove exponents
%    and dimension of their specified chaotic systems.
%
%    This version of LET can only run on MATLAB 5 or higher versions of
%    MATLAB. It has been tested under Windows and Unix.  LET may also
%    run on other platforms.
%
%    The original version of LET has only 200 lines while the GUI version
%    of LET has almost 2000 lines.  The GUI makes the program become more
%    sophisticated and run slower but allows the users to observe the
%    calculated results immediately, so that they can decide whether the
%    results are convergent or not.
%
%
% 2. HOW TO USE THE PROGRAM
%
%    To run the program, enter LET in MATLAB command window.  In order to
%    run the program properly, all files of this toolbox must be in MATLAB
%    path.  When a GUI window appears, users can run a demo program by
%    pressing the "Start demo" button or start the main program by pressing
%    the "Run LET main program" button.  LET provides some well-known
%    chaotic systems for demonstrations.  The users can choose one of them
%    from the pop-up menu.
%
%    To calculate the Lyapunov exponents and dimension of a specified
%    system, follow the steps below:
%
%    1) write an ODE function that describes the specified system and its
%       variational equation (see details given below),
%    2) enter LET in MATLAB command window,
%    3) press the "Run LET main program" button in the startup window,
%    4) press the "Setting" button in the main window,
%    5) enter desired parameters in the setting window,
%    6) when finish, press the "OK" button,
%    7) press the "Start" button in the main window to start calculation.
%   
%
% 3. FILES IN THIS TOOLBOX
%
%    LET contains the following m-files:
%
%     1) LET:      main program
%     2) STARTLET: program for setting up a startup window
%     3) SETTING:  program for creating a GUI window for users to input
%                  parameters
%     4) FINDLAYP: program for calculating Lyapunov exponents and dimension
%     5) DEMOPARM: file that contains the parameters of demo systems
%     6) LOGISTIC: ODE function of Logistic map and its variational equation
%     7) HENON:    ODE function of Henon map and its variational equation
%     8) DUFFING:  ODE function of Duffing's equation and its variational
%                  equation
%     9) LORENZEQ: ODE function of Lorenz equation and its variational
%                  equation
%    10) ROSSLER:  ODE function of Rossler equation and its variational
%                  equation
%    11) VDERPOL:  ODE function of Van Der Pol equation and its variatonal
%                  equation
%    12) STEWART:  ODE function of Stewart-McCumber model and its 
%                  variational equation
%    13) REAMDE:   Help text of this toolbox
%    14) LETHELP:  Help text of LET main program
%    15) SETHELP:  Help text of setting window
%
%
% 4. ALGORITHM EMPLOYED IN THIS TOOLBOX
%
%    The alogrithm employed in this toolbox for determining Lyapunov
%    exponents is an integration of the two algorithms proposed in
%
%    [1] A. Wolf, J. B. Swift, H. L. Swinney, and J. A. Vastano,
%        "Determining Lyapunov Exponents from a Time Series," Physica D,
%        Vol. 16, pp. 285-317, 1985.
%
%    [2] J. P. Eckmann and D. Ruelle, "Ergodic Theory of Chaos and Strange
%        Attractors," Rev. Mod. Phys., Vol. 57, pp. 617-656, 1985.
%
%    respectively.
%
%    For first-order systems, the algorithm given in [1] is used for its
%    easy implementation and high speed. For higher order systems, the
%    QR-based algorithm proposed in [2] is applied.
%
%
% 5. WRITE THE ODE FUNCTION FOR A SPECIFIED SYSTEM
%
%    In order to calculate the Lyapunov exponents of specified systems,
%    users have to write their own ODE functions for their specified
%    systems.  ODE functions of continuous systems are a little bit
%    different from that of discrete systems.  Both of them will be
%    discussed.
%
%    A. Continuous systems
%
%    Let's take the Lorenz system as an example.
%
%    The Lorenz system is governed by the following ODEs:
%
%               dx/dt = a*(y - x)     = f1
%               dy/dt = r*x - y - x*z = f2
%               dz/dt = x*y - b*z     = f3
%
%    The first step is to calculate the Jacobian of the above system as
%    following:
%
%         /                         \      /                     \
%        |   df1/dx  df1/dy  df1/dz  |    |    -a       a    0    |
%        |                           |    |                       |
%    J = |   df2/dx  df2/dy  df2/dz  |  = |   r - z    -1    -x   |
%        |                           |    |                       |
%        |   df3/dx  df3/dy  df3/dz  |    |     y       x    -b   |
%         \                         /      \                     /
%
%    where df1/dx denotes the partial differentiation of f1 with
%    respect to x.
%
%    Then, write the variational equation as following:
%
%               F = J*Q
%
%    where Q is a square matrix with the same dimension as J.
%    Note: the diagonal elements of Q are distances between nearby
%          trajectories.  Initially, Q is an identity matrix. Users
%          do not need to specify the initial conditions for Q. The
%          program will do it for them.
%
%    Now, take the ODE function of Lorenz system (in file: LORENZEQ.M)
%    as an illustration example.
%
%---------------------------------------------------------------------------
%       %        Output data
%       %         |     ODE function name 
%       %         |       |      t (time), must be included in this case
%       %         |       |      |  Input data
%       %         |       |      |   |
%       function OUT = lorenzeq( t,  X)
%
%       % The first 3 elements of the input data X correspond to the
%       % 3 state variables of the Lorenz system.  Restore them.
%       % The input data X is a 12-element vector in this case.
%       % Note: x is different from X
%
%       x = X(1);  y = X(2);  z = X(3);
%
%       % Parameters
%       a = 16;    r = 45.92;  b = 4;
%
%       % Write the ODEs of Lorenz system here:
%       dx = a*(y - x);
%       dy = -x*z + r*x - y;
%       dz = x*y - b*z;
%
%       % Q is a 3 by 3 matrix, so it has 9 elements.
%       % Since the input data is a column vector, rearrange
%       % the last 9 elements of the input data in a square matrix.
%       
%       Q = [X(4), X(7), X(10);
%            X(5), X(8), X(11);
%            X(6), X(9), X(12)];
%
%       % Linearized system (Jacobian)
%       J = [   -a,   a,  0;
%            r - z,  -1, -x;
%                y,   x, -b];
%  
%       % Multiply J by Q to form a variational equation   
%        F = J*Q;
%
%       % The final step is to output the data which contains
%       % dx, dy, dz and F. The output data must be a column vector.
%       % If F is of the following form:
%       %
%       %      /             \
%       %     |  a    d    g  |
%       %     |               |
%       % F = |  b    d    h  |
%       %     |               |
%       %     |  c    f    i  |
%       %      \             /
%       %
%       % the output data must be of the following form:
%       %
%       % OUT = [dx, dy, dz, a, b, c, d, ..., h, i]';
%
%       % In MATLAB's language, it can be expressed simply as:
%       OUT = [dx; dy; dz; F(:)];
%-----------------------------------------------------------------------
%
%    The above procedures are for autonomous systems only. Non-autonomous
%    systems have to be transformed to autonomous systems. This can be
%    done by introducing a new state variable (say z ).
%    Let's take the Duffing's equation as an example:
%
%          dx/dt = y
%          dy/dt = -k*y - x^3 + B*cos(t)
%
%    Duffing's equation is non-autonomous since it is explicitly dependent
%    on t.  To change it to autonomous, let z = t, and then this second-order
%    non-autonomous system can be expressed as a third-order autonomous
%    system as follows:
%
%          dx/dt = y
%          dy/dt = -k*y -x^3 +B*cos(z)
%          dz/dt = 1
%
%    Its Jacobian can be determined as following:
%
%               /                      \
%              |     0     1      0     |
%              |                        |
%          J = |  -3*x^2  -k  -B*sin(z) |
%              |                        |
%              |     0     0      0     |
%               \                      /
%
%     Then, follow the procedures mentioned early to write the ODE
%     function for the system (see DUFFING.M for the ODE function).
%
%     B. DISCRETE SYSTEMS
%
%     The only difference between continuous and discrete ODE functions
%     is that continuous ODE functions have the time t as one input data
%     while discrete ODE functions do not.  See the illustration below:
%
%------------------------------------------------------------------------
%     % A continuous ODE function must include this input parameter
%     %                       |
%     %                       |
%     function OUT = lorenzeq(t, X)
%                  :
%                  :
%------------------------------------------------------------------------
%     % A discrete ODE function does not require the t-component
%     %
%     function OUT = henon(X)
%                  :
%                  :
%------------------------------------------------------------------------
%
%    The remaining procedures of writing the ODE function for a discrete
%    system are the same as that for a continuous one.  See HENON.M,
%    and LOGISTIC.M for references.
%
%    For more details of writing ODE files, see the help text of ODEFILE
%    (can be obtained by choosing ODEFILE from the above pop-up menu).
%
% 6. ACKNOWLEDGMENT
%
%    The author would like to thank Dr. Keith Briggs for his kindly help
%    and sending his Fortran Lyapunov exponent program to the author for
%    reference.
%
%
% 7. ABOUT THE AUTHOR
%
%    The author of LET is Steve Wai Kam SIU, who is currently a research
%    student of City University of Hong Kong.  He is with the department
%    of Electronic Engineering.  Steve's research interests include
%    the application of chaos to secure communications, chaos control,
%    synchronization of chaotic systems, and nonlinear dynamics of phase-
%    locked loops.
%
%
% Although full support of this program is not available, the users can
% send comments and bug reports to the author so that he can improve the
% program.
%
%                     
%-------------------------------------------------------------------------
%
%                          Steve Wai Kam SIU
%                 Department of Electronic Engineering
%                    City University of Hong Kong
%                 Tat Chee Avenue, Kowloon, HONG KONG
%       
%                 E-mail address: wksiu@ee.cityu.edu.hk
%
%--------------------------------------------------------------------------
%
% See also: LETHELP, SETHELP, and ODEFILE

% by Steve W. K. SIU, July 7, 1998.
                                   
help readme
