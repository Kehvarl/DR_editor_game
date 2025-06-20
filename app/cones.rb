GRAVITY = -0.2
MAX_FALL_SPEED = -5.0
JUMP_VELOCITY = 4.0
BOUNCE_VELOCITY = 6.0
FAST_FALL_GRAVITY = -0.4

def init args
  args.state.player = {
    x: 640,
    y: 160,
    w: 32,
    h: 32,
    anchor_x: 0.5,
    dx: 0,
    dy: 1,
    vy: 0,
    path: 'sprites/square/red.png'
  }
end

def cone args
    out = []
    radius = 960
    angle_from = -(args.state.player.x / radius) - Math::PI/2
    angle_to = (args.state.player.x / radius) + Math::PI/2
    angle_from.step(angle_to, (Math::PI / 36)) do |a|
        next if Math.cos(a) < 0
        x = 640 + (radius * Math.sin(a))
        out << {x: x, y: 0, x2: 640, y2: 360, r: 64, g: 64, b: 64}.line!
        out << {x: x, y: 720, x2: 640, y2: 360, r: 64, g: 64, b: 64}.line!

    end
    return out
end


def tick args
  if Kernel.tick_count == 0
    init args
  end

  args.state.player.dx = args.inputs.left_right * 2
  args.state.player.dy = args.inputs.up_down * 2

  #if args.state.player.dy > 0 and args.state.player.y >= 480
  #    args.state.player.dy = -1
  #elsif args.state.player.dy < 0 and args.state.player.y <= 1
  #    args.state.player.dy = 1
  #end

  if args.state.player.x + args.state.player.dx >= (1280 - 16) or
          args.state.player.x + args.state.player.dx <= 16
      args.state.player.dx = 0
  end

  if args.state.player.y + args.state.player.dy >= (480-32) or
          args.state.player.y + args.state.player.dy <= 0
      args.state.player.dy = 0
  end

  args.state.player.x += args.state.player.dx
  args.state.player.y += args.state.player.dy


  args.outputs.primitives << {x:0, y:0, w:1280, h:720, r: 128, g:128, b: 128}.solid!

  args.outputs.primitives << cone(args)

  args.outputs.primitives << args.state.player

end
