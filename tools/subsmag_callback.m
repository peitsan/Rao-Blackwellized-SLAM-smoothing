function subsmag_callback(~, msg)
%     mag_data = receive(msg,10);
    persistent imuLog
    if isempty(imuLog)
        imuLog = struct('Time', {},'Mag', {}, 'Seq', {});
    end
    
    updates.Time = msg.Header.Stamp;
    % 解析磁力强度（μT）
    updates.Mag = [msg.Vector.X, msg.Vector.Y, msg.Vector.Z];
    updates.Seq = msg.Header.Seq;
 
    % 追加到持久变量
    imuLog(end+1) = updates;

    % 实时显示数据
    disp('磁力话题发布: ');
    disp(updates);
    
    % 定期同步到工作区（每5条数据）
    if mod(length(imuLog), 5) == 0
        assignin('base', 'imuLog', imuLog);
    end
end