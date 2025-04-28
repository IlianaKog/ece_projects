function[a,b,counter_n,x_star] = Fibonacci(epsilon,lamda,f)
    %lamda = 10^-3;
    %epsilon = 0.001;
    
    a1=-1;
    b1=3;
    counter_n = 1;

    i = 0;
    while fibonacci(i)<=(b1-a1)/lamda
         i = i+1;
    end
    n = i;

     %syms x
     %f(x) = (x-2)^2 + x*log(x+3);
%     f(x) = 5^x + (2-cos(x))^2;
%     f(x) = exp(x)*(x^3-1) + (x-1)*sin(x);

    a = zeros(1,n);
    b = zeros(1,n);
    x1 = zeros(1,n);
    x2 = zeros(1,n);
    x_star = zeros(1,2);

    k=1;
    a(1) = a1;
    b(1) = b1;
    x1(1) = a(1,1) + (fibonacci(n-2)/fibonacci(n))*(b1-a1);
    x2(1) = a(1,1) + (fibonacci(n-1)/fibonacci(n))*(b1-a1);
    
    while 1
        if(f(x1(k)) > f(x2(k)))
            a(k+1) = x1(k);
            b(k+1) = b(k);
            x1(k+1) = x2(k);
            x2(k+1) = a(k+1) + ((fibonacci(n-k-1)/fibonacci(n-k))*(b(k+1)-a(k+1)));
            if k == n-2
                x1(n) = x1(n-1);
                x2(n) = x1(n-1) + epsilon;
                if f(x1(n)) > f(x2(n))
                    counter_n = counter_n+1;
                    a(n) = x1(n);
                    b(n) = b(n-1);
                    x_star(1,:) = [a(n) b(n)];
                    break
                else
                    counter_n = counter_n+1;
                    a(n) = a(n-1);
                    b(n) = x2(n);
                    x_star(1,:) = [a(n) b(n)];
                    break
                end
            else
                counter_n = counter_n+1;
                k = k+1;
            end   
        else
            a(k+1) = a(k);
            b(k+1) = x2(k);
            x2(k+1) = x1(k);
            x1(k+1) = a(k+1) + ((fibonacci(n-k-2)/fibonacci(n-k))*(b(k+1)-a(k+1)));
            if k == n-2
                x1(n) = x1(n-1);
                x2(n) = x1(n-1) + epsilon;
                if f(x1(n)) > f(x2(n))
                    counter_n = counter_n+1;
                    a(n) = x1(n);
                    b(n) = b(n-1);
                    x_star(1,:) = [a(1,n) b(1,n)];
                    break
                else
                    counter_n = counter_n +1;
                    a(n) = a(n-1);
                    b(n) = x2(n);
                    x_star(1,:) = [a(n) b(n)];
                    break
                end
            else
                counter_n = counter_n+1;
                k = k+1;
            end
         end
    end
end


