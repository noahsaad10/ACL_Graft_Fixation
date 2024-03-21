function [mag] = calc_magnitude(X,Y,Z)

mag = nan(length(X),1);

for i = 1:length(X)
    mag(i) = sqrt(X(i)*X(i) + Y(i)*Y(i) + Z(i)*Z(i));
end