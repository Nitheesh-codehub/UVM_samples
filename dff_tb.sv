`timescale 1ns/1ps
module tb_dff;

  import dff_pkg::*;

  logic clk = 0;
  always #5 clk = ~clk;   // 10ns clock

  // Interface Instance
  dff_if vif(clk);

  // DUT
  dff dut(vif);

  // Class Handles
  dff_driver      drv;
  dff_scoreboard  sco;
  dff_transaction tr;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_dff);

    drv = new(vif);
    sco = new();

    // Reset
    drv.reset();

    // Test Case 1
    tr = new();
    tr.set_input(0);
    tr.display();
    drv.drive(tr);
    @(posedge clk);
    sco.check(tr.get_d(), vif.q);

    // Test Case 2
    tr = new();
    tr.set_input(1);
    tr.display();
    drv.drive(tr);
    @(posedge clk);
    sco.check(tr.get_d(), vif.q);

    // Test Case 3
    tr = new();
    tr.set_input(0);
    tr.display();
    drv.drive(tr);
    @(posedge clk);
    sco.check(tr.get_d(), vif.q);

    #20;
    $finish;
  end
endmodule