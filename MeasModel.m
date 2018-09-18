%%  Hasan Hüseyin Sönmez - 17.09.2018
%   generating/selecting mesurement model
%   measurement model can be linear (a matrix) or non-linear (a function)

%%   possible choices:
%           * bearings measurements,
%           * cartesian measurements

function Zk = MeasModel(Xk, ModelParams, IsNoisy)

SwitchModel = ModelParams.Meas;         % get the measurement model to use.
ProblemDim  = ModelParams.PDim;         % problem dimension 2-D or 3-D cartesian
NumOfMeas   = ModelParams.Nmeas;        % number of total measurements (scans)
sigma_w     = ModelParams.sigma_w;      % measurement noise std
wDim        = ModelParams.wDim;         % measurement noise dimension

switch SwitchModel
    case 'Linear'
        switch ProblemDim
            case 3
                % measurement matrix
                switch size(x,1)
                    case 9          % meaning CA motion model
                        h = @(x) [x(1,:); x(4,:); x(7,:)];
                    case 6          % meaning CV motion model
                        h = @(x) [x(1,:); x(3,:); x(5,:)];
                end
            case 2
                switch size(x,1)
                    case 6          % CA motion
                        h = @(x) [x(1,:); x(4,:)];
                    case 4          % CV motion
                        h = @(x) [x(1,:); x(3,:)];
                end
         end
        z = h(Xk);        % transformed measurements
        if IsNoisy
            Zk = z + sigma_w*randn(wDim, NumOfMeas);
        else
            Zk = z;
        end
    case 'Bearings'
        switch ProblemDim
            case 3
                %% Do be defined...
            case 2
                % four-quadrant inverse tangent, Zk in (-pi,pi)
                h = @(x) atan2(x(1,:),x(3,:));
        end
        z = h(Xk);        % transformed measurements
        if IsNoisy
            Zk = z + sigma_w*randn(wDim, NumOfMeas);
        else
            Zk = z;
        end
        %% ------------------------
        % revise...
        if Zk <= -pi
            Zk = 2*pi + Zk;
        elseif Zk > pi
            Zk = Zk - 2*pi;
        else
            Zk = Zk;
        end
        % -------------------------
end


end