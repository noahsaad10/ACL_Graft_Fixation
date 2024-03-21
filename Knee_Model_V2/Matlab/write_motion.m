function done=write_motion(file,data,headers,name,sfmt,dfmt)
% Print out the final result
[m,n]=size(data);
fid = fopen(file,'w');
if (nargin>=4)
    fprintf(fid,['name %s\n'],name);
else
    fprintf(fid,['name %s\n'],file);
end    
if (nargin<5)
    sfmt='%16s ';
end
if (nargin<6)
    dfmt='%16.8f ';
end
fprintf(fid,'datacolumns %3d\n',n);
fprintf(fid,'datarows %4d\n',m);
% Assume first column is time
fprintf(fid,'range %10.6f %10.6f\n',min(data(:,1)),max(data(:,1)));
fprintf(fid,'cursor 1.0 1.0 0.0\n');
fprintf(fid,'keys m_key\n');
fprintf(fid,'wrap\n');
fprintf(fid,'enforce_loops no\n');
fprintf(fid,'enforce_constraints no\n');
fprintf(fid,'calc_derivatives -1.000000\n');
fprintf(fid,'event_color 0.000000 0.000000 0.000000\n');
fprintf(fid,'endheader\n');

for i=1:n
   fprintf(fid,sfmt,char(headers(i)));
end
fprintf(fid,'\n');

for i=1:m
   fprintf(fid,dfmt,data(i,:));
   fprintf(fid,'\n');
end
fclose(fid);
done=1;
