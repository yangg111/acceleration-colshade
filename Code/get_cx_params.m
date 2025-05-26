%%M_F 和 M_CR：分别存储历史中最佳变异因子和交叉率的循环数组。
%%M_F_l 和 M_CR_l：针对Levy飞行的变异和交叉率的循环数组。
%%prob_levy：选择基于Levy飞行的变异操作的概率。
%%ps：种群大小。
%%pd_normal 和 pd_cauchy：正态分布和柯西分布的对象，用于生成随机数。

%%初始化F、CR和pbest_flag数组。
%%F和CR分别用于存储每个个体的变异因子和交叉率，pbest_flag用于标记是否使用基于Levy飞行的变异策略。
%%遍历每个个体，随机选择是否使用基于Levy飞行的变异策略。
%%如果选择Levy飞行（基于prob_levy和p_i_levy(i)的比较），则从M_F_l和M_CR_l获取变异因子和交叉率；否则，从M_F和M_CR获取。
%%如果m_cr不等于-1（表示有效的交叉率），则在其基础上添加正态分布随机数以获得最终的CR值。
%%变异因子F的计算基于m_f和柯西分布随机数，但需要确保F(i)大于一个基于CR(i)和种群大小计算的临界值F_crit。
%%确保参数在合理范围内：
%%CR值被限制在0和1之间。
%%F值被限制在0和1之间。
function [F, CR, pbest_flag] = get_cx_params(M_F, M_CR, M_F_l, M_CR_l, prob_levy, ps, pd_normal, pd_cauchy)
	H = length(M_F);
	F = zeros(ps, 1);
	CR = zeros(ps, 1);
	pbest_flag = zeros(ps, 1);
	p_i_levy = rand(ps, 1);

	for i = 1:ps
		r = randi(H);
		if p_i_levy(i) <= prob_levy
			m_cr = M_CR_l(r);
			m_f = M_F_l(r);  
		else
			m_cr = M_CR(r);
			m_f = M_F(r);
			pbest_flag(i) = 1;
		end
		if m_cr ~= -1
			CR(i) = m_cr + pd_normal.random;
		end
		
		F_crit  = sqrt((1 - CR(i) / 2) / ps);
		while F(i) <= F_crit
			F(i) = m_f + pd_cauchy.random;
		end
	end

	CR = min(max(CR, 0), 1);
	F = min(F, 1.);
end