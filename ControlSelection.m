%%  Hasan Hüseyin Sönmez - 28.09.2018
%   Control vector selection

%%  Input   :
%               U_k-1 : control vectors set
%               x_k-1 : particles to be predicted
%%  Output  :
%               u_k-1 : optimal control vector to be applied in the next
%                           cycle

function uk_1 = ControlSelection(Uk_1, xk_1)

Nc = size(Uk_1, 2);                 % set of control vectors (col vectors)
for i = 1:Nc
    v       = Uk_1(:,i);            % candidate control vector
    x_pred  = 
end



end