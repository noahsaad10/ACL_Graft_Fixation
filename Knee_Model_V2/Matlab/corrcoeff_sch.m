function [r,p]=corrcoeff_sch(x,y)

[r1,p1] = corrcoef(x,y,'rows','pairwise');
r = r1(1,2);
p = p1(1,2);

r = round(1000*r)/1000;
p = round(1000*p)/1000;