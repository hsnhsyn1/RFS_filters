%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

% rng('default')

model       = InitParameters;               % initialize all parameters.
GTruth      = GenTruth(model);              % generate ground truth target and observer trajectory
Measures    = GenMeas(GTruth, model);       % offline data generation

%%  output variable initialization
Result.X = cell(model.K, 1);            % estimated state variable
Result.N = zeros(model.K, 1);           % estimated number of targets
Result.L = cell(model.K, 1);            % estimated target labels

%%  particle, weight, state initialization
zk_1    = Measures.Z{1};   % first measurement
q_prev  = .1;                     % initial prob. of existence
Wki     = ones(model.N,1)/model.N;      % initial, uniform weights
model.m_init  = [7800; 0; 100; 0];
model.P_init  = diag([100 2 100 2]').^2;
own = GTruth.Ownship(:,1);
Xki = initParticles(model.m_init, model.P_init, own, model.N, model);

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

figure,
for k = 2:model.K
    refresh;
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
%     Result.q(k) = q_new;
%     if q_new > 0.8
        Result.X{k} = xk_new*ones(model.N,1)/model.N;       % corresponds to sum(xk*wk)
        Result.N(k) = 1;                                    % 1 for single target
        Result.L{k} = [];                                   % empty for single target
%     end
    %%  plot
%     scatter(GTruth.X{k}(1,:),GTruth.X{k}(3,:),100, 'filled','bd'), hold on
%     scatter(xk_new(1,:),xk_new(3,:),'.r')
%     scatter(Result.X{k}(1,:),Result.X{k}(3,:),100,'filled','ok')
%     legend('Ground Truth', 'particles', 'Estimation')
end

% figure, stem(Result.q)
%% -----------------------------------------
%%%%%       function tests
a = [GTruth.X{:}];
figure, plot(a(1,:), a(3,:),'.r'), hold on
plot(GTruth.Ownship(1,:),GTruth.Ownship(3,:),'.b')

b = [Result.X{:}];
plot(b(1,:),b(3,:),'k-')

% for i = 1:model.K
%     own = GTruth.Ownship(:,k);
%     zz = Result.X{i};
%     if ~isempty(zz)
% %         zz = zz+own;
%         plot(zz(1),zz(3),'-k'), hold on
%     end
% end

