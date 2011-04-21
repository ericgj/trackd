
require 'json/pure'

class Struct

  def to_h
    self.members.inject({}) do |memo, m| 
      memo[m.to_sym] = self[m.to_sym]; memo
    end
  end

  # for json-encoding without class name
  def to_json(*a)
    self.to_h.to_json(*a)
  end

end
