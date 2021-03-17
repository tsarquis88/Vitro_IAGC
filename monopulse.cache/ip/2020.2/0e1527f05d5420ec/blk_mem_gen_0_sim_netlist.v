// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Wed Mar 17 09:00:42 2021
// Host        : tomsar-mint running 64-bit Linux Mint 20.1
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [3:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [17:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [17:0]douta;

  wire [3:0]addra;
  wire clka;
  wire [17:0]dina;
  wire [17:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [17:0]NLW_U0_doutb_UNCONNECTED;
  wire [3:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [17:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "4" *) 
  (* C_ADDRB_WIDTH = "4" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.95605 mW" *) 
  (* C_FAMILY = "zynq" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "blk_mem_gen_0.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "16" *) 
  (* C_READ_DEPTH_B = "16" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "18" *) 
  (* C_READ_WIDTH_B = "18" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "16" *) 
  (* C_WRITE_DEPTH_B = "16" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "18" *) 
  (* C_WRITE_WIDTH_B = "18" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[17:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[3:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[3:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[17:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2020.2"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
QGLtnqZzRetDH6gCWT4Js6wuLlZfrNx/VJp3sfR2NF+cxypO5AxN0oDKLJJtmdrtE/ueNDg+Qf7Z
TqBNRojORA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
B6Ger3hRvfjHkaJ+W8639Kl3TzC9TogLuklOXEiMNdc4Im+DjEUzxb3DKlzu0VW3zxZqjJ3+wsW/
LnRmPCESi5Y9eRJaLFXg79EMfoj4X+nTdHAP6yCfltBADKegZ12gpnB/8ey5yn2KA74LUtPC7jna
iyjqSfsWLGnz6UdXzwk=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
BX+DxgMPRyZbYojCUR9Sk8Lq+3ZigBz4yMFHQkmurfdfDzyTPJCE827eGiPyTenK1QPVhEtf9g06
0BFXq/0COPuU1BWJwdkz1c4dE6/exDwhvEh+hPx3vRY6z8fDEf6aGVIXrHDvrmddehe7yMSIpo+k
aXHR06EEdfHCFY4TggYwhcJVXjkE+ApsVuyfmEfPmYjo8hCWyQyBsUWIOY03q1+MvUjjsmTwgs9g
fh5MY9ToaLfoJxPKdCpsqrBX4LJ+VDGFlAqIcqHTE2jCmPiToZAFXB7fzf1wDjFCBlJyFVDBGi0i
m+CouLSb7X1mvVhdDZgNrZDJMV688Bu3o54vew==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
DaIU/Ddc8USbZ2mURzujJDWDH1JbHl5tFVOOQ2aVaUPIA71yyE38OXVLEtF8rNmujYH30nEeQ+FV
LVJ16aaHw+iiuaqorTM3K5KLohVlN+WlcEtSXHuPNHjw8ddqtzpaX7pH1zqZH+YmfCL5oaNLqDH4
rkBnUl0/Gm/hzSwKjYhXGQFYQ+gGP99OjXakzrAqZzp/Iq4gt+Z5902/JV9thd/isHQImJ0QyK8M
EKM579iPAfXGes2mbiNYHcvDmSPYmW1zlhOE++N1EKeea7j/msnKeyhlC+hGE4Xfn4TVvqgQexCT
rp/wS/MosY6WH1aKFQlFH2hEppA7KXUaQlvG+w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
XmWoAt4X8hrCJ5yTyug4ajJW5UhfkLNibzjihWzZ4Cr9hQSvWZoTc8rjGsLPbz6Le+/9iI5KxecS
eR0wiAO+G2IkwhZgVBeZdKoFnlnTVAyLjk9wMAFXNyJZM6b1NDbfXlPcUsC6JePvPlwwdWknkSsC
r3KvgkWAS+O3xvRmaNw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Hw3Y+rShKrXiUViyNU1/O2qv6TgheLHBnFMj1i9MUGrHYqh9pLfLYUgWR7S2vj4jv4S+Ks0BpP4p
dKEqVAFmTCfQNEUHaVcFPkOHgig6L4mhLY6HUUKJoRgiQepgLi/W3V+ZZPQSQFkB3CU4MsJzhXvR
yLcpDriZy8cnAHD87Zi5DrNGBzj3kigJeM0du6lCQbxtF5aEdoaNP+YTnIFtcqYhoYnswQlYt0sV
HKgFA8VzqzL5WYnpH7+1IKmFkJBHkyqHCa9wPK0qCKnxkuDj70YzPVqQ+cocdKU+/gNdpCOdZlci
F2HTxrgfrXndJru3TiDqu4UavqAe0MNuFp3t0w==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XPVggoWL6aXz+MpODTOZhEUQDa0vfEnUDaYeEHXm2vGyqKJujN2c/FFAFBeBYdJATLsIsQ+BqoPc
pBbcFYXDBfOtFIW2dH6Y1OoD65KyJ/hAq8coa21kFgq4hFat5vzZ2iIfkCpTUr4vDZO7Xne8cZO9
WsHffoTCt5rS59wWm2b8I5R8Eh2TUbQg3RCyrcnD66cvcEnlXe1CNMQ4/loVJpA4IBinBf820Wjc
vw2fZbGI0jXC+ACSHOviH63Xwmn+aRV5Ppkup7IYoon/ieKapRQeASu3TTY37xSBXiInSdtMTzJ6
+4GfO4eSHVriCk/sWbuTBzfRzoSShrnHjzz5LA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2020_08", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L78XuiswVcgO2gtebzL7SA9BC/jJGAM0v6S9pzmyqL+QYzRneiYeGyDmsW33jEVVSTuNjTXkBLY7
yTOKQruatwe4V0OLi6174saSAmPgerSV1GyLP7KhmusLV/N61avC9TPam+tekhKeE0tds4EnJ3et
4JdLh+SE4Z4pcuqCjB5MFneIYKKWDx7siU6oesAQtoSJOesfMchX63MhOjOHFP/ch+1gHv3T45hg
IGF7V7TrdREVE4f9631tlVJ1o2Dypsmo/76Itz5WCGlTMjAnWXN8IXxKN+PZ3dyt1wjrZm2P/td+
xiGszFnSLrRvw/HferwtSmRx8q0fiHZ88roGTw==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kDX5kq2QEe25429T6vQqBCFvV1McKTJRYfK99ymVNK2GGvGLXSzgwJHwB2fj9rM0wme3zYYY0vQR
x+9F4L7KLlOVY6qY3LB59uDzyXBI3mMZaS905HXHJkdZHWtQWpfHhl27LqL+8FSluaD6F+KFfYOV
CwIOVuCIp/XjxFXpNBik7YiPt4kHOlDA97IXNLnYUn/g1csGqeNWce4UTne50ggWvLYGbTFGmTjT
N67TpUiGRVRCSv8Tax72GWFIMFZk3Tlp68ZUSQEybZMWX1U9XdMdtxfvNGhf8mi5jQJ2SupSzKu4
T/+53IN9T8aLePAiGBKKG1ZBj4y1ZyYA7XYvjw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 20176)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
