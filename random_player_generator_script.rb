require "faker"

def generate(player_count)
  player_files = []
  player_count.times do
    player_files.push("#{Faker::Name.first_name.downcase}.txt")
  end
  player_files.each do | file |
    File.open("data/players/#{file}", 'w') do | file |
      5000.times do
        file.write(rand(1..8000))
        file.write("\n")
      end
    end
  end
  puts "Generated #{player_count} players in data/players/"
end

generate(500)
