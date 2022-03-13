local Action = {}

function Action:execute()
  print(vim.inspect(self))
  for number, condition in ipairs(self.conditions) do
    if condition(self) then
      self.actions[number](self)
      return true
    end
  end
end

-- needs left and right inside o to initialize
function Action:new(o)
  local o = o or {}
  self.__index = self
  self.__call = self.execute
  setmetatable(o, self)
  return o
end

return Action
