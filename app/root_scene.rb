class RootScene
    attr_gtk

    def initialize args
        @args = args
        precalculate_gradient

        state.camera = {
            x: 0, y: 0,
            target_x: 0, target_y: 0,
            target_scale: 1,
            scale: 1
        }

        state.player = {
            x: 0, y: 0,
            w: 16, h: 16,
            dx: 0, dy: 0,
            on_ground: true
        }
    end

    def precalculate_gradient
        @gradient = 80.map_with_index do |y|
            {x: 0, y: y * 5, w: 1500, h: 15, r: 255, g: 64, b: 128, a: (y * 5).fdiv(255) * 255}.solid!
        end
        @args.render_target(:gradient).solids << @gradient
    end

    def calc_camera
        state.camera.target_x = state.player[:x]
        state.camera.target_y = state.player[:y]

        ease = 0.1
        state.camera.scale += (state.camera.target_scale - state.camera.scale) * ease
        state.camera.x += (state.camera.target_x - state.camera.x) * ease
        state.camera.y += (state.camera.target_y - state.camera.y) * ease
    end

    def draw_background
        parallax_offset = state.offset * 0.05

        out = []
        out << {x: 0, y: 0, w: 1280, h: 720, r: 0, g: 0, b: 0}.solid!
        out << {x: 0, y: 0, w: 1500, h: 1500, :path => :gradient}.sprite!

        radius = 19200
        angle_from = -(state.offset / radius) - Math::PI / 2
        angle_to   =  (state.offset / radius) + Math::PI / 2

        angle_from.step(angle_to, Math::PI / 240) do |a|
            next if Math.cos(a) < 0
            x = 640 + (radius * Math.sin(a))
            out << {x: x, y: 0, x2: 640, y2: 480,r: 64, g: 64, b: 64}.line!
        end

        out << {x: 0, y: 410, w: 1280, h: 320,r: 0, g: 0, b: 0}.solid!

        outputs.primitives << out
    end

    def player_prefab
        player = state.player
        prefab = Camera.to_screen_space state.camera, (player.merge path: "sprites/1-bit-platformer/0280.png").sprite!

        if !player.on_ground
            prefab.merge! path: "sprites/1-bit-platformer/0284.png"
            if player.dx > 0
                prefab.merge! flip_horizontally: false
            elsif player.dx < 0
                prefab.merge! flip_horizontally: true
            end
        elsif player.dx > 0
            frame_index = 0.frame_index 3, 5, true
            prefab.merge! path: "sprites/1-bit-platformer/028#{frame_index + 1}.png"
        elsif player.dx < 0
            frame_index = 0.frame_index 3, 5, true
            prefab.merge! path: "sprites/1-bit-platformer/028#{frame_index + 1}.png", flip_horizontally: true
        end

        prefab
    end


    def tick

        if inputs.keyboard.left
            state.player.dx = -3
        elsif inputs.keyboard.right
            state.player.dx = 3
        end

        if inputs.keyboard.key_down.space && state.player.on_ground
            state.player.dy = 10
            state.player.on_ground = false
        end
        # @args.state.offset += @args.inputs.left_right * 2
        calc_camera

        draw_background

        outputs[:scene].transient!
        outputs[:scene].w = 1500
        outputs[:scene].h = 1500
        outputs[:scene].background_color = [0, 0, 0, 0]

        outputs[:scene].primitives << player_prefab

        outputs.primitives << Camera.viewport.merge(path: :scene, primitive_marker: :sprite)

    end


end
