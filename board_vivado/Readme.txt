Follow this step to generate the vivado design and its dsa file.
1. open vivado 2018.1, cd to this directory and then source mz_petalinux_board.tcl
2. you can directly to run write_dsa mz_petalinux_plat.dsa -include_bit and validate_dsa mz_petalinux_plat.dsa or you can first modify some properties in set_properties.tcl and source this file then generate the dsa file.
