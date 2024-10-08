local helper = require("importgraph.test.helper")
local importgraph = helper.require("importgraph")
local assert = require("assertlib").typed(assert)

describe("render()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns graph including orphan node", function()
    helper.test_data:create_file(
      "node1.lua",
      [[
return "test"
]]
    )

    local graph = importgraph.render("lua", {
      collector = { working_dir = helper.test_data.full_path },
    })
    assert.equal(
      [[
graph TB
  1(node1)]],
      graph
    )
  end)

  it("raises error if renderer is not found", function()
    local ok, got = pcall(function()
      importgraph.render("lua", {
        renderer = { name = "invalid" },
      })
    end)
    assert.is_false(ok)
    assert.equal([=[[importgraph] not found renderer: invalid]=], got)
  end)

  it("can pass renderer specific option", function()
    helper.test_data:create_file(
      "node1.lua",
      [[
require("node2")
]]
    )
    helper.test_data:create_file("node2.lua")

    local graph = importgraph.render("lua", {
      renderer = {
        opts = {
          direction = "LR",
        },
      },
      collector = { working_dir = helper.test_data.full_path },
    })

    assert.match("^graph LR", graph)
  end)
end)
