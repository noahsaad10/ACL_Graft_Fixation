clc; clear all; close all;

model_nom = '../Model4/';
ligs_nom = read_osimLigs([model_nom 'runner18_scaled.osim']);

%load([model_nom '/Sensitivity/headers.mat'],'headers');
%load([model_nom '/Sensitivity/param_change.mat'],'delta');

%%
n_ligs = size(ligs_nom,1);
count = 0;

for i = 1:n_ligs
% for i = 1:1
    
    for jj = 1:size(ligs_nom,1)
        lig_names{jj,1} = ligs_nom{jj,1};
    end
    
    % decrease lig strain
    count = count + 1;
    lig_strain_new = str2double(ligs_nom(:,2));
    lig_strain_new(i,1) = lig_strain_new(i,1)+0.001;
    headers{count,1} = [ligs_nom{i,1} '_sl'];
    disp(['On Simulation ' num2str(count) ' of ' num2str(2*n_ligs)]);
    write_osimLigs([model_nom 'runner18_scaled.osim'],'../runner18_scaled.osim',lig_names,lig_strain_new,str2double(ligs_nom(:,3)));
    ligs_delta = read_osimLigs('../runner18_scaled.osim');
    delta(:,count) = [str2double(ligs_delta(:,2)) - str2double(ligs_nom(:,2));
                      str2double(ligs_delta(:,3)) - str2double(ligs_nom(:,3))];
    apLaxPrep();
    clc;
    disp(['On Simulation ap0 for ' ligs_nom{i,1} ' e0 #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../AP_Laxity/FD_Setup_ap0.xml');
    clc;
    disp(['On Simulation ap45 for ' ligs_nom{i,1} ' e0 #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../AP_Laxity/FD_Setup_ap45.xml');
    [a0,p0] = calc_trans('../AP_Laxity/ap0_sim_states_degrees.mot','knee_tx_r');
    [a45,p45] = calc_trans('../AP_Laxity/ap45_sim_states_degrees.mot','knee_tx_r'); 
    ieLaxPrep();
    clc;
    disp(['On Simulation ie0 for ' ligs_nom{i,1} ' e0 #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../IE_Laxity/FD_Setup_ie0.xml');
    clc;
    disp(['On Simulation ie45 for ' ligs_nom{i,1} ' e0 #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../IE_Laxity/FD_Setup_ie45.xml');
    [i0,e0] = calc_trans('../IE_Laxity/ie0_sim_states_degrees.mot','knee_rot_r');
    [i45,e45] = calc_trans('../IE_Laxity/ie45_sim_states_degrees.mot','knee_rot_r');
    ap_angs = [0;-45];
    ant_trans = 1000*[a0;a45];
    post_trans = 1000*[p0;p45];
    int_rot = [i0;i45];
    ext_rot = [e0;e45];
    save([model_nom '/Sensitivity/results' num2str(count) '.mat'],'ap_angs','ant_trans','post_trans','int_rot','ext_rot');
    save([model_nom '/Sensitivity/headers.mat'],'headers');
    save([model_nom '/Sensitivity/param_change.mat'],'delta');
    
    % descrease lig stiffness
    count = count + 1;
    lig_stiff_new = str2double(ligs_nom(:,3));
    lig_stiff_new(i,1) = 0.9*lig_stiff_new(i,1);
    headers{count,1} = [ligs_nom{i,1} '_k'];
    disp(['On Simulation ' num2str(count) ' of ' num2str(2*n_ligs)]);
    write_osimLigs([model_nom 'runner18_scaled.osim'],'../runner18_scaled.osim',lig_names,str2double(ligs_nom(:,2)),lig_stiff_new);
    ligs_delta = read_osimLigs('../runner18_scaled.osim');
    delta(:,count) = [str2double(ligs_delta(:,2)) - str2double(ligs_nom(:,2));
                      str2double(ligs_delta(:,3)) - str2double(ligs_nom(:,3))];
    apLaxPrep();
    clc;
    disp(['On Simulation ap0 for ' ligs_nom{i,1} ' k #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../AP_Laxity/FD_Setup_ap0.xml');
    clc;
    disp(['On Simulation ap45 for ' ligs_nom{i,1} ' k #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../AP_Laxity/FD_Setup_ap45.xml');
    [a0,p0] = calc_trans('../AP_Laxity/ap0_sim_states_degrees.mot','knee_tx_r');
    [a45,p45] = calc_trans('../AP_Laxity/ap45_sim_states_degrees.mot','knee_tx_r'); 
    ieLaxPrep();
    clc;
    disp(['On Simulation ie0 for ' ligs_nom{i,1} ' k #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../IE_Laxity/FD_Setup_ie0.xml');
    clc;
    disp(['On Simulation ie45 for ' ligs_nom{i,1} ' k #' num2str(count) ' of ' num2str(2*n_ligs)]);
    [status,cmdout]=system('forward -S ../IE_Laxity/FD_Setup_ie45.xml');
    [i0,e0] = calc_trans('../IE_Laxity/ie0_sim_states_degrees.mot','knee_rot_r');
    [i45,e45] = calc_trans('../IE_Laxity/ie45_sim_states_degrees.mot','knee_rot_r');
    ap_angs = [0;-45];
    ant_trans = 1000*[a0;a45];
    post_trans = 1000*[p0;p45];
    int_rot = [i0;i45];
    ext_rot = [e0;e45];
    save([model_nom '/Sensitivity/results' num2str(count) '.mat'],'ap_angs','ant_trans','post_trans','int_rot','ext_rot');
    save([model_nom '/Sensitivity/headers.mat'],'headers');
    save([model_nom '/Sensitivity/param_change.mat'],'delta');
    
end