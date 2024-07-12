# ----------------------------------------
# Create compilation libraries
vlib usim
vmap usim "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/usim"
vlib vsim
vmap vsim "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/vsim"
vlib adc
vmap adc "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/adc"
vlib ddrc
vmap ddrc "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/ddrc"
vlib ddrphy
vmap ddrphy "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/ddrphy"
vlib hsst_e2
vmap hsst_e2 "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/hsst_e2"
vlib iolhr_dft
vmap iolhr_dft "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/iolhr_dft"
vlib ipal_e1
vmap ipal_e1 "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/ipal_e1"
vlib pciegen2
vmap pciegen2 "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/pciegen2"


#compile basic library
vlog -incr "D:/pango/PDS_2022.2-SP1-Lite/arch/vendor/pango/verilog/simulation/*.v" -work usim
vlog -incr "D:/pango/PDS_2022.2-SP1-Lite/arch/vendor/pango/verilog/simulation/modelsim10.2c/*.vp" -work usim


#compile basic library
vlog -incr "D:/pango/PDS_2022.2-SP1-Lite/arch/vendor/pango/verilog/bsim/*.v" -work vsim
vlog -incr "D:/pango/PDS_2022.2-SP1-Lite/arch/vendor/pango/verilog/bsim/modelsim10.2c/*.vp" -work vsim


#compile common library
cd "D:/pango/PDS_2022.2-SP1-Lite/arch/vendor/pango/verilog/simulation/modelsim10.2c"
vmap adc "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/adc"
vlog -incr -f ./filelist_adc_gtp.f -work adc
vmap ddrc "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/ddrc"
vlog -incr -f ./filelist_ddrc_gtp.f -work ddrc -sv -mfcu
vmap ddrphy "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/ddrphy"
vlog -incr -f ./filelist_ddrphy_gtp.f -work ddrphy
vmap hsst_e2 "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/hsst_e2"
vlog -incr -f ./filelist_hsst_e2_gtp.f -work hsst_e2
vmap iolhr_dft "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/iolhr_dft"
vlog -incr -f ./filelist_iolhr_dft_gtp.f -work iolhr_dft
vmap ipal_e1 "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/ipal_e1"
vlog -incr -f ./filelist_ipal_e1_gtp.f -work ipal_e1
vmap pciegen2 "E:/project/FPGAPango/hdmi/v1.0/project/pango_sim_libraries/pciegen2"
vlog -incr -f ./filelist_pciegen2_gtp.f -work pciegen2 -sv -mfcu

quit -force

# ----------------------------------------
