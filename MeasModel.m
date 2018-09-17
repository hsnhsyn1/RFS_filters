%%  Hasan Hüseyin Sönmez - 17.09.2018
%   generating/selecting mesurement model
%   measurement model can be linear (a matrix) or non-linear (a function)

%%   possible choices:
%           * bearings measurements,
%           * cartesian measurements

function Zk = MeasModel(Xk, ModelParams)

SwitchModel = ModelParams.Meas;         % get the measurement model to use.
ProblemDim  = ModelParams.PDim;         % problem dimension 2-D or 3-D cartesian
NumOfMeas   = ModelParams.Nmeas;        % number of total measurements (scans)

switch SwitchModel
    case 'Linear'
        switch ProblemDim
            case 3
                % measurement matrix
                H = [eye(3); zeros(3,size(Xk)-3)];
            case 2
                H = [eye(2); zeros(2,size(Xk)-2)];
        end
        h = @(x) H*x;
        z = h(Xk);        % transformed measurements
        Zk = z + sigma_w*randn(size(z,1), NumOfMeas);
    case 'Bearings'
        switch ProblemDim
            case 3
                %% Do be defined...
            case 2
                % four-quadrant inverse tangent, Zk in (-pi,pi)
                h = @(x) atan2(x(1,:),x(2,:));
        end
        z = h(Xk);        % transformed measurements
        Zk = z + sigma_w*randn(size(z,1), NumOfMeas);
        %% ------------------------
        % review
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