# 0.3.0 Ideas

* What is benchmarking about? Assess **progress/improvement**. Provide tools to support this.
* Bar charts
* Simplify commands. For example, get rid of "--gnuplot=jpeg | gnuplot > graph.jpg"
* Support for multiple images for multiple benchmarks

# Long-term ideas

* Measure memory consumption. Benchmarks that run the same block 10_000_000 would
  help identifying memory leaks.
* On complete/complex benchmark suites, provide support for statistical
  representativeness: "what benchmark to run now, on which ruby". Should be quite
  easy through Alf queries.
