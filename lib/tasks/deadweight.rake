begin
  require 'deadweight'
rescue LoadError
end
desc "run Deadweight (requires script/server)"
task :deadweight do
  dw = Deadweight.new
  dw.stylesheets = ['/stylesheets/application.css']
  dw.pages = ['/']
  puts dw.run
end
