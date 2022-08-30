%% Plotting_Whole
% 绘制整体函数大概的变化趋势
endtime = 20000;
startime = 0;
step = 2;
options = 2;

point = 0.70;
range = 3e-1;
interval = 1e-1;

global pex;% p_expected;
pex = 150;
p_All = simulation(15000,10000,0.5,0.72);


% %% searching
% % 三轮寻找最小值
% for i = 1: 5
%     A = point-range : interval : point + range;
%     fun = @(x)loss(startime,endtime,step,x,options);
%     funcA = arrayfun(fun,A);
%     [~,index] = min(funcA);
%     fprintf("第%d轮得到结果：%f",i,A(index));
%     point = A(index);
%     range = range/10;
%     interval = interval/10;
% end


%% function simulation
% 用于仿真不同时刻的p值
function outp = simulation(endtime,change_time,step,in_Period)
    global p;
    outp = zeros(length(0:step:endtime),1);
    reseting();
    for i = 1: (change_time)/step
       update(step,in_Period); 
       outp(i) = p;
    end
    for i = change_time/step + 1: (endtime)/step
       update(step,0.77);
       outp(i) = p;
    end
end
%% function reset
% 用于重置全局变量p m 和rho
function []=reseting()

%{
 ---------**变量解释**-------------
        V 油管的体积大小mm^3
        s_in 进油口（A端）的面积大小 mm^2
        s_out 出油口（B端）的面积大小 mm^2
        m 当前时刻油管之中的质量大小 mg
        m0 初始时刻的油管之中的质量大小 mg
        L 油管的长度   mm
        rho0： 初始的石油密度 mg mm^-3 
        p0 : 100 Mpa 
        p ： 当前时刻的油管内阀门压力（MPa)
        t : 模拟运行的时间节点

%}
global rho m m0 p0 rho0 p s_in C p_out t pex V;
L = 500;
s_in = (1.4/2)^2 * pi;
d = 10;
p0 = 100;
rho0 = 0.85;

V = (d/2)^2 *pi * L;
m0 = (d/2)^2 * pi * L * rho0;
rho = rho0;
p = p0;
m = m0;
C = 0.8;
p_out = 160;
t = 0;
end