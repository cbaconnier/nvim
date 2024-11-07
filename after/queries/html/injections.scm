;; extends

; AlpineJS attributes
(attribute
  (attribute_name) @_attr
  (#lua-match? @_attr "^x%-%l")
  (#not-any-of? @_attr 
    "x-ref"
    "x-teleport"
    "x-transition"
    "x-transition:enter"
    "x-transition:enter-start"
    "x-transition:enter-end"
    "x-transition:leave"
    "x-transition:leave-start"
    "x-transition:leave-end")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#set! injection.language "javascript"))

; AlpineJS x-bind shorthand
; <div :class="{ 'classname': someJsValue }"></div>
(attribute
  (attribute_name) @_attr
  (#lua-match? @_attr "^@%l")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#set! injection.language "javascript"))

; AlpineJS x-bind shorthand
; <div :class="{ 'classname': someJsValue }"></div>
(attribute
  (attribute_name) @_attr
  (#lua-match? @_attr "^:%l")
  (quoted_attribute_value
    (attribute_value) @injection.content)
  (#set! injection.language "javascript"))

; Blade escaped JS attributes
; <x-foo ::bar="baz" />
(element
  (_
    (tag_name) @_tag
    (#lua-match? @_tag "^x%-%l")
    (attribute
      (attribute_name) @_attr
      (#lua-match? @_attr "^::%l")
      (quoted_attribute_value
        (attribute_value) @injection.content)
      (#set! injection.language "javascript"))))

; Blade PHP attributes
; <x-foo :bar="$baz" />
(element
  (_
    (tag_name) @_tag
    (#lua-match? @_tag "^x%-%l")
    (attribute
      (attribute_name) @_attr
      (#lua-match? @_attr "^:%l")
      (quoted_attribute_value
        (attribute_value) @injection.content)
      (#set! injection.language "php_only"))))
