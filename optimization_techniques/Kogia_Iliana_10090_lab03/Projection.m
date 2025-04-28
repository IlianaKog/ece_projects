function[x]=Projection(x,a,b)
    if x <= a
        x = a;
    end
    if x>= b
        x = b;
    end
end