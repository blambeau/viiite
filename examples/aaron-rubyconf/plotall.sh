bundle exec ../../bin/bench plot attr.rash --style=style.rash --pdf -x runs -y real -g ruby_version -s test > attr-variants.pdf
bundle exec ../../bin/bench plot attr.rash --style=style.rash --pdf -x runs -y real -s ruby_version -g test > attr-rubies.pdf
bundle exec ../../bin/bench plot yield.rash --style=style.rash --pdf -x runs -y real -g ruby_version -s test > yield-variants.pdf
bundle exec ../../bin/bench plot yield.rash --style=style.rash --pdf -x runs -y real -s ruby_version -g test > yield-rubies.pdf