eps = 1;

v_xP = out.get('v_xP').data;
x_P = out.get('x_P').data; % subtract initial value
tout = out.get('tout');
Ts = tout(2) - tout(1);
data_11 = iddata(x_P, v_xP, Ts);

% System identification
init_sys = idtf([1+eps 1], [1 1 0]);
init_sys.Structure.Denominator.Free(end) = false;
opts = tfestOptions('InitializeMethod', 'all');
G11 = tfest(data_11, init_sys, opts);