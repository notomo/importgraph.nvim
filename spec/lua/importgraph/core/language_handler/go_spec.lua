local helper = require("importgraph.test.helper")
local importgraph = helper.require("importgraph")

describe("render() with go", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns graph text", function()
    helper.install_parser("go")

    helper.test_data:create_file(
      "go.mod",
      [[
module github.com/notomo/importgraph

go 1.19
]]
    )
    helper.test_data:create_file(
      "main.go",
      [[
package main

import (
	"github.com/notomo/importgraph/sub"
)
]]
    )
    helper.test_data:create_file(
      "sub/a.go",
      [[
package sub
]]
    )

    local graph = importgraph.render("go", {
      collector = {
        working_dir = helper.test_data.full_path,
      },
    })
    assert.equal(
      [[
graph TB
  1(github.com/notomo/importgraph) --> 2(github.com/notomo/importgraph/sub)
  2(github.com/notomo/importgraph/sub)]],
      graph
    )
  end)
end)
