set_property PACKAGE_PIN K18 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
set_property PACKAGE_PIN B16 [get_ports RSTn]
set_property IOSTANDARD LVCMOS33 [get_ports RSTn]

set_property PACKAGE_PIN V20 [get_ports SWCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SWCLK]
set_property IOSTANDARD LVCMOS33 [get_ports SWDIO]


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets SWCLK_IBUF]

set_property PACKAGE_PIN W19 [get_ports SWDIO]


set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN AA21 [get_ports {LED[0]}]
set_property PACKAGE_PIN P19 [get_ports {LED[1]}]
set_property PACKAGE_PIN P20 [get_ports {LED[2]}]
set_property PACKAGE_PIN R19 [get_ports {LED[3]}]
set_property PACKAGE_PIN T20 [get_ports {LED[4]}]
set_property PACKAGE_PIN T21 [get_ports {LED[5]}]
set_property PACKAGE_PIN U21 [get_ports {LED[6]}]
set_property PACKAGE_PIN U22 [get_ports {LED[7]}]
