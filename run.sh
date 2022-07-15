#!/usr/bin/env bash

PATH=./tools:$PATH

ezsmt2=./bin/ezsmt2
ezsmt3=./bin/ezsmt3

# output_dir=./output
benchmarks_dir=./benchmarks


# Set EZSMTPLUS context
EZSMTPLUS=.

# rm -rf $output_dir
# mkdir $output_dir
# ln -s "../tools" $output_dir/tools


run_command() {
    local command="$1"

    echo "Running $command:"
    (ulimit -v 4000000; (timeout 5m time $command)) # &> $output_dir/$(basename $program).out)

    # for program in $(ls $test_glob); do
    # echo "Running $command:"
    # (ulimit -v 4000000; (timeout 5m time $command $program)) # &> $output_dir/$(basename $program).out)
    # done

    echo "==========================================================================================="
    echo ""
}

run_ezsmt2_file_glob() {
    ln -s gringo-4.5.3 ./tools/gringo

    local file_glob="$1"
    for program in $(ls $file_glob); do
        run_command "$ezsmt2 -file $program 0 -cvc4"
    done

    rm ./tools/gringo
    rm ./SMT*
    rm ./Model*
    rm ./dimacs-completion*
}

run_ezsmt2_suite() {
    ln -s gringo-4.5.3 ./tools/gringo

    local base_dir="$1"
    for instance in $(ls $base_dir/instances); do
        run_command "$ezsmt2 -file $base_dir/encodings/encoding.ez -file $base_dir/instances/$instance -cvc4"
        break
    done

    rm ./tools/gringo
}

run_ezsmt3_file_glob() {
    ln -s gringo-5.5.1 ./tools/gringo

    local file_glob="$1"
    for program in $(ls $file_glob); do
        run_command "$ezsmt3 $program -s cvc4 -e"
    done

    rm ./tools/gringo
}

run_ezsmt3_suite() {
    ln -s gringo-5.5.1 ./tools/gringo
    # pushd output

    local base_dir="$1"
    for instance in $(ls $base_dir/instances); do
        cat $base_dir/encodings/encoding.lp > temp.lp
        cat $base_dir/instances/$instance >> temp.lp
        run_command "$ezsmt3 temp.lp -s cvc4"
        break
    done

    # popd
    rm ./tools/gringo
}

# run_ezsmt2_file_glob "$benchmarks_dir/ex1/*.ez"
# run_ezsmt2_file_glob "$benchmarks_dir/toast/*.ez"
run_ezsmt2_suite "$benchmarks_dir/still-live"

# run_ezsmt3_file_glob "$benchmarks_dir/ex1/*.lp"
# run_ezsmt3_file_glob "$benchmarks_dir/toast/*.lp"
run_ezsmt3_suite "$benchmarks_dir/still-live"
