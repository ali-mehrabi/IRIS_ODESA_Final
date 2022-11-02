onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /iris_odesa_tb/uut/u_clk_sys/o_clk_lvl_2
add wave -noupdate /iris_odesa_tb/uut/u_clk_sys/o_clk_lvl_1
add wave -noupdate -radix decimal /iris_odesa_tb/uut/u_at/r_epochs
add wave -noupdate -color White -itemcolor White -expand -subitemconfig {{/iris_odesa_tb/uut/u_l1/u_L1_train/i_event[4]} {-color White -height 15 -itemcolor White} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_event[3]} {-color White -height 15 -itemcolor White} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_event[2]} {-color White -height 15 -itemcolor White} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_event[1]} {-color White -height 15 -itemcolor White}} /iris_odesa_tb/uut/u_l1/u_L1_train/i_event
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_training_active
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/w_input_event_on
add wave -noupdate -color Gold -itemcolor Gold /iris_odesa_tb/uut/u_l1/u_L1_train/w_pass_l1
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/w_las
add wave -noupdate -color Red -itemcolor Red /iris_odesa_tb/uut/u_l1/u_L1_train/r_winner
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_ts
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w4
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w3
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w2
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w1
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_tr_nw
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_tr
add wave -noupdate -color Cyan -itemcolor Cyan /iris_odesa_tb/uut/u_l1/u_L1_train/r_nwinner
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/w_nwinner
add wave -noupdate -expand -subitemconfig {{/iris_odesa_tb/uut/u_l1/u_L1/w_threshold[6]} {-format Analog-Step -height 74 -max 117549.0 -min 29468.0} {/iris_odesa_tb/uut/u_l1/u_L1/w_threshold[5]} {-format Analog-Step -height 74 -max 131058.99999999999 -min -131042.0} {/iris_odesa_tb/uut/u_l1/u_L1/w_threshold[4]} {-format Analog-Step -height 74 -max 100350.0 -min 31300.0} {/iris_odesa_tb/uut/u_l1/u_L1/w_threshold[3]} {-format Analog-Step -height 74 -max 118255.0 -min 31146.0} {/iris_odesa_tb/uut/u_l1/u_L1/w_threshold[2]} {-format Analog-Step -height 74 -max 131045.99999999997 -min -130876.0} {/iris_odesa_tb/uut/u_l1/u_L1/w_threshold[1]} {-format Analog-Step -height 74 -max 131069.99999999999 -min -131070.0}} /iris_odesa_tb/uut/u_l1/u_L1/w_threshold
add wave -noupdate -color Yellow -itemcolor Yellow -expand -subitemconfig {{/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[6]} {-color Yellow -height 15 -itemcolor Yellow} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[5]} {-color Yellow -height 15 -itemcolor Yellow} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[4]} {-color Yellow -height 15 -itemcolor Yellow} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[3]} {-color Yellow -height 15 -itemcolor Yellow} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[2]} {-color Yellow -height 15 -itemcolor Yellow} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[1]} {-color Yellow -height 15 -itemcolor Yellow}} /iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout
add wave -noupdate -divider L2
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_tr_6
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_tr_5
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_tr_4
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_tr_3
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_tr_2
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_tr_1
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_threshold
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_neuron_out
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/u_spg/o_spike
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/w_is_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/w_is_label
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w6
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w5
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w4
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w3
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w2
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w1
add wave -noupdate -expand -subitemconfig {{/iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold[3]} {-color Magenta -format Analog-Step -height 74 -itemcolor Magenta -max 108117.0 -min 468.0} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold[2]} {-color Magenta -format Analog-Step -height 74 -itemcolor Magenta -max 102858.0 -min 3003.0} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold[1]} {-color Magenta -format Analog-Step -height 74 -itemcolor Magenta -max 92174.0 -min 2384.0}} /iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/i_lv
add wave -noupdate -color Red -itemcolor Red -expand -subitemconfig {{/iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout[3]} {-color Red -height 15 -itemcolor Red} {/iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout[2]} {-color Red -height 15 -itemcolor Red} {/iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout[1]} {-color Red -height 15 -itemcolor Red}} /iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_training_active
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/w_pass_l2
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_stop_n
add wave -noupdate -color Blue -itemcolor Blue -expand -subitemconfig {{/iris_odesa_tb/uut/u_l2/u_L2_train/r_label[3]} {-color Blue -height 15 -itemcolor Blue} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_label[2]} {-color Blue -height 15 -itemcolor Blue} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_label[1]} {-color Blue -height 15 -itemcolor Blue}} /iris_odesa_tb/uut/u_l2/u_L2_train/r_label
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_ts
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_is_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_is_label
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_eta
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_delta
add wave -noupdate -color Yellow -format Analog-Step -height 74 -itemcolor Yellow -max 60198.0 /iris_odesa_tb/uut/u_l2/u_L2/u_neuron_6in_1/w_add_value
add wave -noupdate -color Yellow -format Analog-Step -height 74 -itemcolor Yellow -max 60198.0 /iris_odesa_tb/uut/u_l2/u_L2/u_neuron_6in_2/w_add_value
add wave -noupdate -color Yellow -format Analog-Step -height 74 -itemcolor Yellow -max 60198.0 /iris_odesa_tb/uut/u_l2/u_L2/u_neuron_6in_3/w_add_value
add wave -noupdate -format Analog-Step -height 74 -max 131060.99999999997 -min -131062.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_4in_l1[1]/u_neuron4in/w_add_value}
add wave -noupdate -format Analog-Step -height 74 -max 131067.00000000001 -min -131068.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_4in_l1[2]/u_neuron4in/w_add_value}
add wave -noupdate -format Analog-Step -height 74 -max 131053.0 -min -131055.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_4in_l1[3]/u_neuron4in/w_add_value}
add wave -noupdate -format Analog-Step -height 74 -max 131003.99999999999 -min -131014.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_4in_l1[4]/u_neuron4in/w_add_value}
add wave -noupdate -format Analog-Step -height 74 -max 130815.00000000001 -min -130564.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_4in_l1[5]/u_neuron4in/w_add_value}
add wave -noupdate -format Analog-Step -height 74 -max 130815.00000000001 -min -130564.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_4in_l1[6]/u_neuron4in/w_add_value}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {91692339440 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 345
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {98032972192 ns} {98194954706 ns}
