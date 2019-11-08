tmp = open("tmp", "w")
r = "r"
gemspec = open("better_error_message.gemspec", r)
gemspec.read.lines.each do |line|
  if line.include?("s.version")
     if line.include?("1.1.2")
	line = line.gsub("1.1.2", "1.1.1")
     else
 	line = "  s.version = \"1.1.2\"\n"
     end
  end
  tmp.write(line)
end
tmp.close
`cp tmp better_error_message.gemspec`
`rm tmp`
