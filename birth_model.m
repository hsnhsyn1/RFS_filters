%%  Hasan Hüseyin Sönmez - 02.10.2018
%   target birth model for Bernoulli Particle Filter


function x_birth = birth_model(Zk, own, NumBirth, model)

%%  initialization parameters

stdr = model.stdr;
stds = model.stds;
stdc = model.sigma_w;

rmean = model.r_init;
smean = 2;                     % m/s

r = rmean + stdr*randn(1,NumBirth);
s = smean + stds*randn(1,NumBirth);

M = size(Zk,2);         % cardinality of the measurement set
if M ~= 0
    for m = 1:M
        cmean   = Zk(:,m)+pi;                          % add reference
        c(m,:)  = cmean + stdc*randn(1,NumBirth);
        px(m,:) = r.*sin(Zk(:,m));
        py(m,:) = r.*cos(Zk(:,m));
    end
    
    c   = sum(c,1)/M;
    px  = sum(px,1)/M;
    vx  = s.*sin(c)-own(2);
    py  = sum(py,1)/M;
    vy  = s.*cos(c)-own(4);
    
    x_birth = [ px; vx; py; vy];
else
    x_birth = initParticles(model.m_init, model.P_init, NumBirth, model);
end


end