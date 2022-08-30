%% fitdata.m 
% to load the raw statistics from the xlsx file
% to definite the initial variables.

data1 = xlsread("附件3-弹性模量与压力.xlsx");%读取原始数据
plot(data1(:,1),data1(:,2))               %原始数据可视化

% 采用3阶的polynomial对于模量-压力进行拟合
y=polyfit(data1(:,1),data1(:,2),3)
fit_data = polyval(y,0:0.1:200);
hold on;
plot(0:0.1:200,fit_data)                % 绘制拟合之后的数据

%% Integral_CALC.m 
% 通过二者的微分表达式，用于计算模量E和液体压强p之间确切的对应关系
syms x p;
H = 1/(([x^3,x^2,x^1,1]*y'));
H2 = vpa(simplify(int(H)),3);
Pressure = 0 :0.1 :200;
Pressure = Pressure';

Rhos = ones(length(Pressure),1) * 0.85;
for i = 1: length(Pressure)
    delta_rate = exp(int(H,100,Pressure(i)));
    Rhos(i) = delta_rate * Rhos(i);
    fprintf("%d\n",i);
end

plot(Pressure,Rhos);

%% 
load matlab