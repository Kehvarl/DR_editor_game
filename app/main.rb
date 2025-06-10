
def init args
  args.render_target(:gradient).solids <<
    80.map_with_index do |y|
      {x: 0, y: y * 5, w: 1280, h: 15, r: 255, g: 64, b: 128, a: (y * 5).fdiv(255) * 255}.solid!
    end

  x = -3860
  dx = 48
  while x < 5140 do
    args.render_target(:lines).lines << {x: x, y: 0, x2: 640, y2: 410, r: 0, g: 0, b: 128}.line!
    x += dx
    if x < 640
        dx += 1
    else
        dx -= 1
    end
  end
end

def tick args
  if Kernel.tick_count == 0
    init args
  end

  args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0}.solid!
  args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, :path => :gradient}.sprite!
  args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, :path => :lines}.sprite!

end
