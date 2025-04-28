close all;
clear all;

x = -4:0.2:4;
y = x;
[X,Y] = meshgrid(x);
F = (X.^5).*exp(-X.^2-Y.^2);
surf(X,Y,F);

