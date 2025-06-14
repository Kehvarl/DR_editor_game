class RootScene
    attr_gtk

    def initialize args
        @args = args
        @gradient =
                80.map_with_index do |y|
            {x: 0, y: y * 5, w: 1500, h: 15, r: 255, g: 64, b: 128, a: (y * 5).fdiv(255) * 255}.solid!
        end
        args.render_target(:gradient).solids << @gradient

        args.state.camera ||= {
            x: 750,
            y: 410,
            target_x: 640,
            target_y: 360,
            target_scale: 1,
            scale: 1.0
        }
    end

    def calc_camera
        ease = 0.1
        cam = @args.state.camera
        cam.scale += (cam.target_scale - cam.scale) * ease
        cam.x += (cam.target_x - cam.x) * ease
        cam.y += (cam.target_y - cam.y) * ease
    end

    def calc_bg
        out = []
        radius = 12800
        angle_from = -(@args.state.offset / radius) - Math::PI/2
        angle_to = (@args.state.offset/ radius) + Math::PI/2
        angle_from.step(angle_to, (Math::PI / 180)) do |a|
            next if Math.cos(a) < 0
            x = 750 + (radius * Math.sin(a))
            out << {x: x, y: 0, x2: 750, y2: 750, r: 64, g: 64, b: 64}.line!
        end
        out << {x: 0, y: 700, w: 1500, h: 800, r: 0, g: 0, b: 0}.solid!
        return out
    end


    def tick
        @args.state.offset += @args.inputs.left_right * 2
        calc_camera

        @args.outputs[:scene].transient!
        @args.outputs[:scene].w = 1500
        @args.outputs[:scene].h = 1500
        @args.outputs[:scene].background_color = [0, 0, 0, 0]
        @args.outputs[:scene].primitives << {x: 0, y: 0, w: 1500, h: 1500, :path => :gradient}.sprite!
        @args.outputs[:scene].primitives << calc_bg

        @args.outputs.primitives << { **Camera.viewport, path: :scene }

    end


end
