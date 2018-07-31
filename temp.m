addr={};
data_hex={};
flag=[];
for i=1:length(pragueanactla1(:,1))
    if(~isempty(pragueanactla1{i,1}))
        flag(i,1)=1;
        addr{i,1}=pragueanactla1{i,1};
        data_hex{i,1}=pragueanactla1{i,12};
    end
end

ind=find(flag~=0);
addr_1={};
data_hex_1={};
for i=1:length(ind)
    addr_1{i,1}=addr{ind(i,1),1};
    data_hex_1{i,1}=data_hex{ind(i,1),1};
end

fid=fopen('D:\NCS_Cloud\Private\matlab_project\SourceData\lvds2edp.csv','wt');
for i=1:length(addr_1)
    fprintf(fid,'%s\t %s\n',addr_1{i,1}, data_hex_1{i,1});
end
fclose(fid);