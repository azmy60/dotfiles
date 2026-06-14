;extends

; query
(
  (comment) @html.comment
  .
  (template_string) @injection.content
  (#match? @html.comment "^/\\*\\s*[hH][tT][mM][lL]\\s*\\*/")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.language "html")
  (#set! injection.combined)
)
