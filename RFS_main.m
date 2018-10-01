%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

model = InitParameters;                 % initialize all parameters.
GTruth = GenTruth(model);               % generate ground truth target and observer trajectory
% Measures = GenMeas(GTruth, model);      % offline data generation

% initial target state
Xo_k   = [0; 2.57*sin(140*pi/180); 0; 2.57*cos(140*pi/180)];       % 5 knots, 140 deg
GTruth.Ownship(:,1) = Xo_k;                 % initial observer state
xinit   = [500; 3; 400; 4];                 % initial target state
ChangeCourse = false;

Measures.Z = cell(model.K,1); % initialize measurement structure
Measures.Z{1} = MeasFcn(xinit-Xo_k, model, true);     % first measurement

%%  main filtering loop
for k = 2:model.K
    if k >= model.K/2
        ChangeCourse = true;
    end
    %% sensor motion control procedure
    if model.OwnControl
        if ~ChangeCourse
            Ucontrol = [140, 2.57];
        else
            Ucontrol = [20, 2.57];
        end
        Xo_k = OnlineOwnship(Xo_k, Ucontrol, model);
        GTruth.Ownship(:,k) = Xo_k;                     % save the trajectory
    end
    Measures = GenMeas(GTruth, model, Measures, k);     % online data generation
    
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