---
layout: default
title: Benchmark suites
---
# Benchmark suites

Viiite can now run an entire benchmark suite, such as the one in [viiite/benchmarks](https://github.com/blambeau/viiite/tree/master/benchmarks):

    $ viiite run # run the benchmark suite in benchmarks/

Also, individual benchmarks files can now be passed by name:

    ./benchmarks/
      iteration.rb     -> viiite run iteration
      Array/
        sort.rb        -> viiite run Array/sort

And results are automatically saved by benchmark in the cache.
Viiite automatically use cached files if available:

    $ viiite report iteration -h --regroup=size,bench
    # immediate if cached
    +---------+--------------------------------------------------------+
    | :size   | :measure                                               |
    +---------+--------------------------------------------------------+
    | 1000000 | +--------+----------+----------+----------+----------+ |
    |         | | :bench | :user    | :system  | :total   | :real    | |
    |         | +--------+----------+----------+----------+----------+ |
    |         | | :for   | 0.330000 | 0.000000 | 0.330000 | 0.334054 | |
    |         | | :times | 0.330000 | 0.000000 | 0.330000 | 0.330307 | |
    |         | | :upto  | 0.330000 | 0.000000 | 0.330000 | 0.329415 | |
    |         | +--------+----------+----------+----------+----------+ |
    +---------+--------------------------------------------------------+

Of course, they are plenty of options to customize this behavior:

    $ viiite -h
    
    viiite - Benchmark ruby scripts the easy way
    [...]
        --suite=FOLDER         Specify the folder of the benchmark suite (defaults to 'benchmarks')
        --pattern=GLOB         Specify the pattern to find benchmarks in the suite folder (defaults to '**/*.rb')
        --[no-]cache=[FOLDER]  Specify the cache heuristic and folder (defaults to --cache)
        --cache-mode=MODE      Specify the exact mode for accessing cache files
    -a, --append               Shortcut to --cache-mode=a
    -w, --write                Shortcut to --cache-mode=w
    [...]

While we are talking of good stuff, `viiite run` now accepts a `--runs=NB` option, which runs `NB` times the benchmark as you would expect:

    $ viiite --append run --runs=10 iteration
    $ viiite report iteration -h --regroup=size,bench
    +---------+--------------------------------------------------------+
    | :size   | :measure                                               |
    +---------+--------------------------------------------------------+
    | 1000000 | +--------+----------+----------+----------+----------+ |
    |         | | :bench | :user    | :system  | :total   | :real    | |
    |         | +--------+----------+----------+----------+----------+ |
    |         | | :for   | 0.333636 | 0.000000 | 0.333636 | 0.338368 | |
    |         | | :times | 0.324545 | 0.000909 | 0.325455 | 0.328430 | |
    |         | | :upto  | 0.328182 | 0.000000 | 0.328182 | 0.330876 | |
    |         | +--------+----------+----------+----------+----------+ |
    +---------+--------------------------------------------------------+

By default, `viiite report` will average timing measures over all runs. This helps reaching a better statistical representativeness.

[Tell us](https://github.com/blambeau/viiite) what you think about these new viiite 0.2.0 features!

[@eregon](https://github.com/eregon)
