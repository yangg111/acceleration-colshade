%%x：当前种群。
%%x_arch：归档种群。
%%r：随机索引，用于选择变异操作中的个体。
%%pbest：指向种群中最佳个体的索引。
%%F：变异因子。
%%CR：交叉率。
%%pbest_flag：标记是否使用基于Levy飞行的变异策略。
%%xmin 和 xmax：变量的界限。
%%pd_levy：Levy分布对象，用于生成Levy飞行的随机数。

%%变异操作：
%%为每个个体创建一个变异向量v。
%%根据pbest_flag，选择是使用基于Levy飞行的变异还是"current-to-pbest"变异策略。
%%对于"current-to-pbest"，利用x(p, :) - x(i, :)和x(r1, :) - x(r2, :)来计算变异向量。
%%对于Levy飞行变异，使用Levy分布生成的随机数与x(p, :) - x(i, :)相乘。
%%边界约束处理：
%%检查变异向量v是否超出变量的界限，对超出界限的部分进行处理。
%%使用一定的策略（如随机重新分配）处理超出界限的值。
%%交叉操作：
%%生成随机数矩阵cross_，用于确定哪些维度将从变异向量v继承，哪些维度将保留原始个体x的值。
%%保证每个个体至少有一个维度是从变异向量继承的。
%%结合变异向量和原始个体的值，形成新的候选解u。

function [u] = crossover(x, x_arch, r, pbest, F, CR, pbest_flag, xmin, xmax, pd_levy)
	% 变异操作：
	[ps, D] = size(x);
	v = zeros(ps, D);

	for i = 1:ps
		p  = pbest(i);
		if pbest_flag(i)				% current-to-pbest
			r1 = r(i, 1);
			r2 = r(i, 2);
			if r2 > ps 					% using solution in file
				r2 = r2 - ps;
				v(i, :) = x(i, :) + F(i) * (x(p, :) - x(i, :)) + F(i) * (x(r1, :) - x_arch(r2, :));
			else
				v(i, :) = x(i, :) + F(i) * (x(p, :) - x(i, :)) + F(i) * (x(r1, :) - x(r2, :));
			end
		else 							% levy flight
			levy_rand = pd_levy.random(1, D);
			v(i, :) = x(i, :) + F(i) * levy_rand .* (x(p, :) - x(i, :));
		end
	end

	% 边界约束处理：
	v_upper = v > xmax;
	v_lower = v < xmin;

	v = v.*(~v_upper);				% Make zero outbounded values
	v = v.*(~v_lower);

	base = 0.1 * rand(ps, D);
	x_upper = (1 - base) .* xmax + base .* x;
	x_lower = (1 - base) .* xmin + base .* x;

	v_upper = v_upper .* x_upper;	% Keep x_{i,j} values where v_{i,j} is outbounded
	v_lower = v_lower .* x_lower;

	v = v + v_upper + v_lower;

	% 交叉操作：
	cross_  = rand(ps, D);
	for i = 1:ps
		cross_(i, randi(D)) = 0;	% get j_rand value for crossover
	end

	v_values = cross_ <= CR;
	x_values = cross_ > CR;
	v = v .* v_values;
	x = x .* x_values;
	u = v + x;
end