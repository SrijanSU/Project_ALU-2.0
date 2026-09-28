# ALU 2.0 — Class-Based SystemVerilog Verification

Non-UVM, class-based testbench for an 8-bit parameterized ALU (`ALU_DESIGN` in `design.sv`).

## Running

There is no Makefile or file list in this repository. `alu_testbench.sv` is the top file: it includes the DUT, interface, package, and classes, and defines module `top`.

The checked-in `transcript` came from QuestaSim 10.6c:

```text
vsim -coverage top -c -do "coverage save -onexit -directive -codeAll coverage_n.ucdb; run -all; exit"
```

The preceding compile (`vlog`) command is not recorded. That run reported 0 errors and 1,293 warnings. The scoreboard reported many mismatches, with about a 39% match rate.

## Configuration

Values in `defines.sv`:

- `DATA_WIDTH=8`
- `CMD_WIDTH=4`
- `NUM_TRANSACTIONS=25`
- `MAX_CYCLE_WAIT=16`
- `PERIOD=20`

## DUT Summary

- `MODE=1` selects arithmetic; `MODE=0` selects logical operations.
- `CMD` is four bits wide.
- `INP_VALID=01` latches A, `10` latches B, and `11` latches both operands.
- An operation runs only when `CE=1`, reset is inactive, and both operands have been latched.
- Outputs are `RES[9:0]`, `COUT`, `OFLOW`, `G`, `E`, `L`, and `ERR`.
- Outputs go to `z` on reset or when there is no result.

## Architecture

The top-level flow is:

```text
top → test → alu_environment
```

The environment contains a generator, driver, monitor, reference model, and scoreboard connected through mailboxes.

- **Driver:** For two-operand commands with partial `INP_VALID`, keeps randomizing for up to 16 cycles while looking for `INP_VALID=11`.
- **Reference model:** Predicts the result and signals the monitor when to sample.
- **Scoreboard:** Compares `RES` and all flags using `===`.
- **Coverage:** Covergroups in the driver cover inputs; covergroups in the monitor cover outputs.
- **Assertions:** `alu_interface.sv` checks reset, the 16-cycle timeout, invalid commands, `INP_VALID=00`, `CE` hold behavior, and result latency.

## Tests

Although `top` creates many tests, it runs only:

1. `test_regression` — 12 back-to-back constrained scenarios
2. `alu_test` — the base transaction
3. `test17` (`MUL_ONLY`)

To run another test, edit the `initial` block in `alu_testbench.sv`. The testbench does not provide a plusarg for test selection.

## Known Limitations

- The reference model follows the macro names in `defines.sv`, but the RTL behaves differently for several commands. The scoreboard therefore reports mismatches. Examples include arithmetic commands 4, 6, 7, and 10, and logical commands 2 and 8–13.
- Invalid commands leave DUT `ERR` at `z`, while the assertions and reference model expect `1`.
- Multiply commands use nonblocking updates of temporary registers, so their results lag behind the inputs.
- `alu_transaction.RES` is 9 bits wide, while the interface `RES` is 10 bits wide.
- The driver generates many warnings about reading clocking-block outputs.
- `Project_ALU_2.0_Document.pdf` is included but is not summarized here.
