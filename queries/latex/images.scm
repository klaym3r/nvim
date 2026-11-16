; Formula previews are opt-in for each Markdown buffer.
((inline_formula) @image.content @image
  (#set! image.ext "math.tex")
  (#math-preview?))

((displayed_equation) @image.content @image
  (#set! image.ext "math.tex")
  (#math-preview?))

((math_environment) @image.content @image
  (#set! image.ext "math.tex")
  (#not-has-ancestor? @image "displayed_equation" "math_environment")
  (#math-preview?))

(graphics_include
  (_ (path) @image.src)
) @image
