require 'date'

files = Dir['*.csv']

files.each do |input|
 	File.open("Updated/#{input}", 'w') do |output|
		lines = File.readlines(input)
		output.write(lines.shift)
		lines.reverse!
	
		start_date = Date.parse(lines.first.split(',').first)
		end_date = Date.parse(lines.last.split(',').first)

		prev_values = []
		(start_date..end_date).each do |date|
			if lines.first.split(',').first == date.to_s
				prev_values = lines.first.split(',')
				prev_values.shift
				output.write(lines.shift)
			else
				output.write("#{date.to_s},#{prev_values.join(',')}")
			end
		end
	end
end
