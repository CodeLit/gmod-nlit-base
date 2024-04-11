--- Test module for writing a unit tests
-- @module nlitTest
module('nlitTest', package.seeall)


local testString = '[TEST FAILED]: '

--- Asserts that two values are equal
function assertIsEqual(a, b)
    assert(a == b, testString.. ' Expected ' .. tostring(a) .. ' but got ' .. tostring(b))
end

--- Asserts that the condition is false
function assertIsFalse(condition)
    return assert(not condition, testString.. ' Expected false but got ' .. tostring(condition))
end

--- Asserts that the condition is true
function assertIsTrue(condition)
    return assert(condition, testString.. ' Expected true but got ' .. tostring(condition))
end

--- Asserts that the value is nil
function assertIsNil(value)
    return assert(value == nil, testString.. ' Expected nil but got ' .. tostring(value))
end