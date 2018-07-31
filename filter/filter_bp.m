%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Z-function
%           1-a
%  H(z)=  -------
%         1-az^-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;

%///////////////pole calc.///////////////%
%////////////////////////////////////////%
fs=8.2e3;  % samplling frequency
fc1=5;   % low pass cutoff frequency Hz
fc2=0.3; % high pass cutoff frequency Hz

wc1=2*pi*fc1/fs;
wc2=2*pi*fc2/fs;
a1=roots([1 -(4-2*cos(wc1)) 1])
a2=roots([1 -(4-2*cos(wc2)) 1])

a1_temp=a1(a1<1 & a1>-1);    a2_temp=a2(a2<1 & a2>-1);
b1_temp=log2(1/(1-a1_temp)), b2_temp=log2(1/(1-a2_temp))

b1_round=round(b1_temp); b2_round=round(b2_temp);
b1=1/2^b1_round; b2=1/2^b2_round;
a1=1-b1;         a2=1-b2;

%///////////////bandpass filter ///////////////%
%//////////////////////////////////////////////%
lowpass_stage=5
gain_lowpass=(sqrt(2))^lowpass_stage;
H_gain_lp=dfilt.df1(gain_lowpass,[1,0]);
H_lp_stage1=dfilt.df1(b1, [1, -a1])

H_lp=dfilt.cascade(H_gain_lp,H_lp_stage1);
for i=1:1:lowpass_stage
    addstage(H_lp,H_lp_stage1);   
end


highpass_stage=20
H_ap=dfilt.df1(1,[1,0]);
H_lp_stage2=dfilt.df1(-b2, [1, -a2])
H_hp_stage=dfilt.parallel(H_ap,H_lp_stage2);

H_hp=dfilt.cascade(H_ap,H_hp_stage);
for i=1:1:highpass_stage
    addstage(H_hp,H_hp_stage);   
end

Hbp=dfilt.cascade(H_lp,H_hp);
w=(2.5e-5:2.5e-6:2.5e-2)*pi;

%freqz(H_lp)
h1=freqz(H_hp_stage,w);
h2=freqz(H_hp,w);
hbp=freqz(Hbp,w);
%plot(w/pi,20*log10(abs(h1)),'b',w/pi,20*log10(abs(h2)),'r');
%semilogx(w/pi/2*fs,20*log10(abs(h1)),'b',w/pi/2*fs,20*log10(abs(h2)),'r');
semilogx(w/pi/2*fs,20*log10(abs(hbp)));
ylim([-60,20]);
%legend('H_hp_stage','H_hp');
grid on; hold on;
xlabel('Hz');
ylabel('dB');