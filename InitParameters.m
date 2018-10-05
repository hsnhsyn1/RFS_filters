%%  Hasan Hüseyin Sönmez - 17.09.2018
%   parameter file
%   target state x:= [x vx y vz]'


function model = InitParameters

model.Concept   = 'single';     % filtering concept: 'single', 'Ber', 'MeMBer', 'PHD', ...
                                % 'CPHD', 'CBMeMBer', 'LMB', 'GLMB'
model.dT        = 30;           % sampling interval (can be changed for asynchronous case)
model.K         = 60;           % number of scans
model.Nmeas     = 1;            % number of measurements in a scan
model.Motion    = 'CV';         % motion model 'CT','CA','CV'
model.Meas      = 'Bearings';   % measurement model 'Linear' or 'Bearings'
model.xDim      = 4;            % state vector dimension is specified according to motion model
                                % 4: 2-D CV, 6: 2-D CA, 6: 3-D CV, 
                                % 9: 3-D CA, 5: 2-D CT
model.zDim      = 2;            % measurement vector dimension is specified according to the measurement model.
                                % 1: Bearings, 2: 2-D, 3: 3-D problems
model.PDim      = 2;            % problem dimension: 2-D or 3-D
model.vDim      = model.xDim;   % process noise vector size
model.wDim      = model.zDim;   % measurement noise vector size
model.Sampling  = 'bootstrap';  % 'bootstrap' uses transitional pdf (Markov transition)
model.Resampling = 'standard';


%%  Noise parameters
model.sigma_w   = diag([2*pi/180; 100]);                 % measurement noise std (in rad)
model.sigma_v   = .1;                              % process noise intensity
model.Qk        = model.sigma_v*kron(eye(model.PDim),[(model.dT^3)/3 (model.dT^2)/2; (model.dT^2)/2 model.dT]);
model.R         = model.sigma_w*model.sigma_w';     % mesurement error covariance


%%  Target motion parameters:
model.sigma_vel = 5;            % velocity standard deviation
model.w_std     = 1*pi/180;     % for CT model
model.bt        = model.sigma_vel*[(model.dT^2)/2; model.dT];
model.B2        = [kron([eye(2), zeros(2,1)],model.bt); 0 0 model.w_std*model.dT];

%%  Particle Filter parameters
model.N         = 10000;         % number of particles
model.B         = 3000;         % number of birth particles

%%  Bernoulli (RFS) parameters
%   parameterized as state dependent. (from Vo)
model.ps = 0.98;                % probability of survival of a track to the next scan
model.pb = 0.01;                % birth probability

%%  Birth/initialization parameters
model.r_init    = 7.5e3;         % expected target range (meters)
model.stdr      = 1.5e3;        % standard deviation of the range
model.stds      = 3.5;          % standard deviation of velocity components (m/s)

%%  Observation parameters
% transitional probability matrix to model the dynamics of target
% appearance eps_k whic is in {0, 1} referred to as the target existence.
model.TPM       = [(1-model.pb) model.pb; (1-model.ps) model.ps];
model.q0        = 0.99;            % initial target existence probability
model.MaxRange  = 10e3;

%%  Clutter parameters
model.range_cz  = [-pi/2, pi/2; 0 2e3];    % clutter range
model.pdf_cz    = 1/prod(model.range_cz(:,2) - model.range_cz(:,1)); % clutter spatial distribution is uniform
model.Lambda    = 0;            % average clutter (will be varied)
model.pD        = 1;          % probability of detection (will be varied)-state dependent parameterization

%%  Sensor control parameters
model.OwnControl = false;       % is sensor control is present, for observer trajectory generation
model.IsMoving   = false;       % is the sensor moving? (i.e. Bearings-Only)
%   S: deterministic matrix for observer accelerations for 2-D CV motion.
model.S = @(xOk, xOk_1) [   xOk(1) - xOk_1(1) - model.dT*xOk_1(2); ...
                            xOk(2) - xOk_1(2);
                            xOk(3) - xOk_1(3) - model.dT*xOk_1(4); ...
                            xOk(4) - xOk_1(4) ];
