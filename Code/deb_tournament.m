%%x, f, g, h, svc, svc_abs：当前种群的解、目标函数值、不等式约束值、等式约束值和服务质量。
%%u, f_u, g_u, h_u, svc_u, svc_u_abs：候选解及其评估结果。
%%x_arch：归档种群。
%%tolerance_i, tolerance_f：容忍度阈值。

%%初始化改进值变量：
%%delta_f 和 delta_svc 用于存储每个个体在目标函数值和服务质量方面的改进情况。
%%遍历每个个体进行比较：
%%对于每个个体，比较当前解和新生成的候选解在服务质量和目标函数值方面的表现。
%%如果候选解在服务质量上有改进（即违反的约束更少），则记录这一改进。
%%如果在满足相同的约束的情况下，候选解在目标函数值上有改进，则同样记录这一改进。
%%归一化改进值：
%%将delta_f和delta_svc归一化，使得它们在相同的量级，便于比较。
%%更新种群：
%%如果对某个个体来说，候选解显示出改进，则用该候选解替换当前解，并更新相关的目标函数值和约束值。
%%被替换的解被添加到归档种群x_arch中。
function [x, f, g, h, svc, svc_abs, delta_f, x_arch] = deb_tournament(x, f, g, h, ...
	svc, svc_abs, u, f_u, g_u, h_u, svc_u, svc_u_abs, x_arch, tolerance_i, tolerance_f)


%%这里初始化了两个变量 delta_f 和 delta_svc，用于存储适应度函数的改进值和约束违反度的改进值
	ps = size(x, 1);
	delta_f = zeros(ps, 1);
	delta_svc = zeros(ps, 1);

	for i = 1:ps 
		if i == 1							% preserve or improve current best individual
			if svc_u_abs(i) < svc_abs(i)
				delta_svc(i) = svc_abs(i) - svc_u_abs(i);
			elseif (svc_u_abs(i) == 0) && (svc_abs(i) == 0) && (f_u(i) < ...
                    f(i))
				delta_f(i) = f(i) - f_u(i);
			end
		else
			if svc_u(i) < svc(i)					% Accept currently feasible over currently infeasible (improves diversity)
				delta_svc(i) = svc(i) - svc_u(i);
			elseif (svc_u(i) == 0) && (svc(i) == 0) && (f_u(i) < f(i))	% Accept currently optimal over currently sub-optimal
				delta_f(i) = f(i) - f_u(i);
			elseif any(tolerance_i > tolerance_f) && (svc_u_abs(i) <  svc_abs(i))	% Accept more feasible over infeasible
				delta_svc(i) = svc_abs(i) - svc_u_abs(i);
			end
		end
	end

	% Normalization to make comparable
	delta_f_max = max(delta_f);
	delta_svc_max = max(delta_svc);

	if delta_f_max > 0
	 	delta_f = delta_f / delta_f_max;
	end
	if delta_svc_max > 0
	 	delta_svc = delta_svc / delta_svc_max;
	end

	delta_f = delta_f + delta_svc;

	for i = 1:ps
		if delta_f(i) > 0
			x_arch = [x_arch; x(i, :)];
			x(i,:) = u(i, :);
			g(i,:) = g_u(i, :);
			h(i,:) = h_u(i, :);
			f(i) = f_u(i);
			svc(i) = svc_u(i);
			svc_abs(i) = svc_u_abs(i);
		end
	end
end
