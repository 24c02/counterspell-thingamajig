require 'filewatcher'
require 'erb'

def rebuild_erb(source, destination)
  puts "Rebuilding #{source} -> #{destination}"
  erb_template = File.read(source)
  result = ERB.new(erb_template, trim_mode: '>').result
  File.write(destination, result)
  puts "Build completed at #{Time.now}"
rescue SyntaxError, StandardError => e
  puts "Error while rebuilding: #{e.message}"
end

rebuild_erb("index.erb", "build/index.html")

Filewatcher.new(["index.erb", 'levels.yml']).watch do |changes|
  changes.each do |filename, event|
    rebuild_erb("index.erb", "build/index.html")
  end
end