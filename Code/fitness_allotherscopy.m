function y =fitness_allotherscopy(x,out1)
%x vars:       Ki_Te       Kp_Te     Ki_Iq   Kp_Iq    Ki_Q    Kp_Q     Ki_Id  Kp_Id
%% if have the dat.
% load('allxydatcopy.mat');%   save('allxydat.mat','allxy_x','allxy_y')
% flag=0;
% for row=1:numel(allxy_y)
%     if sum(sum(allxy_x(row,:)==x))==8
%         y=allxy_y(row);
%         flag=1;
%         break;
%     end
% end
%% set data
% if flag==0
    set_param('model_PMSG/PMSG Wind Turbine/Control/Speed Control/Kp1','Gain',num2str(x(1)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Speed Control/Ki1','Gain',num2str(x(2)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Speed Control/Kd1','Gain',num2str(x(3)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Rotor-side Controls/Kp2','Gain',num2str(x(4)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Rotor-side Controls/Ki2','Gain',num2str(x(5)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Rotor-side Controls/Kd2','Gain',num2str(x(6)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Rotor-side Controls/Kp3','Gain',num2str(x(7)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Rotor-side Controls/Ki3','Gain',num2str(x(8)))
    set_param('model_PMSG/PMSG Wind Turbine/Control/Rotor-side Controls/Kd3','Gain',num2str(x(9)))
    %% run and get data. get the intergrator of data  from 20s to end.
    % set_param('model_VC_MPPT_5copy/VqsVs1','FileName',['case1vqs.mat'])
    % set_param('model_VC_MPPT_5copy/Wind1/FromFile1','FileName',['case1wind.mat'])
    % sim('model_VC_MPPT_5copy');
    % case1=my_fitnessdata(end);
    % set_param('model_VC_MPPT_5copy/VqsVs1','FileName',['case2vqs.mat'])
    % set_param('model_VC_MPPT_5copy/Wind1/FromFile1','FileName',['case2wind.mat'])
    % sim('model_VC_MPPT_5copy');
    % case2=my_fitnessdata(end);
    % set_param('model_VC_MPPT_5copy/VqsVs1','FileName',['case3vqs.mat'])
    % set_param('model_VC_MPPT_5copy/Wind1/FromFile1','FileName',['case3wind.mat'])
    % sim('model_VC_MPPT_5copy');
    % case3=my_fitnessdata(end);
    % y=case1+case2+case3;    
    % set_param('model_PMSG/PMSG Wind Turbine/FromFile1','FileName', 'case1wind.mat')
    % sim('model_PMSG');
    % case1=my_fitnessdata(end);
    % set_param('model_PMSG/PMSG Wind Turbine/FromFile1','FileName', 'case2wind.mat')
    % sim('model_PMSG');
    % case2=my_fitnessdata(end);
    % set_param('model_PMSG/PMSG Wind Turbine/FromFile1','FileName', 'case3wind.mat')
    % sim('model_PMSG');
    % case3=my_fitnessdata(end);
    % out1 = sim('model_PMSG', 'Stoptime', '10', 'SaveFinalState', 'on', ...
    % 'LoadInitialState', 'off', 'SaveOperatingPoint', 'on', ...
    % 'FinalStateName', 'xFinal');
    set_param('model_PMSG/PMSG Wind Turbine/FromFile1','FileName', 'case1wind.mat')
    assignin('base','xInitial',out1.get('xFinal'));
    out2=sim('model_PMSG','Stoptime','18','LoadInitialState','on','InitialState','xInitial','SaveFinalState','on','SaveOperatingPoint', 'on','FinalStateName', 'xFinal');
    y=out2.my_fitnessdata(end);
    %% save all dat. x  y
    % allxy_x=[allxy_x;x;];
    % allxy_y=[allxy_y;y;];
    % save('allxydatcopy.mat','allxy_x','allxy_y');
% end
end