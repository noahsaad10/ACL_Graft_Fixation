function [t1,t2] = calc_trans(fname,dof_name)

% fname = '../AP_Laxity/ap0_sim_states_degrees.mot';
% dof_name = 'knee_tx_r';

[d0,h0] = load_mot(fname);
t0 = d0(:,strcmp('time',h0));
k_tx0 = d0(:,strcmp(dof_name,h0));
ii0 = find(t0>2);
k_tx0_neutral = k_tx0(ii0(1));
t1 = max(k_tx0(ii0)-k_tx0_neutral);
t2 = min(k_tx0(ii0)-k_tx0_neutral);