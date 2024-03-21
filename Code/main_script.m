clc
clear all
import org.opensim.modeling.*


print_flag = true; % To ouput plots 
with_viz = true; % To show visualizer
apply_external_force = true; % Apply external force on model 

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

ligament = {};



for i=1:height(anat_data)

    lig_name = anat_data{i,1}{1};

    if strcmp(lig_name, 'aACL') || strcmp(lig_name, 'pACL')
        ligament{i} = Blankevoort1991Ligament(lig_name, femur_r, ...
        Vec3(0.01*anat_data{i,2}, 0.01*anat_data{i,3},0.01*anat_data{i,4}), ...
        tibia_r, Vec3(0.01*anat_data{i,5}, ...
        0.01*anat_data{i,6},0.01*anat_data{i,7})); %note the 0.01 is to convert cm to m
        ligament{i}.set_slack_length(0.01*anat_data{i,9}); 
        ligament{i}.setLinearStiffnessForcePerLength(300);
        osimModel.addForce(ligament{i})
        
    else 
        ligament{i} = Blankevoort1991Ligament(lig_name, femur_r, ...
            Vec3(0.01*anat_data{i,2}, 0.01*anat_data{i,3},0.01*anat_data{i,4}), ...
            tibia_r, Vec3(0.01*anat_data{i,5}, ...
            0.01*anat_data{i,6},0.01*anat_data{i,7})); %note the 0.01 is to convert cm to m
        ligament{i}.set_linear_stiffness(anat_data{i,10});
        ligament{i}.set_slack_length(0.01*anat_data{i,9});
        osimModel.addForce(ligament{i})
    end


end



osimModel.finalizeConnections();
ref_state = osimModel.initSystem();
ligament{1}.setSlackLengthFromReferenceForce(80, ref_state);
ligament{2}.setSlackLengthFromReferenceForce(80,ref_state);
osimModel.finalizeConnections();


flexion = osimModel.getCoordinateSet().get('knee_angle_r');
%flexion.set_clamped(true)
flexion.set_default_value(deg2rad(10))
%flexion.set_locked(true)

osimModel.setName('Ligament_Model_ACL_Fixation')

osimModel.print('./Models/Ligament_and_Muscle_Model.osim');



if print_flag == true

    angles_to_test = deg2rad(-40):0.02:deg2rad(40);
    
    [strain_plot_aACL, force_plot_aACL, angles_plot] = get_strain_force_ligament(osimModel, 'aACL', 'knee_int_ext_rotation', angles_to_test);
    [strain_plot_pACL, force_plot_pACL, angles_plot] = get_strain_force_ligament(osimModel, 'pACL', 'knee_int_ext_rotation', angles_to_test);
    strain_tot = zeros(1, length(angles_plot));
    for i =1:length(angles_plot)
        strain_tot(i) = DIBS_strain(strain_plot_aACL(i), strain_plot_pACL(i));
    end
    % Plot the results
    figure(1);
    subplot(1,2,1)
    plot(rad2deg(angles_plot), strain_plot_aACL*100, 'kx-');
    hold on
    plot(rad2deg(angles_plot), strain_plot_pACL*100, 'rx-');
    hold on
    plot(rad2deg(angles_plot), strain_tot*100, 'bx-');
    ylabel('Strain');
    xlabel('angles (deg)');
    legend('aACL', 'pACL','DIBS' )
    title('Knee Internal Rotation vs ACL strain');
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
    ext_force.setTorqueFunctions(Constant(0), Constant(5), Constant(0));
    
    % Add the force to the model 
    
    osimModel.addForce(ext_force);
    osimModel.finalizeConnections();
end

%% Contracting a muscle example Bifemlh_r

bifem = osimModel.getMuscles().get('bifemlh_r');
semimem_r = osimModel.getMuscles().get('semimem_r');
tfl_r = osimModel.getMuscles().get('tfl_r');
grac_r = osimModel.getMuscles().get('grac_r');


aACL = osimModel.getForceSet().get('aACL');

strain = zeros(1, 300);

knee_flexion_coord = osimModel.getCoordinateSet().get('knee_int_ext_rotation').getOutput('value');
knee_flexion = zeros(1,300);

if with_viz == true
    osimModel.setUseVisualizer(true)
end
state = osimModel.initSystem();

if with_viz == true
    osimModel.getVisualizer.show(state)
end

stepsize = 0.01;

for i=1:2
    bifem.setActivation(state, 1)
    semimem_r.setActivation(state, 1)
    tfl_r.setActivation(state, 1)
    grac_r.setActivation(state, 1)
    manager = Manager(osimModel);
    manager.initialize(state);
    state = manager.integrate(stepsize*(i+1));
    strainOutput = aACL.getOutput('strain');
    strain(i) = str2double(strainOutput.getValueAsString(state));
    knee_flexion(i) = str2double(knee_flexion_coord.getValueAsString(state));    

    if with_viz == true
        osimModel.getVisualizer.show(state)
    end
end

figure(2)
plot(strain)

knee_flexion = rad2deg(knee_flexion);
figure(3)
plot(knee_flexion)
disp(mean(knee_flexion(200:end)))
%% Printing the final model

osimModel.setName('Ligament_Model_ACL_Fixation')

osimModel.print('./Models/Ligament_and_Muscle_Model.osim');










