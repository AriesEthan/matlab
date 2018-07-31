%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Z-function
%           1-a
%  H(z)=  -------
%         1-az^-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clearvars all;

fs=1/6e-9;  % samplling frequency

fcl=1e6;   % low pass cutoff frequency Hz
fch=0.3; % high pass cutoff frequency Hz

wcl=2*pi*fcl/fs;
wch=2*pi*fch/fs;
al=roots([1 -(4-2*cos(wcl)) 1]);
ah=roots([1 -(4-2*cos(wch)) 1]);

al_temp=al(al<1&al>-1);
ah_temp=-1*ah(ah<1 & ah>-1);
ah_temp1=ah(ah<1 & ah>-1);
num_l=[1-al_temp];
num_h=[1-ah_temp];
num_h1=[1-ah_temp1];
num_h2=[ah_temp1 -1*ah_temp1];
den_l=[1 -1*al_temp];
den_h=[1 -1*ah_temp];
den_h1=[1 -1*ah_temp1];
den_h2=[1 -1*ah_temp1];
hd_l=dfilt.df1(num_l,den_l);
hd_h=dfilt.df1(num_h,den_h);
hd_h1=dfilt.df1(num_h1,den_h1);
hd_h2=dfilt.df1(num_h2,den_h2);
freqz(hd_l)
freqz(hd_h)
freqz(hd_h1,16384)
freqz(hd_h2,16384)
norm_wcl=wcl/pi
norm_wch=wch/pi

