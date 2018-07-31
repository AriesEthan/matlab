clc; clear all;

f=(@(x)1/sqrt(2*pi)*exp((-x.^2)/2));

a=linspace(5,12,100); 
a=a';
q=zeros(length(a),1);
for i=1:length(a)
    q(i)=quadgk(f,a(i),inf);
end
semilogy(a,q); grid on;




