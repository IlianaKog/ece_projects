clear all;
close all;

%g=      const  gmin    armijo
%gMethod== 1     2       3
%gInput==  g      w       s

%const
g = [0.2 0.25 0.3 0.35 0.4 0.45 0.47 0.5 0.55];
g = [0.47];
gMethod=1;
k = zeros(1,length(g));
xo=-1;
yo=1;
for i=1:length(g)
    gInput = g(i);
    [fvalues, X, k(i)] = SteepestDescent(xo,yo,gMethod,gInput);
    figure(1);
    plot(fvalues,'-o');
    hold on;
    title('g=const');
    xlabel('k');
    ylabel('f(xk)');

    fprintf('Min f: %.4f\n',fvalues(k(i)));
    fprintf('X: %.4f\n',X(1,k(i)));
    fprintf('Y: %.4f\n',X(2,k(i)));
end


%Optimized with Fibbonacci
gMethod=2;
xo= -1;
yo= +1;

gInput = 8; %den exei shmasia gia gMethod==2
[fvalues, X, k(i)] = SteepestDescent(xo,yo,gMethod,gInput);
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
xo=-1;
yo=1;
s = [2 4 5 5.5 6 6.5];
s=[5];

% xo= 1;
% yo= -1;
% s = [4 5 5.1 5.5 6 6.5];
% s = [5.1];

K = zeros(1,length(s));
for i=1:length(s)
    gInput = s(i);
    [fvalues, X, K(i)] = SteepestDescent(xo,yo,gMethod,gInput);
    figure(3);
    plot(fvalues,'-o');
    hold on;
    title('Armijo');
    xlabel('k');
    ylabel('f(xk)');

    fprintf('Min f: %.4f\n',fvalues(K(i)));
    fprintf('X: %.4f\n',X(1,K(i)));
    fprintf('Y: %.4f\n',X(2,K(i)));
end

