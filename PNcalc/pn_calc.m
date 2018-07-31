
data_path='C:\Users\NCS01\NewCo\cancun\test_results\20150825\AVDD1p0_DVDD0p9_25C\';
%data_path='C:\Users\NCS01\NewCo\cancun\test_results\20150825\AVDD1p05_DVDD0p95_125C\';
%data_path='C:\Users\NCS01\NewCo\cancun\test_results\20150825\';

data_name=[
'mode00_AVDD1p0_DVDD0p9_25C.csv';
'mode01_AVDD1p0_DVDD0p9_25C.csv';
'mode02_AVDD1p0_DVDD0p9_25C.csv';
'mode03_AVDD1p0_DVDD0p9_25C.csv';
'mode04_AVDD1p0_DVDD0p9_25C.csv';
'mode07_AVDD1p0_DVDD0p9_25C.csv';
'mode08_AVDD1p0_DVDD0p9_25C.csv';
'mode09_AVDD1p0_DVDD0p9_25C.csv';
'mode0A_AVDD1p0_DVDD0p9_25C.csv';
'mode0B_AVDD1p0_DVDD0p9_25C.csv';
'mode0C_AVDD1p0_DVDD0p9_25C.csv';
'mode0D_AVDD1p0_DVDD0p9_25C.csv';
'mode0E_AVDD1p0_DVDD0p9_25C.csv';
'mode0F_AVDD1p0_DVDD0p9_25C.csv';
'mode10_AVDD1p0_DVDD0p9_25C.csv';
'mode11_AVDD1p0_DVDD0p9_25C.csv';
'mode12_AVDD1p0_DVDD0p9_25C.csv';
'mode13_AVDD1p0_DVDD0p9_25C.csv';
'mode14_AVDD1p0_DVDD0p9_25C.csv';
'mode15_AVDD1p0_DVDD0p9_25C.csv';
'mode16_AVDD1p0_DVDD0p9_25C.csv';];

%{
data_name=[
'mode00_AVDD1p05_DVDD0p95_125C.csv';
'mode01_AVDD1p05_DVDD0p95_125C.csv';
'mode02_AVDD1p05_DVDD0p95_125C.csv';
'mode03_AVDD1p05_DVDD0p95_125C.csv';
'mode04_AVDD1p05_DVDD0p95_125C.csv';
'mode07_AVDD1p05_DVDD0p95_125C.csv';
'mode08_AVDD1p05_DVDD0p95_125C.csv';
'mode09_AVDD1p05_DVDD0p95_125C.csv';
'mode0A_AVDD1p05_DVDD0p95_125C.csv';
'mode0B_AVDD1p05_DVDD0p95_125C.csv';
'mode0C_AVDD1p05_DVDD0p95_125C.csv';
'mode0D_AVDD1p05_DVDD0p95_125C.csv';
'mode0E_AVDD1p05_DVDD0p95_125C.csv';
'mode0F_AVDD1p05_DVDD0p95_125C.csv';
'mode10_AVDD1p05_DVDD0p95_125C.csv';
'mode11_AVDD1p05_DVDD0p95_125C.csv';
'mode12_AVDD1p05_DVDD0p95_125C.csv';
'mode13_AVDD1p05_DVDD0p95_125C.csv';
'mode14_AVDD1p05_DVDD0p95_125C.csv';
'mode15_AVDD1p05_DVDD0p95_125C.csv';
'mode16_AVDD1p05_DVDD0p95_125C.csv';];
%}

%{
data_name=[
'mode04_AVDD1p05_DVDD0p95_0C_no_rxclk.csv';];   
%}
fcarrier=1e6*[132.813,135,139.264,153.6,155.52,156.25,166.629,167.332,167.411,178.996,156.25,168.117,131.484,133.65,140.876,148.5,153.6,62.5,77.76,100,80]';
%fcarrier=155.52e6;
integ_start=50e3;
integ_stop=10e6;

[nrow,ncol]=size(data_name);
data_file=char(zeros(nrow,ncol+length(data_path)));
for i=1:nrow
    data_file(i,:)=strcat(data_path,data_name(i,:));   
end
[freq,~]=importfile(data_file(1,:), ','); 
freq=zeros(length(freq),nrow);
pnoise_ssb=zeros(length(freq),nrow);
for i=1:nrow
    [freq(:,i),pnoise_ssb(:,i)]=importfile(data_file(i,:), ',');    
