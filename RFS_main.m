%%  Hasan Hüseyin Sönmez - 14.09.2018

% First RFS based filter implementation.

clc; clearvars; close all;

model = InitParameters;         % initialize all parameters.

x0 = 3*randn(model.xDim,model.N);               % initial particles
xk_prev = x0;                                   % initial
zk = 3;

[xk_new, wk_new] = BootstrapPF(xk_prev, zk, model);