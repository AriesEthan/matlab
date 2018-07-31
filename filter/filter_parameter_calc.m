%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Z-function
%           1-a
%  H(z)=  -------
%         1-az^-1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all; clear all; clc;

fs=500;  % samplling frequency

fcl=10;   % low pass cutoff frequency Hz
fch=0.3;  % high pass cutoff frequency Hz

wcl=2*pi*fcl/fs;
wch=2*pi*fch/fs;
al=roots([1 -(4-2*cos(wcl)) 1])
ah=roots([1 -(4-2*cos(wch)) 1])

al_temp=al(al<1&al>-1);
ah_temp=ah(ah<1 & ah>-1);

al_temp=log2(1/(1-al_temp))
ah_temp=log2(1/(1-ah_temp))
