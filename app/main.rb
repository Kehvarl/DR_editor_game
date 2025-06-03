require('app/map_editor.rb')

# Some physics constants
GRAVITY = -0.2
MAX_FALL_SPEED = -5.0
JUMP_VELOCITY = 4.0
BOUNCE_VELOCITY = 6.0
FAST_FALL_GRAVITY = -0.4

def init args
  args.state.terrain = read_terrain_data args

  args.state.player = {
    x: 320,
    y: 320,
    w: 32,
    h: 32,
    dx: 0,
    dy: 0,
    path: 'sprites/square/red.png'
  }

end

def tick_game args
  # render terrain and player
  args.outputs.sprites << args.state.terrain
  args.outputs.sprites << args.state.player

  # set dx and dy based on inputs
  args.state.player.dx = args.inputs.left_right * 2
  args.state.player.dy = args.inputs.up_down * 2

  # check for collisions on the x and y axis independently

  # increment the player's position by dx
  args.state.player.x += args.state.player.dx

  # check for collision on the x axis first
  collision = args.state.terrain.find { |t| t.intersect_rect? args.state.player }

  # if there is a collision, move the player to the edge of the collision
  # based on the direction of the player's movement and set the player's
  # dx to 0
  if collision
    if args.state.player.dx > 0
      args.state.player.x = collision.x - args.state.player.w
    elsif args.state.player.dx < 0
      args.state.player.x = collision.x + collision.w
    end
    args.state.player.dx = 0
  end

  # increment the player's position by dy
  args.state.player.y += args.state.player.dy

  # check for collision on the y axis next
  collision = args.state.terrain.find { |t| t.intersect_rect? args.state.player }

  # if there is a collision, move the player to the edge of the collision
  # based on the direction of the player's movement and set the player's
  # dy to 0
  if collision
    if args.state.player.dy > 0
      args.state.player.y = collision.y - args.state.player.h
    elsif args.state.player.dy < 0
      args.state.player.y = collision.y + collision.h
    end
    args.state.player.dy = 0
  end
end


def tick args
  if Kernel.tick_count == 0
    init args
  end

  # tick the game (where input and aabb collision is processed)
  tick_game args

  # tick the map editor
  tick_map_editor args
end
