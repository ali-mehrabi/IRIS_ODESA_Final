onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color White -itemcolor White -radix decimal /iris_odesa_tb/uut/u_at/r_epochs
add wave -noupdate /iris_odesa_tb/uut/u_clk_sys/o_clk_lvl_2
add wave -noupdate /iris_odesa_tb/uut/u_clk_sys/o_clk_lvl_1
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/w_input_event_on
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/w_pass_l1
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_stop_n
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_winner
add wave -noupdate -color Magenta -itemcolor Magenta /iris_odesa_tb/uut/u_l1/u_L1_train/r_gas
add wave -noupdate -color Cyan -itemcolor Cyan /iris_odesa_tb/uut/u_l1/u_L1_train/w_las
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/i_gas
add wave -noupdate -expand /iris_odesa_tb/uut/u_l1/u_L1_train/i_event
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w4
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w3
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w2
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_w1
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_tr
add wave -noupdate -expand -subitemconfig {{/iris_odesa_tb/uut/u_l1/u_L1_train/r_threshold[4]} {-format Analog-Step -height 74 -max 262000.0} {/iris_odesa_tb/uut/u_l1/u_L1_train/r_threshold[3]} {-format Analog-Step -height 74 -max 262000.0} {/iris_odesa_tb/uut/u_l1/u_L1_train/r_threshold[2]} {-format Analog-Step -height 74 -max 262000.0} {/iris_odesa_tb/uut/u_l1/u_L1_train/r_threshold[1]} {-format Analog-Step -height 74 -max 262000.0}} /iris_odesa_tb/uut/u_l1/u_L1_train/r_threshold
add wave -noupdate -color {Orange Red} -itemcolor {Orange Red} -expand -subitemconfig {{/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[4]} {-color {Orange Red} -height 15 -itemcolor White} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[3]} {-color {Orange Red} -height 15 -itemcolor White} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[2]} {-color {Orange Red} -height 15 -itemcolor White} {/iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout[1]} {-color {Orange Red} -height 15 -itemcolor White}} /iris_odesa_tb/uut/u_l1/u_L1_train/i_l1_spikeout
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/w_is_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w4
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w3
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w2
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_w1
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_ts
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2/w_lv
add wave -noupdate -expand -subitemconfig {{/iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold[3]} {-format Analog-Step -height 74 -max 440164.0} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold[2]} {-format Analog-Step -height 74 -max 421351.0} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold[1]} {-format Analog-Step -height 74 -max 179769.0}} /iris_odesa_tb/uut/u_l2/u_L2_train/r_threshold
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_training_active
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/w_is_label
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/w_pass_l2
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_stop_n
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_is_winner
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_is_label
add wave -noupdate -radix decimal /iris_odesa_tb/uut/u_at/r_address
add wave -noupdate -color Red -itemcolor Red -expand -subitemconfig {{/iris_odesa_tb/uut/u_l2/u_L2_train/r_label[3]} {-color Red -height 15 -itemcolor Red} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_label[2]} {-color Red -height 15 -itemcolor Red} {/iris_odesa_tb/uut/u_l2/u_L2_train/r_label[1]} {-color Red -height 15 -itemcolor Red}} /iris_odesa_tb/uut/u_l2/u_L2_train/r_label
add wave -noupdate -color Blue -itemcolor Blue -expand -subitemconfig {{/iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout[3]} {-color Blue -height 15 -itemcolor Blue} {/iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout[2]} {-color Blue -height 15 -itemcolor Blue} {/iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout[1]} {-color Blue -height 15 -itemcolor Blue}} /iris_odesa_tb/uut/u_l2/u_L2_train/i_l2_spikeout
add wave -noupdate -divider pot
add wave -noupdate -color {Sky Blue} -format Analog-Step -height 74 -itemcolor {Sky Blue} -max 323518.0 /iris_odesa_tb/uut/u_l2/u_L2/u_neuron_4in_3/w_add_value
add wave -noupdate -color {Sky Blue} -format Analog-Step -height 74 -itemcolor {Sky Blue} -max 337084.0 /iris_odesa_tb/uut/u_l2/u_L2/u_neuron_4in_2/w_add_value
add wave -noupdate -color {Sky Blue} -format Analog-Step -height 74 -itemcolor {Sky Blue} -max 286636.0 /iris_odesa_tb/uut/u_l2/u_L2/u_neuron_4in_1/w_add_value
add wave -noupdate -color Coral -format Analog-Step -height 74 -itemcolor Coral -max 203745.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_20in_l1[4]/u_neuron4in/w_add_value}
add wave -noupdate -color Coral -format Analog-Step -height 74 -itemcolor Coral -max 203745.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_20in_l1[3]/u_neuron4in/w_add_value}
add wave -noupdate -color Coral -format Analog-Step -height 74 -itemcolor Coral -max 203745.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_20in_l1[2]/u_neuron4in/w_add_value}
add wave -noupdate -color Coral -format Analog-Step -height 74 -itemcolor Coral -max 203745.0 {/iris_odesa_tb/uut/u_l1/u_L1/u_neuron_20in_l1[1]/u_neuron4in/w_add_value}
add wave -noupdate -divider function
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/calthr/calthr
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/calthr/b
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/calthr/a
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/calwt/calwt
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/calwt/b
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/calwt/a
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/calthr/calthr
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/calthr/b
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/calthr/a
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/calwt/calwt
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/calwt/b
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/calwt/a
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_eta
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/r_delta
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/f_eta/f_eta
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/f_delta/f_delta
add wave -noupdate /iris_odesa_tb/uut/u_l1/u_L1_train/f_delta/f_in
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_delta
add wave -noupdate /iris_odesa_tb/uut/u_l2/u_L2_train/r_eta
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1279769609490 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 287
configure wave -valuecolwidth 99
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
WaveRestoreZoom {1278600654332 ns} {1281746025132 ns}
