# compile_rtl.py

编译rtl代码

使用方法： `python compile_rtl.py [rtl目录相对路径]`

比如： `python compile_rtl.py ..`

# sim_new_nowave.py

对指定的bin文件(重新生成inst.data文件)进行测试

使用方法, Linux系统下： `python sim_new_nowave.py ../tests/isa/generated/rv32ui-p-add.bin inst.data`

# sim_default_nowave.py

对已经存在的inst.data文件进行测试

使用方法： `python sim_default_nowave.py`

# test_all_isa.py

一次性测试../tests/isa/generated目录下的所有指令

使用方法： `python test_all_isa.py`

# generate_inst_data_and_sim.py

1. 对指定的 .data 文件(重新复制到 inst.data 文件)进行测试
2. 对指定的 .bin 文件(重新生成 inst.data 文件)进行测试

