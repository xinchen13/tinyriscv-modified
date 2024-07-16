set  GDS_FILE [layout create ./result/pr/data/ibex_core.merge.gds -dt_expand]
$GDS_FILE create layer 45
$GDS_FILE create text ibex_core 45 0.0 0.0 VDD
$GDS_FILE create text ibex_core 45 0.0 0.0 VSS
$GDS_FILE gdsout ./result/pr/data/ibex_core.text.gds ibex_core
