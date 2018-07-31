function [frange_start, frange_stop, rj_seperate, rj_power]=rj_seperate(fcarrier,freq,pnoise_ssb,integ_start,integ_stop)

rj_total=rj_calc(fcarrier,freq,pnoise_ssb,integ_start,integ_stop);
ind=find(integ_start<=freq);
if ind(1)==1
    ind_start=1;
else
    ind_start=ind(1)-1;
end
ind=find(integ_stop>=freq);
if ind(end)+1>length(freq)
ind_stop=ind(end);
else
    ind_stop=ind(end)+1;
end
freq=freq(ind_start:ind_stop);
pnoise_ssb=pnoise_ssb(ind_start:ind_stop);
freq_all=10.^(0:1:9)';
ind=find(freq(1)<freq_all);
ind_start=ind(1);
ind=find(freq(end)>freq_all);
ind_stop=ind(end);
freq_corase=freq_all(ind_start:ind_stop);

ind_fine=zeros(length(freq_corase),1);
for i=1:length(freq_corase)
    ind=find(freq>=freq_corase(i));
    ind_fine(i)=ind(1);
end
ind_fine=[1;ind_fine;];
A=zeros(length(ind_fine)-1,3);
rj_seperate=zeros(length(ind_fine)-1,1);
rj_power=zeros(length(ind_fine)-1,1);

for i=1:length(ind_fine)-1
    [rj_seperate(i),rj_power(i)]=rj_calc(fcarrier,freq,pnoise_ssb,freq(ind_fine(i)),freq(ind_fine(i+1)));
    A(i,:,:)=[freq(ind_fine(i)),freq(ind_fine(i+1)),rj_seperate(i)];
end
frange_start=A(:,1);
frange_stop=A(:,2);
%{
fprintf(' Rj Integral Table\n');
fprintf(' Rj from %.2e Hz to %.2e Hz: %.3e sec\n',freq(1),freq(end),rj_total);
fprintf('Start Freq.(Hz)   Stop Freq.(Hz)   Rj(Sec)\n');
fprintf('  %0.2e           %0.2e      %0.3e\n', A');
%}