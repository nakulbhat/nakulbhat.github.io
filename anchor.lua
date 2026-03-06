-- vimtags.lua
local function ensure_id(el)
  if el.identifier == "" then
    el.identifier = pandoc.utils.slugify(
      pandoc.utils.stringify(el.content)
    )
  end
end

function Header(el)
  ensure_id(el)
  local id = el.identifier

  -- Wrap heading text and tag in a container
  local open = pandoc.RawInline(
    "html",
    '<span class="heading-text">'
  )

  local close = pandoc.RawInline(
    "html",
    '</span>'
  )

  local tag = pandoc.RawInline(
    "html",
    string.format(
      '<a class="heading-tag" href="#%s">%s</a>',
      id,
      id
    )
  )

  -- New content: text wrapped + tag appended
  local new_content = {}
  table.insert(new_content, open)
  for _, inline in ipairs(el.content) do
    table.insert(new_content, inline)
  end
  table.insert(new_content, close)
  table.insert(new_content, tag)

  el.content = new_content
  return el
end
