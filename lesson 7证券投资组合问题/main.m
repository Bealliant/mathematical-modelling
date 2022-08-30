X = [1.300	1.225	1.149;
1.103	1.290	1.260;
1.216	1.216	1.419;
0.954	0.728	0.922;
0.929	1.144	1.169;
1.056	1.107	0.965;
1.038	1.321	1.133;
1.089	1.305	1.732;
1.090	1.195	1.021;
1.083	1.390	1.131;
1.035	0.928	1.006;
1.176	1.715	1.908;
];

[m,n]=size(X);
R = [];


RE = mean(X,1);
sigma = cov(X);
solv = [];

for k = 0:0.01:1
    H = 2*k * sigma;
    f = (k-1)*RE'; 
    A = (0.01+1)*ones(1,3);
    b = [1];
    temp = quadprog(H,f,A,b,[],[],[0;0;0],inf);
    solv = [solv;temp'];
    
end

risk = [];
yield = [];
for i = 1:100
   yield = [yield;fun1(solv(i,:))];
   risk = [risk;fun2(solv(i,:))];
end
plot(risk,yield);
title("收益随风险变化曲线")
