%% searching
% 三轮寻找最小值
for i = 1: 3
    A = point-range : interval : point + range;
    fun = @(x)loss(startime,endtime,step,x,options);
    funcA = arrayfun(fun,A);
    [~,index] = min(funcA);
    fprintf("第%d轮得到结果：%f",i,A(index));
    point = A(index);
    range = range/10;
    interval = interval/10;
end
