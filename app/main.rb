
def init args
    args.state.offset = 0
    gradient =
    80.map_with_index do |y|
        {x: 0, y: y * 5, w: 1280, h: 15, r: 255, g: 64, b: 128, a: (y * 5).fdiv(255) * 255}.solid!
    end
    args.render_target(:gradient).solids << gradient
end

def calc args
    out = []
    offset = args.state.offset

    x = -3860
    dx = 48
    while x < 5140 do
        out << {x: x+offset, y: 0, x2: 640+offset, y2: 480, r: 0, g: 0, b: 128}.line!
        x += dx
        if x < 640
            dx += 1
        else
            dx -= 1
        end
    end
    out << {x: 0, y: 410, w: 1280, h: 240, r: 0, g: 0, b: 0}.solid!
end

def tick args
    if Kernel.tick_count == 0
        init args
    end
    out = calc args

    args.state.offset += 1

    args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0}.solid!
    args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, :path => :gradient}.sprite!
    args.outputs.primitives << out

end
