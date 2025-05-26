%%首先，根据svc_abs（绝对约束违反量）对种群进行排序。
%%这样做可以先处理那些违反约束较少的解，即更可行的解。
%%使用sort函数获取排序后的索引idx，然后按这个索引重新排列x, f, g, h, svc和svc_abs。
%%接下来，函数找出所有可行解（即没有违反任何约束的解）。这是通过检查svc_abs(i) > 0来完成的。
%%如果svc_abs(i)为0，表示第i个解是可行的。然后，它只对这些可行解（从第一个到end_个）按照目标函数f的值进行排序
%%这意味着在所有满足约束的解中，根据它们的目标函数值进行排序。
%%使用找到的索引idx来重新排列可行解的x, f, g, h, svc和svc_abs。

function [x, f, g, h, svc, svc_abs] = sort_pop(x, f, g, h, svc, svc_abs)
	% By sum of violated constraints
	[svc_abs, idx]= sort(svc_abs);
	x = x(idx, :);
	f = f(idx);
	g = g(idx, :);
	h = h(idx, :);
	svc = svc(idx);

	% By fitness function in feasible solutions
	ps = length(f);
	end_ = 1;
	for i = 1:ps
		if svc_abs(i) > 0.
			break
		end
		end_ = i;
	end

	[~, idx] = sort(f(1:end_));
	x(1:end_, :) = x(idx, :);
	f(1:end_) = f(idx);
	g(1:end_, :) = g(idx, :);
	h(1:end_, :) = h(idx, :);
	svc(1:end_) = svc(idx);
	svc_abs(1:end_)	= svc_abs(idx);
end