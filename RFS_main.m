%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

model = InitParameters;         % initialize all parameters.

x0 = 3*randn(model.xDim,model.N);               % initial particles
xk_prev = x0;                                   % initial
zk = 3;

GTruth = GenTruth(model);
Measures = GenMeas(GTruth, model);


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