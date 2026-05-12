# MIPS Processor

A 32-bit MIPS processor implemented in VHDL across three designs of
increasing sophistication: a single-cycle baseline, a software-scheduled
5-stage pipeline (no hazard hardware), and a hardware-scheduled 5-stage
pipeline with forwarding and hazard detection. Synthesized for the
Altera DE2 FPGA (Cyclone IV E) and validated against the MARS reference
simulator.

## Results

| Design                          | Max Frequency | Notes                                         |
|---------------------------------|---------------|-----------------------------------------------|
| Single-cycle                    | 26.76 MHz     | Critical path: register file → ALU → DMEM → register file (i.e. `lw`) |
| Software-scheduled pipeline     | Not measured  | Intermediate design; superseded by hardware-scheduled in this repo |
| Hardware-scheduled pipeline     | 35.66 MHz     | Critical path: MEM/WB → forwarding → ALU mux → ALU → branch logic → fetch → hazard detection |

Pipelining improved the clock speed by roughly 33% (26.76 → 35.66 MHz)
on top of the throughput gain from instruction-level parallelism. The
Part 1 number is from the original team report (Quartus 21.1 Standard);
the Part 3 number is from a fresh re-synthesis on Quartus 25.1 Lite
Edition.

Supported instructions: `add`, `addi`, `addiu`, `addu`, `and`, `andi`,
`lui`, `lw`, `nor`, `xor`, `xori`, `or`, `ori`, `slt`, `slti`, `sll`,
`srl`, `sra`, `sw`, `sub`, `subu`, `beq`, `bne`, `j`, `jal`, `jr`, plus
the `repl.qb` DSP instruction.

## Test results

The hardware-scheduled pipeline was re-validated against the MARS
reference simulator on Questa 2025.2:

- **Unit tests:** 103 / 105 passing (per-instruction tests across all 12 instruction categories)
- **Team-written hazard/forwarding stress tests:** 3 / 3 passing
- **Project test programs (`Proj2_base_test`, `Proj2_bubblesort`):** 2 / 2 passing
- **Course-provided sanity programs:** 3 / 5 passing

