// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
// Date        : Wed Mar 17 10:53:58 2021
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
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [9:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [63:0]douta;

  wire [9:0]addra;
  wire clka;
  wire [63:0]dina;
  wire [63:0]douta;
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
  wire [63:0]NLW_U0_doutb_UNCONNECTED;
  wire [9:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [9:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "10" *) 
  (* C_ADDRB_WIDTH = "10" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
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
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     5.9043 mW" *) 
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
  (* C_READ_DEPTH_A = "1024" *) 
  (* C_READ_DEPTH_B = "1024" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "64" *) 
  (* C_READ_WIDTH_B = "64" *) 
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
  (* C_WRITE_DEPTH_A = "1024" *) 
  (* C_WRITE_DEPTH_B = "1024" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[63:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[9:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[9:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 48064)
`pragma protect data_block
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
HNdW66Tl/5X/PEkf1w==
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
