-makelib xcelium_lib/xpm -sv \
  "/home/tomsar/programas/vivado_2020.2/Vivado/2020.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
  "/home/tomsar/programas/vivado_2020.2/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "/home/tomsar/programas/vivado_2020.2/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../monopulse.gen/sources_1/ip/blk_mem_gen_0_1/sim/blk_mem_gen_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

