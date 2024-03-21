function dc=body312(ang1,ang2,ang3)
% dc=body312(ang1,ang2,ang3) returns the direction cosine resulting from a body-fixed 3-1-2 rotation sequence
% where ang1 is the rotation about body axis 3
% where ang2 is the rotation about body axis 1
% where ang3 is the rotation about body axis 2
s1=sin(ang1);	c1=cos(ang1);
s2=sin(ang2);	c2=cos(ang2);
s3=sin(ang3);	c3=cos(ang3);
% Row 1
dc(1,1)=-s1*s2*s3+c1*c3;
dc(1,2)=-s1*c2;
dc(1,3)=s1*s2*c3+c1*s3;
% Row 2
dc(2,1)=c1*s2*s3+s1*c3;
dc(2,2)=c1*c2;
dc(2,3)=-c1*s2*c3+s1*s3;
% Row 3
dc(3,1)=-c2*s3;
dc(3,2)=s2;
dc(3,3)=c2*c3;








