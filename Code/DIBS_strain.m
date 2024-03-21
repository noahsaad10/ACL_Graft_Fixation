function [strain_bundle] = DIBS_strain(strain_i, strain_j)

    if strain_i >= 0 && strain_j >= 0
        strain_bundle = abs(strain_i-strain_j);
    elseif strain_i <= 0 && strain_j <= 0
        strain_bundle = 0;
    elseif strain_i > 0 && strain_j < 0 || strain_j > 0 && strain_i < 0
        if strain_i+strain_j <= 0
            strain_bundle = 0;
        else
            strain_bundle = abs(strain_i+strain_j);
        end
    end


end