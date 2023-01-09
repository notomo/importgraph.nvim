local helper = require("importgraph.test.helper")
local importgraph = helper.require("importgraph")

describe("render()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns graph including orphan node", function()
    helper.install_parser("lua")

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
    assert.equals([=[[importgraph] not found renderer: invalid]=], got)
  end)
end)
