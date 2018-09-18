%%  Hasan Hüseyin Sönmez - 17.09.2018
%   Bootstrap type Particle filter
%   with sequential importance sampling & resampling (uniform)

%%  Input:  
%           * particles from previous cycle (xk_prev)
%           * new measurements (zk)
%           * PF parameter file (PFparams)
%%  Output:
%           * particles of the new cycle (x_ki).

clc; clearvars; close all;
model = InitParameters;
x0 = 3*randn(model.xDim,model.N);               % initial particles
xk_prev = x0;                                   % initial
% function x_ki = BootstrapPF(xk_prev, zk, model)

Ns      = size(xk_prev,2);                              % number of particles
xki     = MarkovTransition(xk_prev, model, true);       % predicted particles
z_pred  = MeasModel(xki, model, false);                 % predicted measurements



% end