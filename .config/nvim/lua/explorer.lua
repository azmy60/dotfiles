local lib = require("nvim-tree.lib")

local function preview_or_open()
    local node = lib.get_node_at_cursor()
    if node.nodes ~= nil then
        lib.expand_or_collapse(node)
    else
        require('nvim-tree.actions.node.open-file').fn("preview", node.absolute_path)
    end
end

require("nvim-tree").setup({
    view = {
        side = "right",
        mappings = {
            custom_only = false,
            list = {
                { key = "l", action = "edit", action_cb = preview_or_open },
            }
        }
    }
})
