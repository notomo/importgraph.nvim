local helper = require("importgraph.test.helper")
local importgraph = helper.require("importgraph")

describe("render()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns graph text", function()
    helper.install_parser("lua")

    helper.new_file(
      "node1.lua",
      [[
require("node2")
return require("node3")
]]
    )
    helper.new_file(
      "node2.lua",
      [[
return require("other")
]]
    )

    local graph = importgraph.render({
      collector = { working_dir = helper.test_data_dir },
    })
    assert.equal(
      [[
graph TB
  node1 --> node2
  node1 --> node3
  node2 --> other]],
      graph
    )
  end)
end)
