function y = fun(x)
%{
    x -> input array containing two elements
    原函数：y = x(1).^2 + x(2).^2 - 10.*cos(2*pi*x(1))-10.*cos(2*pi*x(2))+20;
    对于其进行向量化的优化
%}
   y = x(:,1).^2 + x(:,2).^2 - 10.*cos(2.*pi.*x(:,1)) - 10.*cos(2.*pi.*x(:,2))+20;
end
