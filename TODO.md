# Must have for 0.2.0

* Release alf 0.10.1
* Add 'viiite --pattern=GLOB' (defaults to 'bench_*.rb'), adding support in BDB options

# Long-term ideas

* Measure memory consumption. Benchmarks that run the same block 10_000_000 would
  help identifying memory leaks.
* On complete/complex benchmark suites, provide support for statistical
  representativeness: "what benchmark to run now, on which ruby". Should be quite
  easy through Alf queries.
