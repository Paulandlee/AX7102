vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v2_4_clk_ibuf.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v2_4_infrastructure.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v2_4_iodelay_ctrl.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/clocking/mig_7series_v2_4_tempmon.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_arb_mux.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_arb_row_col.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_arb_select.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_bank_cntrl.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_bank_common.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_bank_compare.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_bank_mach.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_bank_queue.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_bank_state.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_col_mach.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_mc.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_rank_cntrl.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_rank_common.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_rank_mach.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/controller/mig_7series_v2_4_round_robin_arb.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v2_4_ecc_buf.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v2_4_ecc_dec_fix.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v2_4_ecc_gen.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v2_4_ecc_merge_enc.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ecc/mig_7series_v2_4_fi_xor.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ip_top/mig_7series_v2_4_memc_ui_top_std.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ip_top/mig_7series_v2_4_mem_intfc.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_byte_group_io.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_byte_lane.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_calib_top.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_if_post_fifo.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_mc_phy.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_mc_phy_wrapper.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_of_pre_fifo.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_4lanes.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ck_addr_cmd_delay.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_dqs_found_cal.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_dqs_found_cal_hr.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_init.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_cntlr.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_data.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_edge.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_lim.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_mux.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_po_cntlr.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_ocd_samp.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_oclkdelay_cal.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_prbs_rdlvl.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_rdlvl.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_tempmon.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_top.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_wrcal.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_wrlvl.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_phy_wrlvl_off_delay.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_ddr_prbs_gen.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_poc_cc.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_poc_edge_store.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_poc_meta.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_poc_pd.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_poc_tap_base.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/phy/mig_7series_v2_4_poc_top.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v2_4_ui_cmd.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v2_4_ui_rd_data.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v2_4_ui_top.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ui/mig_7series_v2_4_ui_wr_data.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3_mig_sim.v" \
"../../../../ddr3_test.srcs/sources_1/ip/ddr3/ddr3/user_design/rtl/ddr3.v" \


vlog -work xil_defaultlib "glbl.v"

