%%  Hasan Hüseyin Sönmez - 02.10.2018
%   target birth model for Bernoulli Particle Filter


function x_birth = birth_model(Zk, own, NumBirth, model)

%%  initialization parameters

stdr = model.stdr;
stds = model.stds;
stdc = model.sigma_w(1);

smean = 2;                     % m/s
s = smean + stds*randn(1,NumBirth);

M = size(Zk,2);         % cardinality of the measurement set
if M ~= 0
    for m = 1:M
        cmean   = Zk(1,m) + pi;                          % add reference
        rmean   = Zk(2,m);
        c(m,:)  = cmean + stdc*randn(1,NumBirth);
        r(m,:)  = rmean + stdr*randn(1,NumBirth);
        px(m,:) = r(m,:).*repmat(sin(Zk(1,m)),[1, NumBirth]);
        py(m,:) = r(m,:).*repmat(cos(Zk(1,m)),[1, NumBirth]);
    end
    
    c   = sum(c,1)/M;
    px  = sum(px,1)/M;
    vx  = s.*sin(c)-own(2);
    py  = sum(py,1)/M;
    vy  = s.*cos(c)-own(4);
    
    x_birth = [ px; vx; py; vy];
else
    x_birth = initParticles(model.m_init, model.P_init, own, NumBirth, model);
end


end