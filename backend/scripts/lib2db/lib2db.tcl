set lib_path "/home/ic/my_work/designs/nangate45/pdk/lib"
set lib_file "[glob -directory $lib_path *.lib]"
foreach curlib $lib_file {
	read_lib $curlib
	set libname "[get_object_name [get_libs]]"
	write_lib -format db $libname -output "[format %s.%s [file rootname $curlib] db]"
	remove_design -all
}
