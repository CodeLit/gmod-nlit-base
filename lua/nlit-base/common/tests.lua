--- Test module for writing a unit tests
-- @module nlitTest
module('nlitTest', package.seeall)
local testString = '[TEST FAILED]: '
--- Asserts that two values are equal
function assertIsEqual(self, a, b)
    assert(a == b, testString .. ' Expected ' .. tostring(b) .. ' but got ' .. tostring(a))
end

--- Asserts that the condition is false
function assertIsFalse(self, condition)
    return assert(not condition, testString .. ' Expected false but got ' .. tostring(condition))
end

--- Asserts that the condition is true
function assertIsTrue(self, condition)
    return assert(condition, testString .. ' Expected true but got ' .. tostring(condition))
end

--- Asserts that the value is nil
function assertIsNil(self, value)
    return assert(value == nil, testString .. ' Expected nil but got ' .. tostring(value))
end