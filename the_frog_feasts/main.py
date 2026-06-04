# Ryan K Nash - RKN37
# 11 November 2025
# Main game file, contains the main loop and game logic
# I ran out of time to move some logic into classes/modules, sorry!

import pygame
import random
import math
from frog import Frog
from fly import Fly
from gold_fly import GoldFly
from text import Text
from snake import Snake
from lilypad import LilyPad
from heron import Heron
from endgame import EndGame
from context import get_screen_context, get_land_bounds
from enum import Enum

# Helper class (saves alot on if blocks)
class DeathType(Enum):
    NONE = 0
    SNAKE = 1
    FISH = 2
    HERON = 3

# --- screen / world context ---
ctx = get_screen_context()
WIDTH = ctx['width']
HEIGHT = ctx['height']
LAND_X, LAND_Y, LAND_W, LAND_H = get_land_bounds()

# --- setup ---
pygame.init()

fps = 60
surface = pygame.display.set_mode((WIDTH, HEIGHT))
clock = pygame.time.Clock()
running = True
end_ui = EndGame(x=WIDTH//2, y=HEIGHT//2, message="Game Over", score=0, color=(255,255,255))
state = "START"
death_type = DeathType.NONE
death_timer = 0
DEATH_DURATION = 180

# initialize enemy entities
snake = Snake(
    x=WIDTH - 100,
    y=HEIGHT - 100,
    segment_size=20,
    length=60,
    color=(180, 30, 40)
)
heron = Heron()

score_text = Text(10, 10, "Score: 0")
frog = Frog(50, 300, 20, 20)  # Player-controlled frog

gold_flies = []  # list of gold flies to eat
flies = [] # list of flies to eat
lilypads = [] # list of lily pads to hop/rest on
score = 0

# water danger state, enemy fish without an actual fish object
water_line_y = LAND_Y # top of land == bottom of water
water_timeout = 180 # 3 seconds at 60fps
water_timer = 0 # how long frog's been in unsafe water

# --- helper functions ---
def draw_death_visuals(surface):
    if death_type == DeathType.SNAKE:
        # draw a quick "bloat" on snake head
        hx, hy = snake.body[0]  # head
        grow = 1.0 + 0.6 * (death_timer / DEATH_DURATION)
        bw = int(snake._Snake__segment_size * 2 * grow)
        bh = int(snake._Snake__segment_size * 1.2 * grow)
        pygame.draw.ellipse(surface, (160, 50, 50),
                            (int(hx - bw//2), int(hy - bh//2), bw, bh))
    elif death_type == DeathType.FISH:
        # fish face just under frog
        fx, fy = frog.get_location()
        face_y = max(0, fy - 12)
        # simple triangle mouth + eye, could use a lot more detail
        pygame.draw.polygon(surface, (30,30,30),
                            [(fx, face_y), (fx-18, face_y+10), (fx+18, face_y+10)])
        pygame.draw.circle(surface, (220,220,220), (fx-8, face_y-8), 3)
        pygame.draw.circle(surface, (0,0,0), (fx-8, face_y-8), 1)
    elif death_type == DeathType.HERON:
        # draw a little frog shape near heron beak direction
        hx, hy = heron.get_location()
        # approximate a forward offset from neck base; positive x when facing right
        facing = 1  # if you track direction, swap based on it
        bx = hx + 28 * (1 if facing > 0 else -1)
        by = hy - 48
        pygame.draw.ellipse(surface, (0, 200, 0), (bx-10, by-6, 20, 12))

def trigger_death(d_type, reason_text):
    global state, death_type, death_timer
    state = "DEAD"
    death_type = d_type
    death_timer = DEATH_DURATION
    end_ui.set_message(reason_text, score)

def spawn_fly_away_from_frog(frog, min_distance, screen_w, screen_h, FlyClass=Fly):
    frog_x, frog_y = frog.get_location()
    while True:
        x = random.randint(0, screen_w - 1)
        y = random.randint(0, screen_h - 1)
        dx = x - frog_x
        dy = y - frog_y
        if math.hypot(dx, dy) >= min_distance:
            return FlyClass(x, y)

def draw_background(surface, screen_w, screen_h, shore_y):
    # Water (top region)
    pygame.draw.rect(surface, (30, 60, 180), (0, 0, screen_w, shore_y))

    # Land (bottom region)
    pygame.draw.rect(surface, (30, 120, 30), (0, shore_y, screen_w, screen_h - shore_y))

    # Shoreline strip for flavor
    pygame.draw.line(surface, (200, 200, 100), (0, shore_y), (screen_w, shore_y), 30)      

# --- initial spawn of flies ---
for _ in range(20):
    new_fly = spawn_fly_away_from_frog(frog, 100, WIDTH, HEIGHT)
    flies.append(new_fly)

for _ in range(2):
    new_gold_fly = spawn_fly_away_from_frog(frog, 150, WIDTH, HEIGHT, FlyClass=GoldFly)
    gold_flies.append(new_gold_fly)

# --- initial spawn of lily pads ---
for _ in range(5):
    x = random.randint(50, WIDTH - 50)
    y = random.randint(50, water_line_y - 50)  # keep them in water region
    lilypads.append(LilyPad(x, y, radius=40))

# --- draw start screen ---
def draw_start_screen(surface):
    font_big = pygame.font.SysFont(None, 72)
    font = pygame.font.SysFont(None, 32)

    title = font_big.render("The Frog Feasts", True, (255,255,255))
    trect = title.get_rect(center=(WIDTH//2, HEIGHT//2 - 180))

    controls = [
        "Controls:",
        "W/A/S/D - Move Frog",
        "",
        "Eat flies to score",
        "+1 per Fly",
        "+10 per Gold Fly",
        "",
        "Avoid the snake, fish, and heron!",
        "",
        "Press SPACE to start",
        "Press ESC to exit"
    ]

    # shadow for title
    shadow = font_big.render("The Frog Feasts", True, (0,0,0))
    surface.blit(shadow, trect.move(2,2))
    surface.blit(title, trect)

    y = HEIGHT//2 - 20
    for line in controls:
        text = font.render(line, True, (255,255,255))
        rect = text.get_rect(center=(WIDTH//2, y))
        shadow = font.render(line, True, (0,0,0))
        surface.blit(shadow, rect.move(2,2))
        surface.blit(text, rect)
        y += 30

# --- reset game function ---
def reset_game():
    global frog, snake, heron, flies, gold_flies, lilypads
    global score, water_timer, state, death_type

    score = 0
    water_timer = 0
    state = "PLAY"
    death_type = DeathType.NONE

    frog = Frog(50, 300, 20, 20)

    snake = Snake(
        x=WIDTH - 100,
        y=HEIGHT - 100,
        segment_size=20,
        length=60,
        color=(180, 30, 40)
    )
    heron = Heron()

    flies = []
    for _ in range(20):
        flies.append(spawn_fly_away_from_frog(frog, 100, WIDTH, HEIGHT))

    gold_flies = []
    for _ in range(2):
        gold_flies.append(spawn_fly_away_from_frog(frog, 150, WIDTH, HEIGHT, FlyClass=GoldFly))

    lilypads = []
    for _ in range(5):
        x = random.randint(50, WIDTH - 50)
        y = random.randint(50, water_line_y - 50)
        lilypads.append(LilyPad(x, y, radius=40))

# --- draw restart hint ---
def draw_restart_hint(surface):
    font = pygame.font.SysFont(None, 28)
    hint = font.render("Press SPACE to restart • ESC to quit", True, (255, 255, 255))
    rect = hint.get_rect(center=(WIDTH // 2, HEIGHT // 2 - 60))
    shadow = font.render("Press SPACE to restart • ESC to quit", True, (0, 0, 0))
    surface.blit(shadow, rect.move(2, 2))
    surface.blit(hint, rect)

#===========================================
# ------- main loop --------
#===========================================
while running:
    # draw background
    surface.fill((0, 10, 100))
    draw_background(surface, WIDTH, HEIGHT, water_line_y)
    
    # ---- handle events (quit, ESC, restart) ----
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        elif event.type == pygame.KEYDOWN:

            # ESC always quits
            if event.key == pygame.K_ESCAPE:
                running = False

            # START screen
            if state == "START":
                if event.key == pygame.K_SPACE:
                    state = "PLAY"

            # DEAD screen restart
            elif state == "DEAD":
                if event.key == pygame.K_SPACE:
                    reset_game()

    # --- START SCREEN ---
    if state == "START":
        draw_start_screen(surface)
        pygame.display.update()
        clock.tick(fps)
        continue

    # --- PLAYING STATE ---
    if state == "PLAY":
        # ---- frog movement (player input) ----
        keys = pygame.key.get_pressed()
        fx, fy = frog.get_location()

        # Control speed with variables below
        if keys[pygame.K_w]:
            fy -= 4.5
        if keys[pygame.K_s]:
            fy += 4.5
        if keys[pygame.K_a]:
            fx -= 4.5
        if keys[pygame.K_d]:
            fx += 4.5

        # clamp frog to screen
        fx = max(0, min(fx, WIDTH - 30))
        fy = max(0, min(fy, HEIGHT - 20))
        frog.set_location((fx, fy))

        # ---- snake AI: chase frog ----
        frog_box = frog.get_bounding_box()
        frog_center_x = frog_box.centerx
        frog_center_y = frog_box.centery
        snake.chase(frog_center_x, frog_center_y)

        # ---- heron AI: wander + pluck ----
        heron.update(frog_center_x, frog_center_y)
        if heron.consume_pluck_event() and state == "PLAY":
            trigger_death(DeathType.HERON, "The heron plucked you up.")

        # snake eats frog
        if snake.get_bounding_box().colliderect(frog.get_bounding_box()):
            trigger_death(DeathType.SNAKE, "The snake swallowed you.")

        # ---- flies update + eating logic ----
        eaten_flies = []
        for f in flies:
            # jitter movement, clamp inside screen using WIDTH/HEIGHT
            f.move(random.randint(-5, 5), random.randint(-5, 5), WIDTH, HEIGHT)

            # collision = frog eats the fly
            if frog_box.colliderect(f.get_bounding_box()):
                score += 1
                eaten_flies.append(f)

        eaten_gold_flies = []
        for gf in gold_flies:
            gf.move(WIDTH, HEIGHT)  # bounce logic inside GoldFly.move

            if frog_box.colliderect(gf.get_bounding_box()):
                score += 10
                eaten_gold_flies.append(gf)

        for dead in eaten_gold_flies:
            gold_flies.remove(dead)
            gold_flies.append(spawn_fly_away_from_frog(frog, 150, WIDTH, HEIGHT, FlyClass=GoldFly))

        # remove eaten flies and spawn replacements
        for dead in eaten_flies:
            flies.remove(dead)
            flies.append(spawn_fly_away_from_frog(frog, 100, WIDTH, HEIGHT))

        # ---- water danger / fish timer ----
        # frog is "in water" if its y is above the shoreline
        frog_x, frog_y = frog.get_location()
        in_water = frog_y < water_line_y

        # check if frog is on a lilypad
        on_pad = False
        frog_box = frog.get_bounding_box()
        for pad in lilypads:
            if frog_box.colliderect(pad.get_bounding_box()):
                on_pad = True
                break

        if not in_water:
            # frog is on land, safe from fish
            water_timer = 0
        elif on_pad:
            # frog is in water but standing on a lilypad, safe from fish
            water_timer = 0
        else:
            # frog is in open water fish is charging up
            water_timer += 1

        if water_timer >= water_timeout:
            trigger_death(DeathType.FISH, "The fish dragged you under.")

    if in_water and not on_pad:
        danger_ratio = water_timer / water_timeout  # 0.0 -> 1.0
        danger_ratio = max(0.0, min(danger_ratio, 1.0))

        # draw a "fish shadow" under the frog that grows / darkens
        frog_center = frog.get_bounding_box().center
        fx_center, fy_center = frog_center

        # radius grows with danger
        shadow_radius = int(20 + 40 * danger_ratio)  # starts small, gets scary

        # semi-transparent dark ellipse / circle to represent a fish coming up
        shadow_surface = pygame.Surface((shadow_radius * 2, shadow_radius * 2), pygame.SRCALPHA)

        pygame.draw.ellipse(
            shadow_surface,
            (0, 0, 0, int(80 + 120 * danger_ratio)),
            (0, 0, shadow_radius * 2, shadow_radius * 2)
        )

        # center the shadow where the frog is
        surface.blit(
            shadow_surface,
            (fx_center - shadow_radius, fy_center - shadow_radius)
        )

    # ---- draw world objects ----
    for pad in lilypads:
        pad.draw(surface)

    for f in flies:
        f.draw(surface)

    for gf in gold_flies:
        gf.draw(surface)

    frog.draw(surface)
    snake.draw(surface)
    heron.draw(surface)

    score_text.set_content(f"Score: {score}")
    score_text.draw(surface)

    # --- DEAD STATE ---
    if state == "DEAD":
        end_ui.update()
        draw_death_visuals(surface)
        end_ui.draw(surface)
        draw_restart_hint(surface)


    pygame.display.update()
    clock.tick(fps)

pygame.quit()
exit()
