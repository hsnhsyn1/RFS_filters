%%  Hasan Hüseyin Sönmez - 17.09.2018
%   Bernoulli type Bootstrap Particle filter
%   with sequential importance sampling & resampling (uniform)

%%  Input:  
%           * particles from previous cycle (xk_prev)
%           * new measurements (zk)
%           * previous measurements (zk_1) for birth density
%           * PF parameter file (PFparams)
%           * previous probability of existence (q_prev)
%           * ownship state (sensor position)
%%  Output:
%           * particles of the new cycle (xk_new).
%           * new particle weights (wk_new).


function [xk_new, q_update] = BernoulliPF(q_prev, xk_prev, zk_1, zk, own, Uk, model)

% Ns      = size(xk_prev,2);                              % number of particles
Bs      = model.B;                                      % number of birth particles
ps      = compute_Ps(xk_prev, model);                   % update probability of survival

x_birth = birth_model(zk_1, own, Bs, model);            % birth particles from the birth density
wk      = ones(model.N,1)/model.N;
q_pred  = model.pb*(1 - q_prev) + ps'*wk*q_prev;        % update the probability of existence -> Eq. (2.44)

%%  weight prediction
w_survive   = q_prev*ps.*wk;                    % update of surviving weights   -> Eq. (2.45)
w_birth     = model.pb*(1-q_prev)*(ones(Bs,1))./(Bs);          % update of birth weights       -> Eq. (2.45)

%%  prediction step
Xki     = cat(2,x_birth, xk_prev);                      % target state set predicted U birth (N+B particles)
Xki     = SampleParticles(Xki, model);              % predicted particles from birth density (markov density)
w_pred  = cat(1, w_survive, w_birth);                   % predicted weight set (NB+B weights)
w_pred  = w_pred/sum(w_pred);

q_pred  = limit_range(q_pred);
%%  measurement (RFS) likelihood computation step
M   = size(zk, 2);                                      % number of measurements at time k (cardinality of the measurement set)
PD  = compute_Pd(Xki, own, model);                      % compute probability of target detection
gkz = (1-PD)*model.Lambda*model.pdf_cz;                 % likelihood of no targets (empty set)

if M ~= 0
    for m = 1:M
        gkz = gkz + PD.*computeLikelihood(zk(:,m), Xki, model)';   % single target likelihood
%         Phik(m)   = gkz(m,:)*w_pred;
%         Ikz(m)  = sum(w_pred'.*gkz(m,:));              % approximation of spatial pdf sk(x)
    end
end

%%  update step
w_update    = gkz.*w_pred;  % weight update

q_update    = q_pred*sum(w_update)/( (model.Lambda*model.pdf_cz)*(1-q_pred) + q_pred*sum(w_update) );                    % update of probability of existence -> Eq (2.47)
q_update    = limit_range(q_update);

% normalize weights
w_update    = w_update/sum(w_update);

%% resampling (should be another function)- implement alternative resampling strategies
xk_new  = Resampling(Xki, w_update, model);             % updated particles


function clipped_r = limit_range(r)

r(r>0.999)=0.999;
r(r<0.001)=0.001;
clipped_r= r;


