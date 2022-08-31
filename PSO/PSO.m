% PSO,Particle Swarm Optimization

lb = [-10, -10]; % lower bound;
ub = [10, 10];  % upper bound;

num_particle = 100; % the number of the particles;
max_epoch = 100; % Maxium time of Iteration;
num_variab = length(lb);% 变量是几维的vector需要预先说明
c1 = 1.4945; % learning factor 1;
c2 = 2;     % learning factor 2;
w_max = 0.9;
w_min = 0.4;

all_pos = rand(num_particle,num_variab);% 用于存储所有粒子的position;
all_v =  zeros(num_particle,num_variab);% 用于存储每个粒子的velocity;
for i = 1:length(lb)
    all_pos(:,i) = all_pos(:,i) .* (ub(i)-lb(i)) + lb(i); % 随机初始化
end

Pbest = all_pos; % Best Coordinates for each Particle;
PB = fun(all_pos);% Personal Best Score
maxium = max(PB);
Gbest = zeros(1,2);

for epoch = 1: max_epoch
    temp_score = fun(all_pos);
    
    for j = 1:length(num_particle)
        if temp_score(j)> PB(j)
           Pbest(j,:) = all_pos(j,:); 
        end
    end
    PB = max(temp_score,PB);% PB sync;
    [epoch_best,inde] = max(temp_score);
    if epoch_best > maxium
        maxium = epoch_best;
        Gbest = all_pos(inde,:);
    end
    w = w_min + (w_max-w_min)/max_epoch * i;
   all_v = all_v .* w + c1.*rand(num_particle,1).*(Pbest - all_pos) + c2.*rand(num_particle,1).*(Gbest-all_pos);
   all_pos = all_pos + all_v;
   
   for j = 1: length(lb)
       all_pos(:,j)= max(all_pos(:,j),lb(j));
       all_pos(:,j) = min(ub(j),all_pos(:,j));
   end
end


