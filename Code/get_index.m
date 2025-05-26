%%ps：当前种群的大小。
%%as：归档（或辅助种群）的大小。
%%p_best_percent：被视为最佳个体的解的比例。

%%p_best = randi(int32(ceil(p_best_percent * ps)), ps, 1);
%%这行代码为种群中的每个个体随机生成一个索引，这些索引指向种群中的"最佳"个体。这里的“最佳”是指按照某种标准（例如目标函数值或服务质量）排名靠前的一部分个体。
%%生成r索引：

%%r = zeros(ps, 2);
%%这行代码初始化一个ps x 2的矩阵r，用于存储后续操作中将被使用的索引。
%%对于种群中的每个个体，函数生成两个随机索引。这些索引指向参与变异和交叉操作的其他个体。
%%第一个索引r(i, 1)是从当前种群中随机选择的，且不能是个体自身。
%%第二个索引r(i, 2)是从当前种群和归档中随机选择的，且不能是个体自身或已选的第一个索引。
function [r, p_best] = get_index(ps, as, p_best_percent)
	p_best = randi(int32(ceil(p_best_percent * ps)), ps, 1);
	r = zeros(ps, 2);

	for i = 1:ps
		while true
			r(i, 1) = randi(ps);
			if r(i, 1) ~= i
				break;
			end
		end

		while true
			r(i, 2) = randi(ps + as);
			if r(i, 2) ~= i && r(i, 2) ~= r(i, 1)
				break;
			end
		end
	end
end