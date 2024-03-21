function [k_OSC] = stiffness_conversion(k, ligament)

    slack_length = ligament.get_slack_length();

    k_OSC = k*slack_length;
end