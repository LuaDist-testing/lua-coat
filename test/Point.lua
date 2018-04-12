
require 'Coat'

class 'Point'

has.x = { is = 'rw', isa = 'number', default = 0 }
has.y = { is = 'rw', isa = 'number', default = 0 }

overload.__tostring = function (self)
    return '(' .. self:x() .. ', ' .. self:y() .. ')'
end

method.draw = function (self)
    return "drawing " .. self._CLASS .. tostring(self)
end
