function[k, fvalues, X] = SteepestDescent(xo,yo,gama)
    epsilon = 0.001;

%     xo=5;
%     yo=-5;

    syms x y G
    f(x,y) = (1/3)*x^2 + 3*y^2;
    gradF(x,y) = gradient(f,[x y]);

    X=zeros(2,100);
    d = zeros(2,100);
    g= zeros(100,1);

    X(1,1) = xo;
    X(2,1) = yo;

    k=1;
    f_star = 0;
    x_star = 0;
    y_star = 0;

    while(1)
        if abs(gradF(X(1,k),X(2,k))) <= epsilon
            x_star = X(1,k);
            y_star = X(2,k);
            f_star = double(f(x_star,y_star));
            break;
        end

        d(:,k) = -gradF(X(1,k),X(2,k));
        g(k) = gama;

        X(:,k+1) = X(:,k) + g(k)*d(:,k);
        k = k+1;
    end
    X = X(:,1:k);
    fvalues = double(f(X(1,1:k),X(2,1:k)));
    close all;
    figure(1);
    plot(fvalues,'-o');
    hold on;
    xlabel('k');
    ylabel('f(xk)');

    fprintf('Min f: %.4f\n',f_star);
    fprintf('X: %.4f\n',x_star);
    fprintf('Y: %.4f\n',y_star);

end