See [Limitations](#limitations) below for the specific failing tests
and their root cause.

## What's in this repo

| Path                                       | Purpose                                              |
|--------------------------------------------|------------------------------------------------------|
| `cpre381-toolflow/proj/src/`               | All VHDL source for the processor                    |
| `cpre381-toolflow/proj/src/MIPS_types.vhd` | Type declarations and global constants               |
| `cpre381-toolflow/proj/src/TopLevel/`      | Top-level processor and memory entities              |
| `cpre381-toolflow/proj/src/ALU/`           | ALU and ALU control logic                            |
| `cpre381-toolflow/proj/src/ControlFlow/`   | Control unit, branch logic, forwarding, hazard detection |
| `cpre381-toolflow/proj/src/PipelineRegisters/` | IF/ID, ID/EX, EX/MEM, MEM/WB pipeline registers  |
| `cpre381-toolflow/proj/src/RegFile/`       | 32×32 register file                                  |
| `cpre381-toolflow/proj/src/Muxes/`         | Parameterized 2:1, 3:1, 4:1, and 32:1 muxes          |
| `cpre381-toolflow/proj/src/FetchLogic/`    | PC update logic                                      |
| `cpre381-toolflow/proj/src/Basic Components/` | Barrel shifter, decoder, n-bit adder, ones-complement, extenders |
| `cpre381-toolflow/proj/src/Provided Components/` | Course-staff-provided gate-level primitives    |
| `cpre381-toolflow/proj/test/`              | VHDL testbenches for individual components           |
| `cpre381-toolflow/proj/mips/`              | MIPS assembly test programs                          |
| `cpre381-toolflow/381_tf.sh`               | Toolflow runner (test, synth, submit modes)          |
| `cpre381-toolflow/config.ini`              | Toolchain path configuration                         |
| `docs/`                                    | Assignment descriptions and control signal tables    |

The repo's current state is the final **hardware-scheduled pipeline**.
Earlier designs (single-cycle, software-scheduled pipeline) are
preserved in git history — see commit log for the progression.

## Project structure

The project was built in three parts over a semester, each building on
the last:

**Part 1 — Single-cycle processor.** Classic textbook single-cycle MIPS
datapath. One instruction completes per cycle; clock period is bounded
by the slowest instruction path (`lw`, which traverses register file →
ALU → data memory → register file). Components include a 32-bit barrel
shifter built from cascaded 2:1 muxes (supporting `srl`, `sra`, and
`sll` with a single right-shift core plus input/output reversal), a
PLA-style control unit, and an ALU controller that decodes both opcode
and funct fields.

**Part 2 — Software-scheduled pipeline.** Same datapath as Part 1, but
split into IF/ID/EX/MEM/WB stages by inserting pipeline registers
between each. No hazard detection, no forwarding, no stalling — the
assembler is responsible for inserting NOPs or reordering instructions
to avoid hazards. The BubbleSort program from Part 1 was hand-scheduled
to run correctly here. Branch condition logic was moved to the ID stage
to keep the branch penalty low.

**Part 3 — Hardware-scheduled pipeline.** Adds an EX-stage forwarding
unit (EX→EX and MEM→EX bypass for ALU operations), a separate
ID-stage forwarding unit for branch operands, a store-data forwarding
unit, hazard detection for control-flow flushes, and modifies the
register file to forward writes to concurrent reads.

## Test programs

The `proj/mips/` directory is organized by phase:

- `GivenTests/` — Course-provided sanity programs (addi sequences, simple branches, Fibonacci, etc.)
- `UnitTests/` — ~105 small programs covering each instruction (add, and, branch, jump, load, nor, or, shift, slt, store, sub, xor)
- `Proj1Tests/` — Single-cycle test suite (base test, control-flow test with call depth ≥ 5, BubbleSort)
- `Proj2Tests/` — Hazard/forwarding stress tests for the pipelined designs
- `Proj2_bubblesort.s`, `Proj2_base_test.s` — Top-level Part 2/3 tests

## Running the project

The processor uses the CprE 381 toolflow, which wraps a simulator
(ModelSim or Questa) and Quartus Prime for synthesis. **You'll need
both tools installed locally to run this.** See
`cpre381-toolflow/cpre381-toolflow.pdf` for the full toolflow manual.

### Setup

Edit `cpre381-toolflow/config.ini` to add a configuration section
pointing at your local Quartus and simulator installations. For
example, on Linux with Quartus Lite 25.1:

```ini
[MyConfig]
modelsim_paths = ["/home/user/altera_lite/25.1std/questa_fse/bin"]
quartus_paths  = ["/home/user/altera_lite/25.1std/quartus/linux64"]
needs_license  = "false"
```

You may also need to set environment variables for Quartus and Questa:

```bash
export LD_LIBRARY_PATH=/path/to/quartus/linux64:$LD_LIBRARY_PATH
export QUARTUS_ROOTDIR_OVERRIDE=/path/to/quartus
export SALT_LICENSE_SERVER=/path/to/questa-license.dat
```

### Simulate a test program

From the `cpre381-toolflow/` directory:

```bash
./381_tf.sh test -c MyConfig proj/mips/GivenTests/addiseq.s
```

This compiles the VHDL, assembles the MIPS program in MARS, runs both
MARS and the Questa simulation of the processor, and diffs the register
and memory writes.

To run every test program in a directory:

```bash
./381_tf.sh test -c MyConfig -s proj/mips/UnitTests/*/*.s
```

### Synthesize for the DE2 FPGA

```bash
./381_tf.sh synth -c MyConfig
```

Synthesis takes a few minutes on a modern machine. The timing report and
critical path summary land in `cpre381-toolflow/temp/timing.txt`.

## Limitations

A handful of tests fail. The failures are documented in the original
commit history (e.g. *"Only 2 unit tests have errors in execution.
bne_1 and jr_2"* and *"Fixed bugs. Added Forwarding for Store
instructions. All tests pass except Jumps and Branches"*), so these are
known gaps from the original course submission rather than regressions
in the toolchain.

**Failing tests:**

- `proj/mips/UnitTests/branch/bne_1.s` — bne where both operands are equal (branch should not be taken) after back-to-back loads
- `proj/mips/UnitTests/jump/jr_2.s` — jr where the target register was written by the immediately preceding instruction
- `proj/mips/GivenTests/fibonacci.s` — exercises the same patterns
- `proj/mips/GivenTests/grendel.s` — exercises the same patterns
- `proj/mips/Proj1Tests/Proj1_base_test.s` — load followed immediately by use
- `proj/mips/Proj1Tests/Proj1_bubblesort.s` — exercises the same patterns

**Root cause:** the ID-stage branch forwarding unit
(`proj/src/ControlFlow/branch_forwarding.vhd`) is guarded by
`ALUOp = "01"` (branch encoding), so it never activates for jump-register
instructions. Additionally, when a branch reads a register that was
just produced by a load still in EX, the forwarded value is the load's
address calculation rather than the loaded data, which would require a
stall the unit doesn't produce.

A fix would extend `branch_forwarding` to (a) also activate for `jr`,
and (b) detect the load-then-branch case and assert a stall rather than
forward stale data. This is left unfixed to preserve the original
project's submitted state.

## Acknowledgments

Course project for CprE 381 — Computer Organization and Assembly Level
Programming at Iowa State University. Completed by a team of 2;
contributions are visible in the commit history.

The toolflow framework and project structure were provided by the
course staff. Parts of the assignment descriptions were originally
created by Dr. Joe Zambreno.

## License

MIT
