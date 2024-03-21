function [p] = calc_COP(FX,FY,FZ,TX,TY,TZ)

p = nan(length(FX),3);

for i = 1:length(FX)
    
    if calc_magnitude(FX(i),FY(i),FZ(i))>1
        
        A = [0      FZ(i)   -FY(i);
            -FZ(i)   0       FX(i);
            FY(i)  -FX(i)    0];
        b = [TX(i); TY(i); TZ(i)];
        
        COP = pinv(A)*b;
        
        p(i,1:3) = COP';
        
    end
    
end