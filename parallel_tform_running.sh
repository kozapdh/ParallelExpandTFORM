#!/usr/bin/env bash
start=$(date +%s)

set -euo pipefail

# ----------CONFIGURATION----------
NUM_EQ=${1}                   # Number of equations
FORM_DIR="${2}"               # Directory with form_script.frm and .frm files
WKB_SUBDIR="${3}"             # Directory to files: standardEquation_*.frm, expandedEquation_*.m and logs per equation
MAX_JOBS=12                   # Maximum number of TFORM processes running in parallel
THREADS_PER_EQ=1              # Threads per single TFORM process
FORM_BIN="tform"              # Directory to TFORM binaries
# -----------------------------------

cd "$FORM_DIR" || { echo "Cannot go into $FORM_DIR"; exit 1; }

# Check if TFORM is available.
if ! command -v "$FORM_BIN" >/dev/null 2>&1; then
  echo "Error: $FORM_BIN not found. Set directory to tform binary ."
  exit 2
fi

# Create directory for standardEquation_*.frm, expandedEquation_*.m and log files.
mkdir -p "$WKB_SUBDIR"

# Safety:
CPUS=$(nproc)
echo "CPU cores: $CPUS. MAX_JOBS=$MAX_JOBS THREADS_PER_EQ=$THREADS_PER_EQ."
if (( MAX_JOBS * THREADS_PER_EQ > CPUS )); then
  echo "Attetntion: MAX_JOBS * THREADS_PER_EQ > number of threads used in this iteration!"
fi

# Function used to run TFORM for each equation. 
run_eq() {
  local i=$1
  local logfile="${FORM_DIR}${WKB_SUBDIR}log_eq${i}.txt"
  "$FORM_BIN" -w"$THREADS_PER_EQ" -D eqNum="$i" -D FORM_DIR="${FORM_DIR}" -D WKB_SUBDIR="${WKB_SUBDIR}" tform_script.frm > "$logfile" 2>&1
  local rc=$?
  if [ $rc -ne 0 ]; then
    echo "❌ Eq${i} with error code $rc (see $logfile)"
  fi
}

export -f run_eq
export FORM_BIN THREADS_PER_EQ FORM_DIR WKB_SUBDIR

# Parallel running in bash.
seq 1 "$NUM_EQ" | xargs -n1 -P "$MAX_JOBS" -I{} bash -c 'run_eq "$@"' _ {}

end=$(date +%s)
runtime=$((end - start))
echo "$(date): Execution time: ${runtime}s" >> ${FORM_DIR}exec_tform_script_time.txt 
echo -e "$(date): Execution time: ${runtime}s.\nAll equations have been expanded in this iteration if there is no errors in log files."

