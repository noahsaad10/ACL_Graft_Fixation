clc
clear all
import org.opensim.modeling.*


osimModel = Model('C:\Users\noah-\Desktop\knee_test\ModelwithKneeLigaments.osim');

osimModel.setUseVisualizer(true)
state = osimModel.initSystem();
%osimModel.getVisualizer.show(state)
visualizer = osimModel.getVisualizer();
visualizer.show(state);
