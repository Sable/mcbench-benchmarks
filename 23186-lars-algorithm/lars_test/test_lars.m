% TEST_TEMPLATE
%
% Use this template as a starting point for your new tests. To
% run the test and see the report.
%
% suite = munit_testsuite('test_template');
% r = suite.run();
% r.web();
%
% See also test_munit1, test_munit2
function test = test_template

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Do not modify the following 20 lines of codes.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Create a structure of constraint objects for assertions
    c = munit_constraint;

    % Subclass the testcase object
    stk = dbstack('-completenames');
    mname = stk(1).file;
    fcn_names = scan(mname, {'setup' ,'teardown', 'test_[A-Za-z0-9_]*'});
    for ffi=1:length(fcn_names)
        fcn_handles{ffi}=eval(['@',fcn_names{ffi}]);
    end
    test_file_info.fcn_names = fcn_names;
    test_file_info.fcn_handles = fcn_handles;
    test = munit_testcase(test_file_info);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Your codes below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    x = [];
    y = [];
    

    function setup
    end

    function teardown
        % This function will be called at the 
        % end of *every* test_ function
    end

    % These are examples tests. Create new tests by creating
    % new functions whose name starts with test_ 
    %
    % The three tests below show the three different styles you
    % can use to create assertions. Refer to the documentation
    % for more details.

    function test_lars
        data = load('test_lars_diabetesData.mat');

        stopCriterion = {};
        stopCriterion{1,1}='maxKernels';
        stopCriterion{1,2}=100;  % Stop when size of active set is 100.
        sol = lars(data.y, data.x, [], 'lars', stopCriterion);

        a = [-10.01220 -239.81909 519.83979 324.39043 -792.1842 476.74584  101.0446 177.0642 751.2793 67.62539];
        z = zeros(size(a));
        z(sol(11).active_set) = sol(11).beta;
        b = a - z;
        test.assert( @() norm(b) < 0.0001 );
        test.assert( @() size(sol)==[1 11]);
    end

    function test_lasso
        data = load('test_lars_diabetesData.mat');

        stopCriterion = {};
        stopCriterion{1,1}='maxKernels';
        stopCriterion{1,2}=100;  % Stop when size of active set is 100.
        sol = lars(data.y, data.x, [], 'lasso', stopCriterion);

        a = [-7.011245 -237.10079 521.07513 321.54903 -580.4386 313.86213    0.0000 139.8579 674.9366 67.17940];
        z = zeros(size(a));
        z(sol(12).active_set) = sol(12).beta;
        b = a - z;
        test.assert( @() norm(b) < 0.0001 );
        test.assert( @() size(sol)==[1 13]);
    end

    function test_lasso2
        % Original routine to synthesize data for test.
        
        % nbapp=200;
        % nbtest=500;
        % yapp=cos(exp(xapp)) + sigma*randn(nbapp,1);
        % ytest=cos(exp(xtest));
        % kernel='gaussian';
        % kerneloption=[0.05 0.1 0.5 1];
        % Kapp  = multiplekernel(xapp,kernel,kerneloption); % Using SVM toolbox
        % maxKernels = 75;
        % Kapp has kernelized matrix.
        
        % Good saved data having slight multicolinearity or singularity.
        data = load('test_lars_cosExp.mat');

        stopCriterion = {};
        stopCriterion{1,1}='maxKernels';
        stopCriterion{1,2}=data.maxKernels;  % Stop when size of active set is data.maxKernels.
%         stopCriterion{2,1}='maxDrops';
%         stopCriterion{2,2}=[3,3];  %stop if there are at least 6 drops in the last 10 iteration.
%         stopCriterion{3,1}='maxIterations';
%         stopCriterion{3,2}=100;

        regularization = 0;
        trace = 1;
