#!/bin/bash
#SBATCH --job-name=bubble_maxval
#SBATCH --partition=i7-13700
#SBATCH --nodelist=soctf-pdc-033
#SBATCH --exclusive
#SBATCH --output=job_%j.log

# ---- config ----
BIN=./asdf
CSV=results_maxval.csv
REPS=10
FIXED_N=20000                       # hold array size constant
MAXVALS=(10 100 1000 10000 100000 1000000)   # sweep max_value across orders of magnitude
NODE=$(hostname)

if [[ ! -x "$BIN" ]]; then
    echo "ERROR: $BIN not found. Compile: g++ -O2 -o asdf asdf.cpp" >&2
    exit 1
fi

echo "node,size,max_value,rep,real_s,user_s,sys_s" > "$CSV"

for mv in "${MAXVALS[@]}"; do
    for r in $(seq 1 "$REPS"); do
        t=$( /usr/bin/time -f "%e,%U,%S" "$BIN" "$FIXED_N" "$mv" 2>&1 >/dev/null )
        [[ -z "$t" ]] && t="NA,NA,NA"
        echo "$NODE,$FIXED_N,$mv,$r,$t" >> "$CSV"
    done
    echo "done max_value=$mv" >&2
done

echo "Results written to $CSV" >&2
