source $::env(RESULT_DIR)/pr/data/post_cts_opt.enc

# -------------------------------------------------------------
# NanoRoute Mode setting
# -------------------------------------------------------------
setNanoRouteMode -quiet -routeWithTimingDriven true
setAnalysisMode -analysisType onChipVariation
setNanoRouteMode -quiet -drouteEndIteration 70
setNanoRouteMode -quiet -drouteFixAntenna true
setNanoRouteMode -quiet -drouteUseMultiCutViaEffort medium
setNanoRouteMode -quiet -drouteMinSlackForWireOptimization 0.1
setNanoRouteMode -quiet -routeTopRoutingLayer $::env(MAX_ROUTING_LAYER)
setNanoRouteMode -quiet -routeBottomRoutingLayer $::env(MIN_ROUTING_LAYER)
setNanoRouteMode -quiet -routeWithSiDriven true
setNanoRouteMode -drouteFixAntenna true
setNanoRouteMode -routeAntennaCellName "ANTENNA"
setNanoRouteMode -routeInsertAntennaDiode true

setDelayCalMode -engine default -siAware true


# -------------------------------------------------------------
# Route Design
# -------------------------------------------------------------
routeDesign -globalDetail
saveDesign $::env(RESULT_DIR)/pr/data/routing.enc

# -------------------------------------------------------------
# save Design
# -------------------------------------------------------------
timeDesign -postRoute -prefix postRoute -outDir $::env(RESULT_DIR)/pr/report/routing_timing

exit