%         sol = lars(data.yapp, data.Kapp, [], 'lasso', stopCriterion, regularization, trace); % for simple usage or for a really really large matrix
        XTX = lars_getXTX(data.Kapp);
        sol = lars(data.yapp, data.Kapp, XTX, 'lasso', stopCriterion, regularization, trace); % for a somewhat big matrix x. In this case, you can speed up by doing x'*x as shown above.
        % This does not reduce the time, but if you reuse x for various y
        % sets, then you can run lars_getXTX once and use it in lars over
        % and over again. Good for neurons with the same stimulus set.
        figure(5325);
        for i=1:4:length(sol)
            if length(sol(i).drop)>0 | length(sol(i).active_set)==0
                continue;
            end
            plot(data.xapp, data.yapp,'b');
            hold on;
            plot(data.xtest, data.ytest,'k');
            plot(data.xapp, data.Kapp(:,sol(i).active_set)*sol(i).beta_OLS'+sol(i).b_OLS,'r')  %(1:length(sol(i).beta_OLS)-1)
            hold off;
            xlabel(['l1 norm of normalized beta = ',num2str(sum(abs(sol(i).beta_OLS_norm))), '    # of nonzero beta = ',num2str(length(find(abs(sol(i).beta_OLS)>0.0001)))]);
            ylabel(['l1 norm of unnormalized beta = ',num2str(sum(abs(sol(i).beta_OLS)))]);
            drawnow;
        end
        test.assert(c.ask('Is the red line approximate the blue or the black line well?'));

        
% Followings are true when RESOLUTION_OF_LARS = 1e-10, REGULARIZATION_FACTOR = 1e-9.  See lars_init.m
%         test.assert( @() length(sol)==384 );  
%         a = data.last_beta;
%         z = zeros(size(data.last_beta));
%         z(sol(384).active_set) = sol(384).beta;
%        test.assert( @() norm(z - a) < 0.000001);
%        test.assert( @() length(sol(384).active_set) == 75);
    end

    function test_lasso_bootstrap
        data = load('test_lars_cosExp.mat');
        
        stopCriterion = {};
        stopCriterion{1,1}='maxKernels';
        stopCriterion{1,2}=data.maxKernels;  % Stop when size of active set is data.maxKernels.

        number_of_bootstrap = 3;
        hf_lars = @(ind) lars(data.yapp(ind,:), data.Kapp(ind,:), [], 'lasso', stopCriterion);
        [sol_set,sample_set] = bootstrap_mine(number_of_bootstrap, hf_lars, [1:size(data.yapp,1)]);
        
        figure(5325);
        for j=1:number_of_bootstrap
            sol = sol_set{j};
            sam = sort(sample_set(:,j));
            for i=2:4:length(sol)
                if length(sol(i).drop)>0 | length(sol(i).active_set)==0
                    continue;
                end
                plot(data.xapp(sam,:), data.yapp(sam,:),'b');
                hold on;
                plot(data.xtest, data.ytest,'k');
                plot(data.xapp(sam,:), data.Kapp(sam,sol(i).active_set)*sol(i).beta_OLS'+sol(i).b_OLS,'r')  %(1:length(sol(i).beta_OLS)-1)
                hold off;
                xlabel(['l1 norm of normalized beta = ',num2str(sum(abs(sol(i).beta_OLS_norm))), '    # of nonzero beta = ',num2str(length(find(abs(sol(i).beta_OLS)>0.0001)))]);
                ylabel(['l1 norm of unnormalized beta = ',num2str(sum(abs(sol(i).beta_OLS)))]);
                drawnow;
            end
            test.assert(c.ask('Is the red line approximate the blue or the black line well?'));
        end
    end

%    function test_forwardStepwise
%         sol = lars(y,x,'forward_stepwise',100);
%         a = [0.00000000 -111.97855 512.04409 252.52702    0.0000 0.000000e+00 -196.04544 0.000000e+00 452.3927 12.07815];
%         b = a - sol(6).beta;
%         test.assert( @() norm(b) < 0.0001 );
%         a = [-1.22868148 -231.86286 523.45552 316.07390 -172.4241 8.806438e-14 -194.70372 6.816468e+01 527.8311 66.32002];
%         c = a - sol(13).beta;
%         test.assert( @() norm(c) < 0.0001 );
%         test.assert( @() size(sol)==[1 15]);
%    end


    function test_lars_simple_case
        Kapp = [
            1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1
            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0
            0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0
            0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0
            0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0
            0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1
            0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
            0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0
            1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1
            0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0
            0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0
            0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0
            0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];

        regularization = 0;
        stopCriterion = {};
        stopCriterion{1,1}='maxKernels';
        stopCriterion{1,2}=10;  % Stop when size of active set is data.maxKernels.
        stopCriterion{2,1}='maxDrops';
        stopCriterion{2,2}=[3,3];  %stop if there are at least 6 drops in the last 10 iteration.
        stopCriterion{3,1}='maxIterations';
        stopCriterion{3,2}=100;
        trace = 0;

        XTX = lars_getXTX(Kapp);
        
        yapp = [0 -3 -1 -3 0  0 -3 -1 -3 0  0 0 -1 -2 -1 -2 -1 0 0  0 0 -1 -2 -1 -2 -1 0 0]';  % faces with resolution problem.
        [sol,stopReason] = lars(yapp, Kapp, XTX, 'lasso', stopCriterion, regularization, trace); % for a somewhat big matrix x. In this case, you can speed up by doing x'*x as shown above.
        test.assert( @() sol(length(sol)).active_set == [7     8     9    12    13    14    17    18    19] );
        test.assert( @() norm(sol(length(sol)).beta - [-1 -1 -1 -1 1 -1 -1 -1 -1])<0.000001 );
        
        
        yapp = [0 -2.9 -1.2 -2.2 0      0 -3.1 -0.7 -2.5 0     0 0 -1.1 -1.8 -0.4 -2.1 -0.9 0 0     0 0 -0.8 -2.4 -1 -1.5 -0.6 0 0]'; % no resolution problem.
        [sol,stopReason] = lars(yapp, Kapp, XTX, 'lasso', stopCriterion, regularization, trace); % for a somewhat big matrix x. In this case, you can speed up by doing x'*x as shown above.
        test.assert( @() sol(length(sol)).active_set == [7     8     9    12    13    14    17    18    19] );
        test.assert( @() norm(sol(length(sol)).beta - [-0.8 -1 -1.1 -1.4 1 -0.8 -0.9 -0.7 -0.6])<0.000001 );
    end


    function test_lars_user_Defined_Criterion
        Kapp = [
            1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1
            1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0
            0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0
            0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0
            0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0
            0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1
            0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
            0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0
            1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1
            0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0
            0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
            1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0
            0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0
            0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 1 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];

        regularization = 0;
        trace = 0;

        XTX = lars_getXTX(Kapp);
        yapp = [0 -3 -1 -3 0  0 -3 -1 -3 0  0 0 -1 -2 -1 -2 -1 0 0  0 0 -1 -2 -1 -2 -1 0 0]';  % faces with resolution problem.

        stopCriterion = {};
        stopCriterion{1,1}          = 'userDefinedCriterion';
        stopCriterion{1,2}.fhandle  = @myStopTest;  % Stop when size of active set is data.maxKernels.
        stopCriterion{1,2}.data     = yapp;  % You can add any kind of data here. This will be passed to the testing function together with solution set.
                                         % You determine the type of this
                                         % data. This can be any of list, array,
                                         % or structure, and so on.
        
        [sol,stopReason] = lars(yapp, Kapp, XTX, 'lasso', stopCriterion, regularization, trace); % for a somewhat big matrix x. In this case, you can speed up by doing x'*x as shown above.
        
        MSE = sum((yapp-sol(2).mu_OLS).^2)/length(yapp);
        test.assert( @() MSE == stopReason{1,2}.MSE );
        test.assert( @() abs(MSE - sol(length(sol)).MSE)<0.0000000001 );
        test.assert( @() strcmp(stopReason{1,1},'userDefinedCriterion') );
        test.assert( @() stopReason{1,2}.stop == 1 );
        test.assert( @() strcmp(stopReason{1,2}.message,'Good') );
        test.assert( @() size(stopReason{1,2}.myData) == [2,3]   );
        test.assert( @() sol(length(sol)).active_set == [7 8 9 12 14 17 18 19] );
    end



end


