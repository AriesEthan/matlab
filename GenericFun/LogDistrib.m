function freq = LogDistrib(fstart, fstop, NumPerDec)
% return column array.
N=NumPerDec*log10(fstop/fstart);
freq=10.^(log10(fstart)+(0:1:N)'/NumPerDec);
end