% dft.m
%%%%%%%%%%%%%%%%%%%%%%
fs=1000;
Ts=1/fs;
N=12000;
t=(0:N-1)*Ts;
s=sin(2*t.*(t-3).*(t-6).*(t-9).*(t-12));
%%%%%%%%%%%%%%%%%%%%
%
% discrete Fourier transform 
%
%%%%%%%%%%%%%%%%%%%%
hat = fft(s); 
g = abs(hat);
k = (0:N-1)*(100/N);
plot(k,g);
title('Discrete Fourier transform');
xlabel('k = 0, 1, 2, ..., N-1');
xticks([0 50 100])
xticklabels({'0','500','1000'})
ylabel('|F(x)[k]|');
yticks([0 200 400]);

