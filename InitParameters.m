%%  Hasan Hüseyin Sönmez - 17.09.2018
%   parameter file


function model = InitParameters

model.K         = 60;           % number of scans
model.Motion    = 'CT';         % motion model 'CT','CA','CV'
model.Meas      = 'Bearings';   % measurement model 'Linear' or 'Bearings'
model.xDim      = 5;            % state vector dimension is specified according to motion model
                                % 4: 2-D CV, 6: 2-D CA, 6: 3-D CV, 
                                % 9: 3-D CA, 5: 2-D CT
model.zDim      = 1;            % measurement vector dimension is specified according to the measurement model.
                                % 1: Bearings, 2: 2-D, 3: 3-D problems

%%  Target motion parameters:
model.dT        = 30;           % sampling interval (can be changed for asynchronous case)
model.bt        = 
model.B         = 
model.B2        = 
model.sigma_vel = 
model.w_std     = 

%%  Noise parameters
model.sigma_v   = 1*pi/180;     % measurement noise (in rad)

%%  Particle Filter parameters

%%  Bernoulli (RFS) parameters

%%  Sensor control parameters
