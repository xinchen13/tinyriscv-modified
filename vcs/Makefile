.PHONY: vcs verdi clean

#compile command 
VCS	=	vcs +v2k  -timescale=1ns/1ps	\
			-top tinyriscv_soc_tb	\
			-sverilog	\
			-full64	\
			-R 		\
			-debug_access+all	\
			-f filelist.f	\
			+mindelays	\
			-negdelay	\
			+neg_tchk	\
			-l vcs.log \
			+incdir+../rtl/header

VERDI=Verdi-Ultra -f filelist.f   \
		-ssf tinyriscv_soc.fsdb    \
		-nologo                \
		-l verdi.log             

#start compile and simulate
vcs:
	$(VCS)

#run verdi
verdi:
	$(VERDI)
	
#clean
clean:
	rm -rf  ./Verdi-SXLog ./Verdi-UltraLog ./dff ./csrc *.daidir *log *.vpd *.vdb simv* *.key *race.out* *.rc *.fsdb *.vpd *.log *.conf *.dat *.conf *.so uart
