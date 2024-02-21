clc
clear all
import org.opensim.modeling.*


print_flag = false; % To ouput plots 
with_viz = true; % To show visualizer
apply_external_force = false; % Apply external force on model 

osimModel = Model('C:\Users\noah-\Desktop\Thesis_Knee\Models\gait_2003_model.osim');

%% Adding the ligaments to the model

% Get the relevant bodies

femur_r = osimModel.get_BodySet().get('femur_r');
tibia_r = osimModel.get_BodySet().get('tibia_r');

% Get the XLSX file with the data

% Set 'VariableNamingRule' to 'preserve'
opts = detectImportOptions('anatomical_data_ligament_knee.xlsx');
opts.VariableNamingRule = 'preserve';

anat_data = readtable('anatomical_data_ligament_knee.xlsx', opts); 

for i=1:height(anat_data)

    ligament = Blankevoort1991Ligament(anat_data{i,1}{1}, femur_r, ...
        Vec3(0.01*anat_data{i,2}, 0.01*anat_data{i,3},0.01*anat_data{i,4}), ...
        tibia_r, Vec3(0.01*anat_data{i,5}, ...
        0.01*anat_data{i,6},0.01*anat_data{i,7})); %note the 0.01 is to convert cm to m
    ligament.set_linear_stiffness(anat_data{i,10});
    ligament.set_slack_length(0.01*anat_data{i,9});
    osimModel.addForce(ligament)
end


osimModel.finalizeConnections();


if print_flag == true

    angles_to_test = deg2rad(-120):0.01:deg2rad(10);
    
    [strain_plot_aACL, force_plot_aACL, angles_plot] = get_strain_force_ligament(osimModel, 'aACL', 'knee_angle_r', angles_to_test);
    [strain_plot_pACL, force_plot_pACL, angles_plot] = get_strain_force_ligament(osimModel, 'pACL', 'knee_angle_r', angles_to_test);
    
    % Plot the results
    figure(1);
    subplot(1,2,1)
    plot(rad2deg(angles_plot), strain_plot_aACL*100, 'b', 'LineWidth', 2);
    hold on
    plot(rad2deg(angles_plot), strain_plot_pACL*100, 'r', 'LineWidth', 2);
    xlabel('Knee Flexion (degrees)');
    ylabel('aACL Strain [%]');
    legend('aACL', 'pACL')
    title('ACL Strain vs Knee Flexion');
    grid on;
    subplot(1,2,2)
    plot(rad2deg(angles_plot), force_plot_aACL, 'b', 'LineWidth', 2);
    hold on
    plot(rad2deg(angles_plot), force_plot_pACL, 'r', 'LineWidth', 2);
    xlabel('Knee Flexion (degrees)');
    ylabel('Total Force [N]');
    title('Total Force vs Knee Flexion pACL');
    legend('aACL', 'pACL')
    grid on;
end



%% Applying external force
if apply_external_force == true
    body_tibia = osimModel.get_BodySet().get('tibia_r'); 
    ext_force = PrescribedForce("knee_force", body_tibia); % Create a prescribed force at tibia
    ext_force.setPointIsInGlobalFrame(false);
    ext_force.setForceIsInGlobalFrame(false);
    ext_force.setPointFunctions(Constant(0.0), Constant(-0.429), Constant(0.0));
    ext_force.setForceFunctions(Constant(0), Constant(0), Constant(0));
    ext_force.setTorqueFunctions(Constant(0), Constant(0), Constant(0));
    
    % Add the force to the model 
    
    osimModel.addForce(ext_force);
    osimModel.finalizeConnections();
end

%% Contracting a muscle

bifem = osimModel.getMuscles().get('bifemlh_r');

if with_viz == true
    osimModel.setUseVisualizer(true)
end
state = osimModel.initSystem();

if with_viz == true
    osimModel.getVisualizer.show(state)
end

stepsize = 0.01;

for i=1:30
    bifem.setActivation(state, 0.5)
    manager = Manager(osimModel);
    manager.initialize(state);
    state = manager.integrate(stepsize*(i+1));
    if with_viz == true
        osimModel.getVisualizer.show(state)
    end
end


osimModel.setName('Ligament_Model_ACL_Fixation')

osimModel.print('./Models/Ligament_and_Muscle_Model.osim');










