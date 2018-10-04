%%  Hasan Hüseyin Sönmez - 17.09.2018
%   modeling function for target motion
%   nonlinear and/or linear: (CV, CA, CT model etc.)

%   the function will return a new state for a given model.
%   state vector x:= [x vx ax y vy ay ...]'


function Xnew = MarkovTransition(x, ModelParams, IsNoisy)

ProblemDim  = ModelParams.PDim;         % problem dimension 2-D or 3-D cartesian
SwitchModel = ModelParams.Motion;       % motion (dynamic) model
delT        = ModelParams.dT;           % sampling interval

switch SwitchModel
    case 'CV'
        switch ProblemDim
            %%  state vector is a 6-element vector: x = [x vx y vy z vz]'
            case 3
                X = [   x(1,:) + delT*x(2,:); ...
                        x(2,:); ...
                        x(3,:) + delT*x(4,:); ...
                        x(4,:); ...
                        x(5,:) + delT*x(6,:); ...
                        x(6,:) ];
                %%  state vector is a 4-element vector: x = [x vx y vy]'
            case 2
                X = [   x(1,:) + delT*x(2,:); ...
                        x(2,:); ...
                        x(3,:) + delT*x(4,:); ...
                        x(4,:) ];
        end
    case 'CA'
        switch ProblemDim
            case 3
                %%  state vector is a 9-element vector: x = [x vx ax y vy ay z vz az]'
                X = [   x(1,:) + delT*x(2,:) + .5*x(3,:)*delT^2; ...
                        x(2,:) + delT*x(3,:); ...
                        x(3,:); ...
                        x(4,:) + delT*x(5,:) + .5*x(6,:)*delT^2; ...
                        x(5,:) + delT*x(6,:); ...
                        x(6,:); ...
                        x(7,:) + delT*x(8,:) + .5*x(9,:)*delT^2; ...
                        x(8,:) + delT*x(9,:); ...
                        x(9,:) ];
            case 2
                %%  state vector is a 6-element vector: x = [x vx ax y vy ay]'
                X = [   x(1,:) + delT*x(2,:) + .5*x(3,:)*delT^2; ...
                        x(2,:) + delT*x(3,:); ...
                        x(3,:); ...
                        x(4,:) + delT*x(5,:) + .5*x(6,:)*delT^2; ...
                        x(5,:) + delT*x(6,:); ...
                        x(6,:) ];
        end
    case 'CT' % non-linear
        %%  state vector is a 5-element vector: x = [x vx y vy w]'
        if ProblemDim ~= 2
            msgbox('CT model is defined for 2-D problems.')
        else
            %%  this is a 2-D model, state vector: x = [x vx y vy w]'
            L = size(x,2);      % for multiple states
            w = x(5,:);         % previous turn rate
            sin_omega_T = sin(w*delT);
            cos_omega_T = cos(w*delT);
            a = delT*ones(1,L); b = zeros(1,L);
            tol = 1e-10;
            idx = find( abs(w) > tol );
            a(idx) = sin_omega_T(idx)./w(idx);
            b(idx) = (1-cos_omega_T(idx))./w(idx);
            X(1,:) = x(1,:) + a.*x(2,:) - b.*x(4,:);
            X(3,:) = x(3,:) + b.*x(2,:) + a.*x(4,:);
            X(2,:) = cos_omega_T.*x(2,:) - sin_omega_T.*x(4,:);
            X(4,:) = sin_omega_T.*x(2,:) + cos_omega_T.*x(4,:);
            X(5,:) = x(5,:);
%             f = @(x) [  x(1,:) + a.*x(2,:) - b.*x(4,:); ...
%                         cos_omega_T.*x(2,:) - sin_omega_T.*x(4,:); ...
%                         x(3,:) + b.*x(2,:) + a.*x(4,:); ...
%                         sin_omega_T.*x(2,:) + cos_omega_T.*x(4,:); ...
%                         x(5,:) ];
        end
end


if IsNoisy
    Xnew = X + ModelParams.sigma_v*randn(size(X));       % process noise with scale
else
    Xnew = X;
end




end