set pin [dbget top.hInst.hInstTerms.defname]
set x 30
set y 300
foreach pin_line $pin {
    editPin -pin $pin_line \
        -layer $::env(IO_LAYER) \
        -assign ($x $y) \
        -pinWidth 0.10 \
        -pinDepth 0.5 \
        -global_location \
        -fixOverlap 1 \
        -fixedPin 1 \
        -edge 1 \
        -snap TRACK
    set x [expr $x+0.15]
}
saveDesign $::env(RESULT_DIR)/pr/data/io_placement.enc
