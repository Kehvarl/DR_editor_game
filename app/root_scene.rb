class RootScene
    attr_gtk

    def initialize args
        @args = args
        @gradient =
                80.map_with_index do |y|
            {x: 0, y: y * 5, w: 1280, h: 15, r: 255, g: 64, b: 128, a: (y * 5).fdiv(255) * 255}.solid!
        end
        args.render_target(:gradient).solids << @gradient
    end

    def calc_bg
        out = []
        radius = 19200
        angle_from = -(@args.state.offset / radius) - Math::PI/2
        angle_to = (@args.state.offset/ radius) + Math::PI/2
        angle_from.step(angle_to, (Math::PI / 360)) do |a|
            next if Math.cos(a) < 0
            x = 640 + (radius * Math.sin(a))
            out << {x: x, y: 0, x2: 640, y2: 480, r: 64, g: 64, b: 64}.line!
        end
        out << {x: 0, y: 410, w: 1280, h: 320, r: 0, g: 0, b: 0}.solid!
        return out
    end


    def tick
        @args.state.offset += @args.inputs.left_right * 2

        @args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0}.solid!
        @args.outputs.primitives << {x: 0, y: 0, w: 1280, h: 720, :path => :gradient}.sprite!
        @args.outputs.primitives << calc_bg
    end

end
