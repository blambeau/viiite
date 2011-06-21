bundle exec ../../bin/bench plot attr.rash  --style=style.rash --gnuplot=pdf -x runs -y real -g ruby_version -s test | gnuplot > attr-variants.pdf
bundle exec ../../bin/bench plot attr.rash  --style=style.rash --gnuplot=pdf -x runs -y real -s ruby_version -g test | gnuplot  > attr-rubies.pdf
bundle exec ../../bin/bench plot yield.rash --style=style.rash --gnuplot=pdf -x runs -y real -g ruby_version -s test | gnuplot  > yield-variants.pdf
bundle exec ../../bin/bench plot yield.rash --style=style.rash --gnuplot=pdf -x runs -y real -s ruby_version -g test | gnuplot  > yield-rubies.pdf