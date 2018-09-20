%%  Hasan Hüseyin Sönmez - 17.09.2018
%   function implements the measurement likelihood (single target)
%   the measurement likelihood has the density is f_w( z - h(x) ).

%%   Function inputs:
%                   * zk    : actual measurements
%                   * model : model parameters.
%                   * zk_hat: measurement prediction from the predicted
%                   particles.
%

function gk_z = computeLikelihood(zk, zk_hat, model)

R       = model.R;                          % measurement covariance matrix
invR    = R^(-1);                           % inverse of the measurement covariance (ignores the correlation)
expo    = sum((invR*(repmat(zk,[1 size(zk_hat,2)])-zk_hat).^2),1);
gk_z    = exp(-expo/2-log(2*pi*det(R)));    % likelihood value


end