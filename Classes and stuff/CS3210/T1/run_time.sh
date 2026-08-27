#!/bin/bash
#SBATCH --job-name=bubble_time
#SBATCH --partition=i7-13700
#SBATCH --nodelist=soctf-pdc-033
#SBATCH --exclusive
#SBATCH --output=job_%j.log

# ---- config ----
BIN=./asdf
CSV=results.csv
REPS=10
SIZES=(1000 2000 5000 10000 20000 50000)
MAXVAL=100000
NODE=$(hostname)

# ---- sanity: binary exists and is executable ----
if [[ ! -x "$BIN" ]]; then
    echo "ERROR: $BIN not found or not executable. Compile first:" >&2
    echo "  g++ -O2 -o asdf asdf.cpp" >&2
    exit 1
fi

# ---- CSV header ----
echo "node,size,rep,real_s,user_s,sys_s" > "$CSV"

# ---- sweep ----
for n in "${SIZES[@]}"; do
    for r in $(seq 1 "$REPS"); do
        t=$( /usr/bin/time -f "%e,%U,%S" "$BIN" "$n" "$MAXVAL" 2>&1 >/dev/null )

        # guard against a failed run producing garbage
        if [[ -z "$t" ]]; then
            echo "WARN: empty timing for n=$n rep=$r" >&2
            t="NA,NA,NA"
        fi

        echo "$NODE,$n,$r,$t" >> "$CSV"
    done
    echo "done size=$n" >&2
done

echo "Results written to $CSV" >&2
