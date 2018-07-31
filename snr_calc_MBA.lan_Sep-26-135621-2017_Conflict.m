clc; clearvars;

nharm=60;
nfft=512;
fs=200e6;
fres=fs/nfft;
win='hanning';
switch win
    case 'hanning'
        sideband=1;
    case 'rect'
        sideband=0;
    otherwise
        sideband=0;
end
        
data_path='/Users/zhangxin/Desktop/NCS_cloud/private/matlab_project/SourceData/';
data_name='fft_bin7.csv';
data_file=strcat(data_path,data_name); 
A=csvread(data_file,1);
%pick up baseband 
f1=A(1:nfft/2+1,1);
v1=A(1:nfft/2+1,2);
%de-DC
v1(1:1+sideband)=-inf;   
v1(end-sideband:end)=-inf;
f1(1:1+sideband)=-inf;   
f1(end-sideband:end)=-inf;
%correct bin number
v1=v1(2:end);
f1=f1(2:end);
%find signal power & freq
ipsig=find(v1==max(v1));
psig=v1(ipsig-sideband:ipsig+sideband);
fsig=f1(ipsig-sideband:ipsig+sideband);
psig_tot=10*log10(trapz(fsig,10.^((psig-10*log10(fres))/10)));
%de-harms
f1_noharms=f1;
v1_noharms=v1;
fharms=(1:1:nharm)'*fsig(2);
fharms_bb=mod(fharms,fs);
iharms=zeros(length(fharms_bb),1);
for i=1:length(fharms_bb)
    if(fharms_bb(i)>fs/2)
        fharms_bb(i)=fs-fharms_bb(i);
    end
    iharms(i,1)=find(f1==fharms_bb(i));
    v1_noharms(iharms(i)-sideband:iharms(i)+sideband)=-inf;
    f1_noharms(iharms(i)-sideband:iharms(i)+sideband)=-inf;
end
v1_noharms(v1_noharms==-inf)=[];
f1_noharms(f1_noharms==-inf)=[];
%²¹×ãDC
f1_noharms=[fres; 
            f1_noharms;
            fs/2];
v1_noharms=[v1_noharms(1);
            v1_noharms;
            v1_noharms(end)];
v1_noharms_dbbin=v1_noharms;
v1_noharms=10.^((v1_noharms-10*log10(fres))/10);
v1_tot=10*log10(trapz(f1_noharms,v1_noharms));

snr=psig_tot-v1_tot;
enob=(snr-1.57)/6.02;

fprintf('SNR=%.4g dB, ENOB=%.4g bits\n',snr,enob);


    
       


