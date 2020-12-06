#!/Users/johnb/.asdf/shims/ruby

date = ARGV.first
`touch lib/mix/tasks/d#{date}.example.txt`
`touch lib/mix/tasks/d#{date}.input.txt`

def rewrite(part, dd)
  inputs = "#input = File.read!('lib/mix/tasks/d#{dd}.example.txt')
    input = File.read!('lib/mix/tasks/d#{dd}.input.txt')"
  p1 = "lib/mix/tasks/d#{dd}.#{part}.ex"
  file = File.read(p1).gsub("input = nil", inputs)
  File.open(p1, 'w') { |f| f.write(file) }
end

rewrite("p1", date)
rewrite("p2", date)