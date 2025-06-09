# Stall_or_Error
集成环境可复用的Stall/Error模块for verilog
#主要设计说明
err_code：错误码输出（支持区分多种错误类型）

status_led：状态指示灯输出（可高电平点亮或闪烁）

alarm：报警输出（例如拉高触发蜂鸣器、系统中断等）

报警类型分类：如超时、校验错、外部信号主动拉高等

全部信号归一到主状态机可直接集成使用

优先级：manual_reset最高，其次timeout，err_detect与ext_alarm可根据具体场景自由扩展优先级。

LED设计：可常亮表示错误，也可闪烁（如用分频器或计数器使其闪烁）。

报警：如报警输出接蜂鸣器/外部报警器，也可拉高信号通知主状态机或上位机。

err_code：输出4位码，主机或主状态机可解读错误来源并区分处理。

​
  
err_code = 4’b0001: 超时
err_code = 4’b0010: 数据校验错
err_code = 4’b0100: 外部报警
status_led: error时高电平点亮/闪烁，正常时熄灭
alarm: error时拉高报警
​
 
#实例化时通过 #(.PARAM_NAME(VALUE)) 的方式进行参数传递和重定义。
parameter 作用类似于 C 语言中的宏/常量定义，在模块编译前即被赋值。

你可以在模块定义时给出默认值（如 parameter TIMEOUT_CYCLES = 1000），实例化时如无指定则用默认值，如指定则使用实例化时的值。

多个实例可以用不同参数配置，实现“一个IP多种用途”效果。
