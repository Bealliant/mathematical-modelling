%% AFSA Algorithm
% The AFSA algorithm uses hundreds of fish individuals to find the
% maxium point of "Food Density".

clc;clear;close all;
% Overall Parameter Settings.
lb = -10; % lower bound;
ub = 10;  % upper bound;
pdim = 2;  % The num of Variables;
max_epoch = 200; % maxium number of iteration.

% Fish Individual Parameter Settings.
global fish_vision fish_step crowd_toler fish_num;
fish_num = 500; % The number of fish individuals.
fish_vision = (ub-lb)/100;
fish_step = fish_vision /10;
crowd_toler = fish_num /50;
try_num = 5;

fish_loca = rand(fish_num,pdim).*(ub-lb) + lb;
[maxval,maxpos,max_index]=BroadCast(fish_loca);

for i = 1: max_epoch 
    fitness=zeros(fish_num,3);
    postition = cell(3,1);
    dist_matrix = Dist_CALC(fish_loca);
    boolean_matrix =  boolean_transform(dist_matrix);
    [position{1},fitness(:,1)] = Swarm(fish_loca,boolean_matrix);
    [position{2},fitness(:,2)] = Pray(fish_loca,try_num,pdim);
    [position{3},fitness(:,3)] = Follow(fish_loca,dist_matrix,max_index);
    [max_fitness,pos_choice] = max(fitness,[],2);
    for j = 1: fish_num
       fish_loca(j,:) = position{pos_choice(j)}(j,:);
    end
    [maxval,maxpos,max_index]=BroadCast(fish_loca);
    fish_loca = normalization(fish_loca,lb,ub,pdim);
end
disp("寻优最大值是：")
disp(maxval)
disp("最大位置是：")
disp(maxpos)
%%
function y = Dist_CALC(f_loca)
    global fish_vision fish_num;
    y = zeros(fish_num,fish_num);
    for i = 1: fish_num
        temp_dist = sum((f_loca-f_loca(i,:)).^2,2);
        y(i,:)= sqrt(temp_dist');
    end
end

%% 
function [y,fitness] = Swarm(f_loca,A)
    % A： the matrix undergone boolean transform
    global fish_vision fish_num crowd_toler fish_step;
    y = f_loca;
    nearby_index = find(sum((A),2)>0); 
    % The Index of which starting fish(row) has nearby fishes.
    for i = 1 : length(nearby_index)
        temp_row = nearby_index(i); % 判断每一个能够满足邻域内有其他鱼的row
        temp_nearby = find(A(temp_row,:)==1); % 筛选出这个row之内邻域内的鱼的索引
        temp_aim = mean(f_loca(temp_nearby,:)); % 目标的方向
        dire = (temp_aim - f_loca(temp_row));
        
        if length(temp_nearby)<crowd_toler
            y(temp_row,:) = y(temp_row,:) + dire ./norm(dire) * fish_step;
        end
    end
    fitness = Y(y);
end

%% 
function y = Y(x)
     % m by n matrix fitness score.
     y = x(:,1).^2 + x(:,2).^2 - 10.*cos(2.*pi.*x(:,1)) - 10.*cos(2.*pi.*x(:,2))+20;
end

%% 
function [ypos,fitness] = Pray(f_loca,try_num,pdim)
    global fish_num fish_step ;
    ypos = f_loca;
    fitness = Y(f_loca);
    for i = 1: fish_num
        for j = 1: try_num
            ypos(i,:) = rand(1,pdim) * fish_step + ypos(i,:);
            if Y(ypos(i,:))>Y(f_loca(i,:))
                fitness(i) = Y(ypos(i,:));
                break;
            end
        end
    end
end
%% 
function [max_val,max_pos,max_index] = BroadCast(f_pos)
    scores = Y(f_pos);
    max_val = max(scores);
    max_index = find(scores==max_val);
    max_pos = f_pos(max_index,:);
end

%%
function [y_pos,fitness] = Follow(f_loca,A,max_index)
    %  f_loca : the position of the fish individuals
    %  A      : the Distance Matrix calculated by Dist_CALC
    y_pos = f_loca;
    global fish_num fish_vision fish_step;
    boolean_matrix = boolean_transform(A);
    temp_vector =find(boolean_matrix(:,max_index)==1);
    % temp_vector : return the index of the fish that is not further to the
    % max_index fish( The fish that locates in the maxium fitness function
    % point in the last round of estimation).
    for j = 1: length(temp_vector)
       dire = f_loca(max_index,:) - f_loca(temp_vector(j),:);
       dire = dire ./ norm(dire) * fish_step;
       y_pos(temp_vector(j),:)= f_loca(temp_vector(j),:)+ dire; 
    end
    fitness = Y(y_pos);
end
%% 
function y = boolean_transform(A)
    global fish_vision;
    y = (A<=fish_vision) - eye(length(A));
end

function y = normalization(A,lowr,uppr,pdim)
    global fish_num;
    lb_matrix = ones(fish_num,pdim)*lowr;
    upr_matrix = ones(fish_num,pdim)*uppr;
    y = max(A,lb_matrix);
    y = min(y,upr_matrix);
end
