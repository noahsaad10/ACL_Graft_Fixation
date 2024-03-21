clc; clear all; close all;

[d,h] = load_sto('../Contact Test/Runner18_ForceReporter_forces.sto');
[d2,h2] = load_sto('../Contact Test/Runner18_states.sto');

% write tibia_r_force_vx, vy, vz, px, py, pz
med_fx = d(:,strcmp('medial_tf.tibia_r.force.X',h));
med_fy = d(:,strcmp('medial_tf.tibia_r.force.Y',h));
med_fz = d(:,strcmp('medial_tf.tibia_r.force.Z',h));
med_tx = d(:,strcmp('medial_tf.tibia_r.torque.X',h));
med_ty = d(:,strcmp('medial_tf.tibia_r.torque.Y',h));
med_tz = d(:,strcmp('medial_tf.tibia_r.torque.Z',h));

lat_fx = d(:,strcmp('lateral_tf.tibia_r.force.X',h));
lat_fy = d(:,strcmp('lateral_tf.tibia_r.force.Y',h));
lat_fz = d(:,strcmp('lateral_tf.tibia_r.force.Z',h));
lat_tx = d(:,strcmp('lateral_tf.tibia_r.torque.X',h));
lat_ty = d(:,strcmp('lateral_tf.tibia_r.torque.Y',h));
lat_tz = d(:,strcmp('lateral_tf.tibia_r.torque.Z',h));

for i = 1:size(lat_fx,1)
    
    med_fx2 = med_fx(i,1);
    med_fy2 = med_fy(i,1);
    med_fz2 = med_fz(i,1);
    lat_fx2 = lat_fx(i,1);
    lat_fy2 = lat_fy(i,1);
    lat_fz2 = lat_fz(i,1);
    
    A = [0        med_fz2   -med_fy2;
        -med_fz2     0       med_fx2;
         med_fy2  -med_fx2      0];
    B = [med_tx(i,1); med_ty(i,1); med_tz(i,1)];
    X = A\B;
    
    med_cop(i,1:3) = X';
    
end