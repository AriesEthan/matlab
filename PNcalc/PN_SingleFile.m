clc;
clear;
close all;

fcarrier=input('Please input carrier freq.(Hz): ');
%fcarrier=155.534e6;
fprintf('\n');
%pnoise_file=input('Please input phase noise csv file name:\n','s');
%fprintf('\n');

data_path='C:\Users\NCS01\NewCo\cancun\test_results\20160309\';
data_name='mode04_100ppm.csv';
%data_path='/Users/zhangxin/Desktop/pn_20150909/125C/0p85V/';
%data_name='mode05_AVDD0p85_DVDD0p85_125C.csv';
pnoise_file=strcat(data_path,data_name);

integ_fstart=50e3;  % integral start freq.(Hz)
integ_fstop=10e6;   % integral stop freq.(Hz)

despur=2;
Factor_smooth=0.08;
smooth_method='rlowess';

A=importfile(pnoise_file, ',','%f%f'); fprintf('Read Phase noise file: %s\n',pnoise_file); 
freq=A(:,1); pnoise_ssb=A(:,2);
fprintf('carrier freq. = %0.5e Hz\n\n',fcarrier);
fprintf('smooth factor = %0.2f\n',Factor_smooth);
pnoise_smoothed=smooth(pnoise_ssb,Factor_smooth,smooth_method);

figure(1),semilogx(freq,pnoise_ssb);
grid on, hold on, title('Phase Noise Diagram')
semilogx(freq,pnoise_smoothed); 

% Rj allrange calculation
pnoise_rad2_allrange=10.^(pnoise_smoothed/10);
pnoise_integ_allrange=trapz(freq,pnoise_rad2_allrange);
rjrms_allrange=sqrt(2*pnoise_integ_allrange)/(2*pi*fcarrier);
fprintf('Rj total: %.3e sec\n', rjrms_allrange); 

% Rj subrange calculation
ind=find(freq>=integ_fstart);
ind_fstart=ind(1);
ind=find(freq<=integ_fstop);
if ind(end)+1>length(freq)
    ind_fstop=length(freq);
else
    ind_fstop=ind(end)+1;
end
%fprintf('Integration boundary: %e Hz - %e Hz\n', freq(ind_fstart),freq(ind_fstop));

pnoise_subrange=pnoise_smoothed(ind_fstart:ind_fstop);
freq_rj_subrange=freq(ind_fstart:ind_fstop);
pnoise_rad2_subrange=10.^(pnoise_subrange/10);
pnoise_integ_subrange=trapz(freq_rj_subrange,pnoise_rad2_subrange);
rjrms_subrange=sqrt(2*pnoise_integ_subrange)/(2*pi*fcarrier);
fprintf('Rj %.2e Hz to %.2e Hz: %.3e sec\n\n', freq(ind_fstart),freq(ind_fstop),rjrms_subrange);

%spur seperation & Pj calculation
fprintf('spur speration threshold: %g dB\n',despur);
pnoise_delta=pnoise_ssb-pnoise_smoothed;
pnoise_delta(pnoise_delta<despur)=-inf;
pnoise_delta_diff=diff(pnoise_delta);

ind=zeros(length(pnoise_delta_diff)-1,1);
for i=1:length(pnoise_delta_diff)-1
    if(pnoise_delta_diff(i)>0 && pnoise_delta_diff(i+1)<0)
        [Value,ind_temp]=max(pnoise_ssb(i-1:i+1));
        ind(i)=i+ind_temp-2;
    end
end   
ind_spur=ind; % for spur duplicated check
ind=ind(ind>0);
freq_spur=freq(ind);   
pnoise_spur=pnoise_ssb(ind);
A=[freq_spur,pnoise_spur];
B=sortrows(A,1);
freq_spur=B(:,1);
pnoise_spur=B(:,2);
scatter(freq_spur,pnoise_spur); hold on;%legend('PN\_orginal','PN\_smoothed','Spur','location','southwest');

span = 2*freq_spur;
RBW=zeros(length(span),1);
for i=1:length(span)    
	if span(i)<=20
	    RBW(i)=2;
    elseif span(i)>20 && span(i)<=40
	    RBW(i)=5;
    elseif span(i)>40 && span(i)<=100
	    RBW(i)=10;
    elseif span(i)>100 && span(i)<=200
        RBW(i)=20;
    elseif span(i)>200 && span(i)<=400
	    RBW(i)=50;
	elseif span(i)>400 && span(i)<=1e3
	    RBW(i)=100;
	elseif span(i)>1e3 && span(i)<=10e3
	    RBW(i) = 200;
	elseif span(i)>10e3 && span(i)<=100e3
	    RBW(i) = 500;            
	elseif span(i)>100e3 && span(i)<=1e6
	    RBW(i) = 3e3;     
	elseif span(i)>1e6 && span(i)<=10e6
	    RBW(i) = 30e3;
	elseif span(i)>10e6 && span(i)<=100e6
	    RBW(i) = 300e3;
    else
	    RBW(i) =3e6;
end
end


% check if there is duplicated freq_spur
if(~isempty(freq_spur(freq_spur(1:end-1)==freq_spur(2:end))))
    freq_duplicated=freq_spur(freq_spur(1:end-1)==freq_spur(2:end));
    ind_duplicated=zeros(length(freq_duplicated),1); 
    for i=1:length(freq_duplicated)
        ind_duplicated(i)=find(freq==freq_duplicated(i));
    end
    for i=1:length(ind_duplicated)
        freq_duplicated=freq(ind_spur==ind_duplicated(i));
        ind=find(freq_spur==freq(ind_duplicated(i)));
        RBW_duplicated=RBW(ind(1,1));
        if(2*(freq_duplicated(2)-freq_duplicated(1))<RBW_duplicated)
            freq_spur(ind(2))=0;
            pnoise_spur(ind(2))=0;
            RBW(ind(2))=0;       
        end
    end
    freq_spur=freq_spur(freq_spur~=0);
    pnoise_spur=pnoise_spur(pnoise_spur~=0);
    RBW=RBW(RBW~=0); 
end   
scatter(freq_spur,pnoise_spur); legend('PN\_orginal','PN\_smoothed','Spur\_orginal','Spur','location','southwest');
power_spur=pnoise_spur+10*log10(RBW);
power_spur_rad2_pp=10.^(power_spur/10)*8;
pj_total=sqrt(2*sum(power_spur_rad2_pp))/(2*pi*fcarrier);
fprintf('Pj_total: %.3e sec\n', pj_total);

ind=find(freq_spur>=integ_fstart);
ind_fstart=ind(1);
ind=find(freq_spur<=integ_fstop);
ind_fstop=ind(end);
pj_subrange=sqrt(2*sum(power_spur_rad2_pp(ind_fstart:ind_fstop)))/(2*pi*fcarrier);
fprintf('Pj %0.1eHz to %0.1eHz: %.3e sec\n', integ_fstart,integ_fstop,pj_subrange);

pj_single_tone=sqrt(2*power_spur_rad2_pp)/(2*pi*fcarrier);
power_contribute=power_spur_rad2_pp./sum(power_spur_rad2_pp);

A1=[freq_spur,power_spur,pj_single_tone,power_contribute];
B1=sortrows(A1,4);
B1_ud=flipud(B1);
disp('Spur Freq.(Hz) Spur Power(dBc)   Pj(sec)    Power Contribute');
fprintf('  %0.2e         %0.2g\t        %0.2e\t %.2g\n', (B1_ud(1:5,:,:,:))');