clc
clear all
import org.opensim.modeling.*


model = Model("C:\Users\noah-\Desktop\Knee_Model_V2\runner18_scaled_passiveFlex.osim");

% Get the relevant bodies

femur_r = model.get_BodySet().get('femur_r');
tibia_r = model.get_BodySet().get('tibia_r');

muscle = Thelen2003Muscle('bifemlh_r', 804, 0.173000, 0.089000, 0.401426);

muscle.addNewPathPoint('femur_insertion', femur_r, Vec3(0.005, -0.248, 0.027))
muscle.addNewPathPoint('tibia_insertion', tibia_r, Vec3(-0.034, -0.040, 0.033))
muscle.addNewPathPoint('tibia_insertion_2', tibia_r, Vec3(-0.026, -0.063, 0.039))
model.addForce(muscle)
model.finalizeConnections()

model.print("C:\Users\noah-\Desktop\Knee_Model_V2\trial_model_add_muscle.osim");

aACL = model.getMuscles().get('aACL_muscle');
