require "faker"

def generate(people_count)
  people_files = []
  people_count.times do
    people_files.push("#{Faker::Name.first_name.downcase}-#{Faker::Name.last_name.downcase}-id-#{rand(20000)}.txt")
  end
  people_files.each do | file |
    File.open("data/people/#{file}", 'w') do | file |
      5000.times do
        file.write(rand(1..8000))
        file.write("\n")
      end
    end
  end
  puts "Generated #{people_count} files in data/people/"
end

generate(20000)
