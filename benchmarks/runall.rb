require 'fileutils'

folder = File.expand_path('..', __FILE__)
Dir[File.join(folder, "**/bench_*.rb")].each do |file|
  name = File.basename(file, '.rb')
  base = file[(1+folder.size)..-(4+name.size)]
  rash = File.join(folder, ".raw", base, "#{name}.rash")

  FileUtils.mkdir_p(File.dirname(rash))

  puts "Running #{name} -> #{rash}"
  `rvm exec viiite run #{file} > #{rash}`
end
