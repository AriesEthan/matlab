%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TF of 2nd-Type 2nd-Order ChargePump PLL                          %
% 2nd-Order prop-Integrator filter                                 %
%    CP-------------VCO           ---Icp/2pi--F(s)--Kv--           %
%        |                        |                   |           %
%        R1                       |--------1/N--------|           %
%        |                                                        %
%        C1                                                       %
%        |                                                        %
%       GND                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc; clearvars;
fref_num=200e6;
freq_rad_norm=(linspace(1e-2,0.5,100))'*2*pi;
freq=freq_rad_norm/2/pi*fref_num;

syms Kp Ki z
Fs=(1+Ki/Kp*1/(z-1))*1/(z-1);
Gs=Fs;

fprintf('Proportional-Integrational Filter TF:\n');
pretty(simplifyFraction(Fs)); %fprintf('\n');
fprintf('Open Loop TF G(s):\n');
pretty(simplifyFraction(Gs)); %fprintf('\n');
fprintf('Open Loop Gain K:\n');

sigma_num=4e-12;           % sec
Kp_num=0.75;               % 
Ki_num=2^-8;               % 
f0=500e6;                  % VCO free running freq.Hz
fref_num=200e6;            % Hz
Kv_num=20e6;               % VCO gain£¬Hz/LSB
N_num=20;           

Gs=subs(Gs, [Kp, Ki], [Kp_num, Ki_num]);

for i=1:length(freq_rad_norm)
    Gs_jw(i,1)=subs(Gs, z, exp(1j*freq_rad_norm(i)));
    Gs_mag_dB(i,1)=20*log10(abs(Gs_jw(i,1)));
    Gs_ang_deg(i,1)=angle(Gs_jw(i,1))/pi*180;
end
Gs_mag_dB=double(Gs_mag_dB);
Gs_ang_deg=double(Gs_ang_deg);
fprintf('Unity Gain Freq.: %1.2g Hz\n', freq(find(Gs_mag_dB>=0, 1, 'last' )));
PM=Gs_ang_deg(find(Gs_mag_dB>=0, 1, 'last' ))-(-180);
fprintf('Phase Margin(deg): %1.1f\n C',PM);

figure(1);
subplot(2,1,1),semilogx(freq,Gs_mag_dB); grid on; title('Frequency Response of Magnitude G(s)');
subplot(2,1,2),semilogx(freq,Gs_ang_deg); grid on; title('Frequency Response of Phase G(s)');

