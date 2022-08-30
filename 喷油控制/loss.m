%% function loss
% 通过向function update 之中上传in_Period（进油阀门开启时间），并选择loss 模式
% startime : 表示计入模拟的时间
% endtime ： 结束模拟的时间
% step : 差分模拟的步长
% loss ： 选择1范数or2范数

function y=loss(startime,endtime,step,in_Period,options)
    y = 0;
    global t p pex;
    reseting();% 对于几个局部变量进行重置
    if options ==1
        temp_loss = @abs;
    else
        temp_loss = @norm;
    end
    if startime ~=0
        if mod(startime,step)~=0
            startime = idivide(startime,step,'ceil') * step;
        end
        for i = 1:startime/step
            update(step,in_Period);
        end   
    end
    for i = 1:(endtime - startime)/step
        update(step,in_Period);
        y = y + temp_loss(p-pex);
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
C = 0.85;
p_out = 160;
t = 0;
pex = 150;
end