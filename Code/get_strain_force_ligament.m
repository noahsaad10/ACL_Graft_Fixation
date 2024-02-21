function [strain_plot, force_plot, angles_plot] = get_strain_force_ligament(model, ligament, coordinate_name, angles_to_test)


% Get the MuscleSet from the model
forceSet = model.getForceSet();

% Get the number of muscles in the MuscleSet
numForces = forceSet.getSize();

% Initialize a cell array to store muscle names
forceNames = cell(numForces, 1);

% Loop through each muscle and store its name
for i = 0:numForces-1
    force = forceSet.get(i);
    forceNames{i+1} = char(force.getName());
end

% Get the ligament
ligament_desired = forceSet.get(ligament);

angle = angles_to_test;

coordinateSet = model.getCoordinateSet();

% Get the knee flexion coordinate
coordinate = coordinateSet.get(coordinate_name);

% Initialize the OpenSim state
state = model.initSystem();

% Get the ACL strain output
strainOutput = ligament_desired.getOutput('strain');
forceOutput = ligament_desired.getOutput('total_force');

% Initialize arrays to store results
strainValues = zeros(1, length(angle));
forceValues = zeros(1, length(angle));

% Set different knee angles and calculate ACL strain
for i = 1:length(angle)

    current_state = model.initSystem();
    % Set the knee flexion angle
    coordinate.setValue(current_state, angle(i));
    
    % Realize velocity to update the state
    model.realizeVelocity(current_state);
    
    % Get the ACL strain at the current knee angle
    strainValues(i) = str2double(strainOutput.getValueAsString(current_state));
    forceValues(i) = str2double(forceOutput.getValueAsString(current_state));
end

angles_plot = angles_to_test;
strain_plot = strainValues; 
force_plot = forceValues;