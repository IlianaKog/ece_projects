clear all;
close all;

%g=      const  gmin    armijo
%gMethod== 1     2       3
%gInput==  g     -       s

%const
g = [0.55 0.6 0.65 0.7 0.75 0.8 0.9 1];
g = [1];
gMethod=1;
k = zeros(1,length(g));
xo= -1;
yo= 1;
for i=1:length(g)
    gInput = g(i);
    [fvalues, X, k(i)] = LevenbergMarquardt(xo,yo,gMethod,gInput);
    figure(1);
    plot(fvalues,'-o');
    hold on;
    title('g=const');
    xlabel('k');
    ylabel('f(xk)');
    fprintf('g = const\n');
    fprintf('Min f: %.4f\n',fvalues(k(i)));
    fprintf('X: %.4f\n',X(1,k(i)));
    fprintf('Y: %.4f\n',X(2,k(i)));
end


%Optimized with Fibbonacci
gMethod=2;
xo= -1;
yo= +1;

gInput = 8; %den exei shmasia gia gMethod==2
[fvalues, X, k(i)] = LevenbergMarquardt(xo,yo,gMethod,gInput);
figure(2);
plot(fvalues,'-o');
hold on;
title('gmin');
xlabel('k');
ylabel('f(xk)');
fprintf('g = min\n');
fprintf('Min f: %.4f\n',fvalues(k(i)));
fprintf('X: %.4f\n',X(1,k(i)));
fprintf('Y: %.4f\n',X(2,k(i)));



%ARMIJO
gMethod=3;

xo= -1;
yo= 1;
%s = [4 4.5 5 5.5 6 6.5 7];
s=[4];

% xo= 1;
% yo= -1;
% %s = [4 4.5 5 5.5 6 6.5];
% s = [5];

K = zeros(1,length(s));
for i=1:length(s)
    gInput = s(i);
    [fvalues, X, K(i)] = LevenbergMarquardt(xo,yo,gMethod,gInput);
    figure(3);
    plot(fvalues,'-o');
    hold on;
    title('Armijo');
    xlabel('k');
    ylabel('f(xk)');
    fprintf('Armijo\n');
    fprintf('Min f: %.4f\n',fvalues(K(i)));
    fprintf('X: %.4f\n',X(1,K(i)));
    fprintf('Y: %.4f\n',X(2,K(i)));
end

