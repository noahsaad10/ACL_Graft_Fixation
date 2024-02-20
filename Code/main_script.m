clc
clear all
import org.opensim.modeling.*


osimModel = Model('C:\Users\noah-\Desktop\Thesis_Knee\Models\gait_2003_model.osim');

% angles_to_test = deg2rad(-120):0.01:deg2rad(10);

% [strain_plot, force_plot, angles_plot] = get_strain_force_ligament(osimModel, 'Blankevoort1991', 'knee_flexion', angles_to_test);
% 
% % Plot the results
% figure(1);
% subplot(1,2,1)
% plot(rad2deg(angles_plot), strain_plot*100, 'LineWidth', 2);
% xlabel('Knee Flexion (degrees)');
% ylabel('ACL Strain [%]');
% title('ACL Strain vs Knee Flexion');
% grid on;
% subplot(1,2,2)
% plot(rad2deg(angles_plot), force_plot, 'LineWidth', 2);
% xlabel('Knee Flexion (degrees)');
% ylabel('Total Force [N]');
% title('Total Force vs Knee Flexion');
% grid on;




%% Adding the ligaments to the model

% Get the relevant bodies

femur_r = osimModel.get_BodySet().get('femur_r');
tibia_r = osimModel.get_BodySet().get('tibia_r');

% Get the CSV file with the data

anat_data = readtable('anatomical_data_ligament_knee.xlsx'); 

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


%% Applying external force

body_tibia = osimModel.get_BodySet().get('tibia_r'); 
ext_force = PrescribedForce("knee_force", body_tibia); % Create a prescribed force at tibia
ext_force.setPointIsInGlobalFrame(false);
ext_force.setForceIsInGlobalFrame(false);
ext_force.setPointFunctions(Constant(0.0), Constant(-0.429), Constant(0.0));
ext_force.setForceFunctions(Constant(-60), Constant(0), Constant(0));
ext_force.setTorqueFunctions(Constant(0), Constant(0), Constant(0));

% Add the force to the model 

osimModel.addForce(ext_force);
osimModel.finalizeConnections();


osimModel.setName('Ligament_Model_ACL_Fixation')

osimModel.print('./Models/Ligament_and_Muscle_Model.osim');










