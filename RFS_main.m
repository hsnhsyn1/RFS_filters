%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

model = InitParameters;                 % initialize all parameters.
GTruth = GenTruth(model);               % generate ground truth target and observer trajectory
Measures = GenMeas(GTruth, model);      % offline data generation

%%  output variable initialization
Result.X = cell(model.K, 1);            % estimated state variable
Result.N = zeros(model.K, 1);           % estimated number of targets
Result.L = cell(model.K, 1);            % estimated target labels

%%  particle, weight, state initialization
q0      = model.q0;                     % initial prob. of existence
Wki     = ones(model.N,1)/model.N;      % initial, uniform weights
m_init  = [0.1;0;0.1;0];
P_init  = diag([100 10 100 10]).^2;
Xki     = gen_gms(1,m_init,P_init,model.N);

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

for k = 1:model.K
    zk = Measures.Z{k};                                 % current measurement
    [xk_new, wk_new] = BootstrapPF(Xki, zk, model);     % predicted particles
    
    
end


%% -----------------------------------------
%%%%%       function tests
a = [GTruth.X{:}];
figure, plot(a(1,:), a(3,:),'.r'), hold on
plot(GTruth.Ownship(1,:),GTruth.Ownship(3,:),'.b')

figure
for i = 1:75
    zz = Measures.Z{i};
    if ~isempty(zz)
        plot(i,zz,'.b'), hold on
    end
end
xlabel('time'), ylabel('angle (rad)')
ylim([-pi, pi])

% [xk_new, wk_new] = BootstrapPF(xk_prev, zk, model);