
require 'Coat'

class 'Point3D'
extends 'Point'

has.z = {is = 'rw', isa = 'number', default = 0 }

overload.__tostring = function(self)
    return '(' .. self:x() .. ', ' .. self:y() .. ', ' .. self:z() .. ')'
end
