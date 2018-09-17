%%  Hasan Hüseyin Sönmez - 17.09.2018
%   modeling function for target motion
%   nonlinear and/or linear: (CV, CA, CT model etc.)

%  the function will return a new state for a given model.


function Xnew = MarkovTransition(x, ModelParams, IsNoisy)

ProblemDim  = ModelParams.PDim;         % problem dimension 2-D or 3-D cartesian
SwitchModel = ModelParams.Motion;       % motion (dynamic) model
delT        = ModelParams.dT;           % sampling interval

switch SwitchModel
    case 'CV'
        switch ProblemDim
            %%  state vector is a 6-element vector: x = [x y z vx vy vz]'
            case 3
                X = [   x(1,:) + delT*x(4,:); ...
                        x(2,:) + delT*x(5,:); ...
                        x(3,:) + delT*x(6,:); ...
                        x(4,:); x(5,:); x(6,:) ];
            %%  state vector is a 4-element vector: x = [x y z vx vy vz]'
            case 2
                X = [   x(1,:) + delT*x(3,:); ...
                        x(2,:) + delT*x(4,:); ...
                        x(3,:); x(4,:)  ];
        end
    case 'CA'
        switch ProblemDim
            case 3
                %%  state vector is a 9-element vector: x = [x y z vx vy vz ax ay az]'
                X = [   x(1,:) + delT*x(4,:) + .5*x(7,:)*delT^2; ...
                        x(2,:) + delT*x(5,:) + .5*x(8,:)*delT^2; ...
                        x(3,:) + delT*x(6,:) + .5*x(9,:)*delT^2; ...
                        x(4,:) + delT*x(7,:); ...
                        x(5,:) + delT*x(8,:); ...
                        x(6,:) + delT*x(9,:); ...
                        x(7,:); x(8,:); x(9,:)];
            case 2
                %%  state vector is a 6-element vector: x = [x y vx vy ax ay]'
                X = [   x(1,:) + delT*x(3,:) + .5*x(5,:)*delT^2; ...
                        x(2,:) + delT*x(4,:) + .5*x(6,:)*delT^2; ...
                        x(3,:) + delT*x(5,:); ...
                        x(4,:) + delT*x(6,:); ...
                        x(5,:); x(6,:)  ];
        end
    case 'CT' % non-linear
        %%  state vector is a 5-element vector: x = [x y vx vy w]'
        if ProblemDim ~= 2
            msgbox('CT model is defined for 2-D problems.')
        else
            %%  this is a 2-D model, state vector: x = [x y vx vy w]'
            L = size(x,2);      % for multiple states
            w = x(5,:);         % previous turn rate
            sin_omega_T = sin(w*delT);
            cos_omega_T = cos(w*delT);
            a = delT*ones(1,L); b = zeros(1,L);
            tol = 1e-10;
            idx = find( abs(w) > tol );
            a(idx) = sin_omega_T(idx)./w(idx);
            b(idx) = (1-cos_omega_T(idx))./w(idx);
            X(1,:) = x(1,:) + a.*x(3,:) - b.*x(4,:);
            X(2,:) = x(2,:) + b.*x(3,:) + a.*x(4,:);
            X(3,:) = cos_omega_T.*x(3,:) - sin_omega_T.*x(4,:);
            X(4,:) = sin_omega_T.*x(3,:) + cos_omega_T.*x(4,:);
            X(5,:) = x(5,:);
        end
end

%   B identity matrix
%   B2:
if IsNoisy
    Vk = ModelParams.B*randn(size(ModelParams.B,2),size(X,2));
    Xnew = X + ModelParams.B2*Vk;       % process noise with scale
else
    Xnew = X;
end




end