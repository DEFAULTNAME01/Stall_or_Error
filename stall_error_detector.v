module stall_error_detector_ext #(
    parameter TIMEOUT_CYCLES = 1000
)(
    input  wire clk,
    input  wire rst_n,
    input  wire trigger,         // 任务开始/请求开始
    input  wire complete,        // 任务完成/响应成功
    input  wire err_detect,      // 异常事件检测（如数据校验错）
    input  wire ext_alarm,       // 外部主动报警信号
    input  wire manual_reset,    // 外部手动复位
    output reg  stall,           // 当前处于STALL/ERROR
    output reg  timeout,         // 发生超时
    output reg  [3:0] err_code,  // 错误码输出
    output reg  status_led,      // 状态LED指示
    output reg  alarm            // 报警输出
);

    reg [15:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || manual_reset) begin
            cnt      <= 0;
            stall    <= 0;
            timeout  <= 0;
            err_code <= 4'b0000;
            status_led <= 0;
            alarm    <= 0;
        end else if (trigger && !complete) begin
            if (cnt < TIMEOUT_CYCLES) begin
                cnt      <= cnt + 1;
                stall    <= 0;
                timeout  <= 0;
                err_code <= 4'b0000;
                status_led <= 0;
                alarm    <= 0;
            end else begin
                stall    <= 1;
                timeout  <= 1;
                err_code <= 4'b0001; // timeout error
                status_led <= 1;     // 常亮表示error
                alarm    <= 1;       // 报警
            end
        end else if (complete) begin
            cnt      <= 0;
            stall    <= 0;
            timeout  <= 0;
            err_code <= 4'b0000;
            status_led <= 0;
            alarm    <= 0;
        end else if (err_detect) begin
            stall    <= 1;
            timeout  <= 0;
            err_code <= 4'b0010; // data check error
            status_led <= ~status_led; // 进入error时LED闪烁
            alarm    <= 1;
        end else if (ext_alarm) begin
            stall    <= 1;
            timeout  <= 0;
            err_code <= 4'b0100; // external alarm
            status_led <= 1;
            alarm    <= 1;
        end
    end

endmodule
