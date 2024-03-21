function [force,stretch] = lig_properties2()

e_trans = 0.03;
e = [0:0.001:0.3];
k = 1;

for i = 1:size(e,2)
    if (e(i) >= 0) & (e(i) <= 2*e_trans)
        f(i) = (0.25*k*e(i)*e(i))/(e_trans);
    elseif e(i) > 2*e_trans
        f(i) = k*(e(i)-e_trans);
    else
        f(i) = 0;
    end
end

stretch = 1+e;
force = f;




