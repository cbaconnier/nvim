local php_utils = require "custom.utils.php"

local source = {}

source.new = function(opts)
  local self = setmetatable({}, { __index = source })
  self.opts = opts or {}
  return self
end

function source:enabled()
  return vim.bo.filetype == "php"
end

function source:get_trigger_characters()
  return { " " }
end

function source:get_completions(ctx, callback)
  local line = ctx.line

  -- Handle namespace completion
  if line:match "^namespace%s+" then
    local namespace = php_utils.get_php_namespace()

    local items = {
      {
        label = namespace,
        insertText = namespace,
        kind = require("blink.cmp.types").CompletionItemKind.Text,
        documentation = "Generated namespace from file path",
      },
    }

    callback {
      items = items,
      is_incomplete_backward = false,
      is_incomplete_forward = false,
    }
    return
  end

  -- Handle class/trait/interface/enum completion
  if line:match "^class%s+" or line:match "^trait%s+" or line:match "^interface%s+" or line:match "^enum%s+" then
    local class_name = php_utils.get_php_class_name()

    local items = {
      {
        label = class_name,
        insertText = class_name,
        kind = require("blink.cmp.types").CompletionItemKind.Class,
        documentation = "Generated class name from filename",
      },
    }

    callback {
      items = items,
      is_incomplete_backward = false,
      is_incomplete_forward = false,
    }
    return
  end

  -- If no matches, return an empty list
  callback {
    items = {},
    is_incomplete_backward = false,
    is_incomplete_forward = false,
  }
end

return source
