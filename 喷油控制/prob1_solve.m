%% Plotting_Whole
% 绘制整体函数大概的变化趋势
endtime = 9000;
startime = 0;
step = 0.2;
options = 2;

point = 0.2910;
range = 5e-5;
interval = 5e-6;

%% searching
% 三轮寻找最小值
for i = 1: 3
    A = point-range : interval : point + range;
    fun = @(x)prob1(startime,endtime,step,x,options);
    funcA = arrayfun(fun,A);
    [~,index] = min(funcA);
    fprintf("第%d轮得到结果：%f",i,A(index));
    point = A(index);
    range = range/10;
    interval = interval/10;
end
%% function simulation
% 用于仿真不同时刻的p值
function y = simulation(endtime,step,in_Period)
    global p;
    reseting();
    for i = 1: (endtime)/step
       update(step,in_Period); 
    end
    y = p;
end
