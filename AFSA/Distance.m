function y = Distance(p,a)
    X = load("cities.txt");
    X = X - p;
    y = sum(sum(X.^2));
end