end
figure(1)
rj=zeros(length(fcarrier),1);
rj_power=zeros(length(fcarrier),1);
pj=zeros(length(fcarrier),1);
pnoise_smooth=zeros(length(freq),nrow);
frange_start=zeros(ceil(log10(integ_stop/integ_start)),length(fcarrier));
frange_stop=frange_start;
rj_sep=frange_start;
rj_sep_power=frange_start;
spur_cell=cell(length(fcarrier),2);
for i=1:length(fcarrier)
    [pnoise_smooth(:,i),freq_spur,power_spur] = pn_separation(freq(:,i),pnoise_ssb(:,i));
    spur_cell{i,1}=freq_spur;
    spur_cell{i,2}=power_spur;
    [rj(i),rj_power(i)] = rj_calc(fcarrier(i),freq(:,i),pnoise_smooth(:,i),integ_start,integ_stop);
    pj(i) = pj_calc(fcarrier(i),freq_spur,power_spur,integ_start,integ_stop);
    [frange_start(:,i), frange_stop(:,i), rj_sep(:,i), rj_sep_power(:,i)]=rj_seperate(fcarrier(i),freq(:,i),pnoise_smooth(:,i),integ_start,integ_stop);
end
%semilogx(freq,pnoise_ssb); hold on; grid on;
semilogx(freq,pnoise_smooth); hold on; grid on;
[freq_sim, pn_sim]=importfile('D:\matlab_project\pn_maxIcp_sim.csv', ',');
semilogx(freq_sim, pn_sim,'--','color',rand(1,3));
legend(data_name(:,1:6),'location','southwest');
title('Phase Noise diagram'); xlabel('Offset Freq.(Hz)'); ylabel('Phase Noise(dBc/Hz)');

figure(2);
for i=1:length(fcarrier)
    semilogx(spur_cell{i,1},spur_cell{i,2},'--o','color',rand(1,3)); hold on; grid on;
end
legend(data_name(:,1:6),'location','southwest');
title('Spur Power diagram'); xlabel('Offset Freq.(Hz)'); ylabel('Spur Power(dBc)');

rj_power_dBc=10*log10(rj_power);
rj_sep_power_dBc=10*log10(rj_sep_power);
[~,ind]=sort(rj);
mode_name=data_name(:,1:6);
mode_name1=flipud(mode_name(ind,:));
rj1=flipud(rj(ind,:));
pj1=flipud(pj(ind,:));
rj1_power=flipud(rj_power(ind,:));
rj1_power_dBc=10*log10(rj1_power);
fcarrier1=flipud(fcarrier(ind,:));
ind_rj_max=ind(end);
ind_rj_min=ind(1);


fprintf('Integral range: %.1e to %.1e Hz\n\n',integ_start, integ_stop);
fprintf(' Max Rj Mode: %s\n Carrier Freq. = %.3e Hz\n Rj total = %.3e sec\n Pj total = %.3e sec\n Rj Power total = %.2g dBc\n\n',mode_name(ind_rj_max,1:6)', fcarrier(ind_rj_max), rj(ind_rj_max),  pj(ind_rj_max),rj_power_dBc(ind_rj_max));
fprintf(' Min Rj Mode: %s\n Carrier Freq. = %.3e Hz\n Rj total = %.3e sec\n Pj total = %.3e sec\n Rj Power total = %.2g dBc\n\n',mode_name(ind_rj_min,1:6)', fcarrier(ind_rj_min), rj(ind_rj_min),  pj(ind_rj_min),rj_power_dBc(ind_rj_min));

fprintf(' Mode    Carrier Freq.(Hz)   Rj(sec)     Pj(sec)   Rj Power(dBc)  Rj Power(rad^2)\n');
for i=1:length(rj)
    fprintf(' %s     %.5e    %.3e    %.3e    %.2g     %.3e\n',mode_name(i,1:6)', fcarrier(i), rj(i),  pj(i), rj_power_dBc(i), rj_power(i));
end

fprintf(' \nRj Seperate Integral Table\n');
fprintf(' Integral Freq. Range(Hz)\n');
for i=1:length(frange_start(:,1))
    fprintf('  %.3e to %.3e\n',frange_start(i,1),frange_stop(i,1));
end
fprintf(' Mode    Carrier Freq.(Hz)          Rj(sec)\n');
for i=1:length(rj_sep)
     fprintf(' %s     %.3e   ',mode_name(i,1:6)', fcarrier(i));
    for j=1:length(rj_sep(:,1))
        fprintf('  %.3e',rj_sep(j,i));
    end
    fprintf('\n');
end
fprintf('\n Mode    Carrier Freq.(Hz)   Power(dBc)\n');
for i=1:length(rj_sep)
     fprintf(' %s     %.3e    ',mode_name(i,1:6)', fcarrier(i));
    for j=1:length(rj_sep(:,1))
        fprintf('  %.2g',rj_sep_power_dBc(j,i));
    end
    fprintf('\n');
end
