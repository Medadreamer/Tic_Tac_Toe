class Players
    attr_reader :username, :weapon
  def initialize(username, weapon)
    @username = username
    @weapon = weapon
  end
end

player = Players.new("Perzival", "X")
puts player.username
puts player.weapon