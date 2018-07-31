
clc;
clear;
close all;

[freq,power]=importfile('/Users/zhangxin/Documents/NCS/prague/tx_enable.txt', '\t');
N_despur=2;
N_smooth=5;
RBW = 500e3; 

for i=0:N_despur
    if i==0
        freq1=freq;
        power1=power;  
        figure(1), plot(freq1,power1); 
        hold on; grid on;
    else
        dnl_power=power1(2:end)-power1(1:end-1);
        mean_power=mean(dnl_power);
        std_power=std(dnl_power);
        ind=find(dnl_power>=mean_power+std_power | dnl_power<=mean_power-std_power);    
        if i==1
            freq_spur=freq1(ind);
            power_spur=power1(ind);
        end
        power1(ind)=[];
        freq1(ind)=[];
    end
end

power1_smooth=smooth(power1,N_smooth);
plot(freq1,power1);
plot(freq1,power1_smooth);
%semilogx(freq_spur,power_spur);
legend('org','despur','smooth');
% figure(3), plot(freq1,power1-power1_smooth);

power_density_V2_randm=10.^(power1_smooth/10)*1e-3*50;
power_integration_randm=trapz(freq1,power_density_V2_randm);
Vrms=sqrt(power_integration_randm);

dnl_freq_spur = [0;freq_spur(2:end)-freq_spur(1:end-1)];
mean_dnl_freq_spur = mean(dnl_freq_spur);
ind1=find(dnl_freq_spur>mean_dnl_freq_spur);

ind_max_spur_power=length(ind1)+1;
power_spur1=power_spur;
for i=1:length(ind1)+1
    if i<length(ind1)+1
        [ymax, ind2]=max(power_spur1(1:ind1(i)-1));
        ind_max_spur_power(i)=ind2;
        power_spur1(1:ind1(i)-1)=-inf;
    else
        [ymax,ind2]=max(power_spur1);
        ind_max_spur_power(i)=ind2;
    end       
end
power_spur_V2=10.^((power_spur(ind_max_spur_power)+10*log10(RBW))/10)*1e-3*50;
power_spur_V2_integration=sum(power_spur_V2);
Vrms_spur=sqrt(power_spur_V2_integration);


% figure(2), subplot(2,1,1), stem(freq_spur,dnl_freq_spur);
% hold on;
% subplot(2,1,2), stem(freq_spur(ind_max_spur_power),power_spur(ind_max_spur_power));
% legend('dnl_freq_spur','max_freq_spur')

figure(3); plot(freq,power);
hold on; grid on;
scatter(freq_spur(ind_max_spur_power),power_spur(ind_max_spur_power));
