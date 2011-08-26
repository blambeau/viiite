# 0.2.0

## Awesome new features

* Viiite is now able to work on complete benchmark suites (located in 
  './benchmarks' and looking for 'bench_*.rb' files by default). Subcommands 
  automatically resolve benchmark names passed as arguments. For example:

    ./benchmarks/
      bench_iteration.rb     -> viiite run bench_iteration
      Array/
        bench_sort.rb        -> viiite run Array/bench_sort

* Default behavior remains compatible with 0.1.0: 
  * 'run', 'plot' and 'report' accept a benchmark file as first argument and 
    bypass the benchmark suite in this case. 
  * when invoked without any argument, 'plot' and 'report' assume a .rash stream 
    on standard input

* For each benchmark, the results of the last run are saved in a cache. 'plot' 
  and 'report' will use data in the cache if available or automatically run the
  benchmark. 

* The default behavior may be controlled through the following main options:
  --db=[FOLDER], --[no-]cache=[FOLDER], --append, --write. Example:

    # Run all benchmarks on all rubies, 10 times each, appending all results
    # in cache
    rvm exec viiite --append run --runs=10

## Enhancements to individual commands

* 'viiite run'

  * Added a --runs=NB option to run the same benchmark NB times. This allows
    keeping benchmarks clean; no NB.times{ ... } or range_over(1..NB, :run) 
    for obtaining a representative sample are needed in the benchmark itself.
  * The previous option comes hand-in-hand with --run-key=KEY that allows 
    specifying the attribute name for the run number (defaults to :run)
  * Without argument, runs all the benchmarks of the suite

* 'viiite plot'

  * Added --highcharts options; outputs a json array containing one hash for 
    each chart, to be used as options Highcharts.Chart(...) (cfr. highcharts.js)
  * Added -d option, to debug; outputs the query result that would be used by 
    the concrete --xxx formatter.

* 'viiite report'

  * output has been improved: user, system, total and real time are explicitely 
    shown (different attributes/columns instead of one tms measure).
  * added a '--ff=FORMAT' option for float format of the different measures 
    (defaults to %.6f)
  * added a '--stddev=[MEASURE]' option for displaying standard deviation over 
    all regrouped runs (on a specific measure defaulting to tms.total)

## Other improvements

  * The garbage collector is started before running report{ ... } blocks
  * Viiite does not depend on benchmark (stdlib) anymore (eregon)
  * Improved Viiite.which_ruby; it should always output something like 
    '#{rubyname} #{version}#{patchlevel}' from now on (eregon)

## Bug fixes

* Fixed a bug when using 'viiite report --regroup=x,y,z --hierarchy' with more
  than 2 regrouping attributes.


# 0.1.0 / 2011-08-20

* Enhancements

  * Birthday!
