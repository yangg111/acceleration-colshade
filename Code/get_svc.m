%%g：表示不等式约束的数组。
%%h：表示等式约束的数组。
%%epsilon：是等式约束的容忍度
%%这行代码确保所有不等式约束的值非负。
%%在优化中，不等式约束通常表示为g(x) <= 0。如果某个约束的值大于0，则表示该约束被违反
%g = max(g, 0);
%%对于等式约束，通常形式为h(x) = 0。这里使用abs(h) - epsilon计算每个等式约束的违反程度
%%只有当abs(h)的值大于epsilon时，才认为该约束被违反。
%h = max(abs(h) - epsilon, 0);
%%这行代码计算每个个体的总约束违反量，即服务质量。它是所有不等式和等式约束违反量的总和。
%svc = sum(g, 2) + sum(h, 2);
%%这行代码计算等式约束中的最小值，用于独立评估等式约束的违反程度。
%%在某些情况下，这可能有助于更好地理解种群中个体的可行性。
%h_sum = min(h)
function [svc, h_sum] = get_svc(g, h, epsilon)
	g = max(g, 0);
	h = max(abs(h) - epsilon, 0);
	svc = sum(g, 2) + sum(h, 2);
    h_sum = min(h);					% for evaluating feasibility independently
end