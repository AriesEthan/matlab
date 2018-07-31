%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Z-function
%            b
%  H(z)=  -------
%         1-az^-1
%  b=1-a 
%
% if fc<<fs/2
%    a=1-2pifc/fs, 
%
% if fc->fs/2
%    a=e^(-2pifc/fs), 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars; clc;

%///////////////pole calc.///////////////%
fs=75e6;      % samplling frequency
fc=25e6;     % low pass cutoff frequency Hz
bw=8;        % coefficient bandwidth   
qpath = quantizer('fixed','round','saturate',[bw+2,bw]);
wc=2*pi*fc/fs;
a_float=exp(-2*pi*fc/fs); a_float1=1-2*pi*fc/fs;
a_temp=a_float(a_float<1 & a_float>-1);    
a_fix=quantize(qpath, a_float);
b=1-a_fix;

%///////////////bandpass filter ///////////////%
%//////////////////////////////////////////////%
lowpass_stage=2;
gain_lowpass=1;
H_gain_lp=dfilt.df1(gain_lowpass,[1,0]);
H_lp_stage1=dfilt.df1(b, [1, -a_fix])
H_lp=dfilt.cascade(H_gain_lp,H_lp_stage1);
if(lowpass_stage>1)    
    for i=1:1:lowpass_stage-1
        addstage(H_lp,H_lp_stage1);   
    end
end

w=(2.5e-4:2.5e-3:1.5)*pi;
hlp=freqz(H_lp,w);
%plot(w/pi,20*log10(abs(h1)),'b',w/pi,20*log10(abs(h2)),'r');
%semilogx(w/pi/2*fs,20*log10(abs(h1)),'b',w/pi/2*fs,20*log10(abs(h2)),'r');
semilogx(w/(2*pi)*fs,20*log10(abs(hlp)));

A=[w/pi/2*fs;20*log10(abs(hlp))]';
ylim([-60,20]);
%legend('H_hp_stage','H_hp');
grid on; hold on;
xlabel('Hz');
ylabel('dB');