%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

% rng('default')
for mc = 1:1

model       = InitParameters;               % initialize all parameters.
GTruth      = GenTruth(model);              % generate ground truth target and observer trajectory
Measures    = GenMeas(GTruth, model);       % offline data generation

%%  particle, weight, state initialization
zk_1    = Measures.Z{1};                % first measurement
q_prev  = .1;                           % initial prob. of existence
Wki     = ones(model.N,1)/model.N;      % initial, uniform weights
model.m_init  = [zk_1(2)*sin(zk_1(1)) 0 zk_1(2)*cos(zk_1(1)) 0]';
model.P_init  = diag([10000 4 10000 4]').^2;
own = GTruth.Ownship(:,1);
Xki = initParticles(model.m_init, model.P_init, own, model.N, model);


%%  output variable initialization
Result(mc).X = cell(model.K, 1);            % estimated state variable
Result(mc).N = zeros(model.K, 1);           % estimated number of targets
Result(mc).L = cell(model.K, 1);            % estimated target labels

Result(mc).X{1} = Xki*Wki;                  % initial target state
Result(mc).P{1} = Xki*Xki'./model.N;        % initial state covariance

% % initial target state
% Xo_k   = [0; 2.57*sin(140*pi/180); 0; 2.57*cos(140*pi/180)];       % 5 knots, 140 deg
% GTruth.Ownship(:,1) = Xo_k;                 % initial observer state
% xinit   = [500; 3; 400; 4];                 % initial target state
% % ChangeCourse = false;
% 
% Measures.Z = cell(model.K,1); % initialize measurement structure
% Measures.Z{1} = MeasFcn(xinit-Xo_k, model, true);     % first measurement
% 
% %%  main filtering loop
% for k = 2:model.K
%     if k >= model.K/2
%         Ucontrol = [140, 2.57];
%     else
%         Ucontrol = [20, 2.57];
%     end
%     [Measures, GTruth] = OnlineData(Measures, GTruth, Ucontrol, model, k);
% end

% figure,
for k = 2:model.K
%     refresh;
    zk = Measures.Z{k};                                 % current measurement
    own = GTruth.Ownship(:,k);                          % new ownship state
    Uk  = model.S(own, GTruth.Ownship(:,k-1));          % observer acceleration
%     [xk_new, q_new] = BernoulliPF(q_prev, Xki, zk_1, zk, own, Uk, model);       % filtering
    [xk_new, wk_new] = BootstrapPF(Xki, zk, model);
    
    %% update variables for next cycle
    Xki     = xk_new;                                       
%     q_prev  = q_new;
    zk_1    = zk;
    
    %%  collect the estimation results
    P   = xk_new*xk_new'./(model.N-1);                          % estimation covariance
%     Result.q(k) = q_new;
%     if q_new > 0.8
        Result(mc).X{k} = xk_new*ones(model.N,1)/model.N;       % corresponds to sum(xk*wk)
        Result(mc).N(k) = 1;                                    % 1 for single target
        Result(mc).L{k} = [];                                   % empty for single target
        Result(mc).P{k} = P;                                    % estimated state covariance
%     end
    error = GTruth.X{k} - Result(mc).X{k};
    Result(mc).NEES(k) = error'*pinv(P)*error;
    %%  plot
    scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),100, 'filled','bd')   % ground truth position of the target
    hold on
%     scatter(xk_new(1,:),xk_new(3,:),'.r')                           % scatter particles on the ground truth
    scatter(Result.X{k}(1,:),Result.X{k}(3,:),100,'filled','ok')    % estimation result
    legend('Ground Truth', 'particles', 'Estimation')
end     % simulation


end     % monte carlo run

% for mc = 1:100
%     NEES(mc,:) = Result(mc).NEES(:);
% end
% ANEES       = mean(NEES,1);                       % average NEES
% stdOfNEES   = std(NEES,1);
% figure, plot(ANEES), title('ANEES of 100 Monte Carlo Runs')
% 
% hold on
% plot(ones(1,model.K),'--k')





