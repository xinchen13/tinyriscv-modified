source $::env(RESULT_DIR)/pr/data/floor_plan.enc

# -------------------------------------------------------------
# Global PG net connect
# -------------------------------------------------------------
globalNetConnect VDD -type pgpin -pin $::env(CORE_PWR_PORT) -inst *
globalNetConnect VDD -type tiehi -pin $::env(CORE_PWR_PORT) -inst *
globalNetConnect VDD -type net -net VDD
globalNetConnect VSS -type pgpin -pin $::env(CORE_GND_PORT) -inst *
globalNetConnect VSS -type tielo -pin $::env(CORE_GND_PORT) -inst *
globalNetConnect VSS -type net -net VSS

# -------------------------------------------------------------
# Add Power Ring
# -------------------------------------------------------------
addRing -skip_via_on_wire_shape Noshape -exclude_selected 1 -skip_via_on_pin Standardcell \
	-center 1 -stacked_via_top_layer M6 -type core_rings -jog_distance 0.56 -threshold 0.56 \
	-nets {VDD VSS} -follow core -stacked_via_bottom_layer M1 -layer {bottom M5 top M5 right M6 left M6} \
	-width 18 -spacing 2 -offset 2

# -------------------------------------------------------------
# Add the power stripe
# -------------------------------------------------------------
addStripe -nets {VSS VDD} \
    -layer $::env(V_STRIPE_METAL) \
    -direction vertical \
    -width $::env(STRIPE_WIDTH) \
    -spacing $::env(STRIPE_SPACING) \
    -set_to_set_distance $::env(STRIPE_DISTANCE) \
    -start_from left \
    -start_offset 1 \
    -uda power_stripe_v

addStripe -nets {VSS VDD} \
    -layer M4 \
    -direction vertical \
    -width $::env(STRIPE_WIDTH) \
    -spacing $::env(STRIPE_SPACING) \
    -set_to_set_distance $::env(STRIPE_DISTANCE) \
    -start_from left \
    -start_offset 1 \
    -uda power_stripe_v

addStripe -nets {VSS VDD} \
    -layer $::env(H_STRIPE_METAL) \
    -direction horizontal \
    -width $::env(STRIPE_WIDTH) \
    -spacing $::env(STRIPE_SPACING) \
    -set_to_set_distance $::env(STRIPE_DISTANCE) \
    -start_from bottom \
    -start_offset 1 \
    -uda power_stripe_h

# -------------------------------------------------------------
# Add the power rail
# -------------------------------------------------------------

set sroute_min_layer $::env(SROUTE_MIN_LAYER)
set sroute_max_layer $::env(SROUTE_MAX_LAYER)
sroute -connect { padPin padRing corePin floatingStripe } \
    -layerChangeRange " $sroute_min_layer $sroute_max_layer " \
    -blockPinTarget { nearestTarget } \
    -padPinPortConnect { allPort oneGeom } \
    -padPinTarget { nearestTarget } \
    -corePinTarget { stripe } \
    -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } \
    -allowJogging 1 \
    -crossoverViaLayerRange " $sroute_min_layer $sroute_max_layer " \
    -nets { VDD VSS } \
    -allowLayerChange 1 \
    -targetViaLayerRange " $sroute_min_layer $sroute_max_layer " \
    -uda power_rail
#sroute -connect padRing
#sroute -connect padPin -padPinPortConnect { allPort oneGeom } -padPinTarget {ring}
#sroute -connect corePin -corePinTarget {stripe}
#sroute -connect floatingStripe

# -------------------------------------------------------------
# Verify connect violation
# -------------------------------------------------------------
verifyConnectivity -type special \
    -noAntenna \
    -noWeakConnect \
    -noUnroutedNet \
    -error 1000 \
    -warning 50
verify_PG_short  -no_routing_blkg

# -------------------------------------------------------------
# Save design
# -------------------------------------------------------------
saveDesign $::env(RESULT_DIR)/pr/data/powerplan.enc

exit
