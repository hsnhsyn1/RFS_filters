


function [Measures, gt] = OnlineData(Measures, gt, Ucontrol, model, k)

Xo_k = gt.Ownship(:,k-1);
%% sensor motion control procedure
if model.OwnControl
    Xo_k = OnlineOwnship(Xo_k, Ucontrol, model);
    gt.Ownship(:,k) = Xo_k;                     % save the trajectory
end
Measures = GenMeas(gt, model, Measures, k);     % online data generation


end