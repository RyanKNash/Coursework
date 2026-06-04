# Ryan K Nash - RKN37
# 11 November 2025
# Heron class to represent a heron drawable object
# Subclass of Drawable

import pygame
import math
from drawable import Drawable
from context import get_screen_context, get_land_bounds

ctx = get_screen_context()
WIDTH = ctx['width']
HEIGHT = ctx['height']

LAND_X, LAND_Y, LAND_W, LAND_H = get_land_bounds()

class Heron(Drawable):
    def __init__(self, x=800, y=100, color_body=(180, 180, 200), color_beak=(230, 200, 50)):
        super().__init__(x, y)
        self.__color_body = color_body
        self.__color_beak = color_beak
        self.__neck_length = 60
        self.__speed = 1.3
        self.__pluck_range = 100  # how close the frog must be to trigger pluck
        self.__is_plucking = False
        self.__pluck_timer = 1
        self.__max_pluck_time = 30
        self.__just_plucked = False

    # --- Movement ---
    def wander(self, target_x, target_y):
        x, y = self.get_location()

        dx = target_x - x
        dy = target_y - y

        dist = math.hypot(dx, dy)
        if dist == 0:
            dir_x, dir_y = 0.0, 0.0
        else:
            dir_x = dx / dist
            dir_y = dy / dist

        new_x = x + dir_x * self.__speed
        new_y = y + dir_y * self.__speed

        # update facing direction based on horizontal movement
        if dir_x != 0:
            self.__direction = 1 if dir_x > 0 else -1

        # clamp to water/shore
        new_x = max(30, min(WIDTH - 30, new_x))
        new_y = max(LAND_Y - 100, min(LAND_Y + 20, new_y))

        self.set_location((new_x, new_y))

    # --- Behavior ---
    def check_and_pluck(self, frog_x, frog_y):
        x, y = self.get_location()
        dist = math.hypot(frog_x - x, frog_y - y)
        if dist < self.__pluck_range and not self.__is_plucking:
            self.__is_plucking = True
            self.__pluck_timer = self.__max_pluck_time
            self.__just_plucked = True

    def consume_pluck_event(self):
        if self.__just_plucked:
            self.__just_plucked = False
            return True
        return False

    def update(self, frog_x, frog_y):
        # Update movement and pluck state each frame.
        if not self.__is_plucking:
            self.wander(frog_x, frog_y)
            self.check_and_pluck(frog_x, frog_y)
        else:
            self.__pluck_timer -= 1
            if self.__pluck_timer <= 0:
                self.__is_plucking = False

    # --- Drawing ---
    def draw(self, surface):
        if not self.is_visible:
            return

        x, y = self.get_location()
        body_height = 50
        body_width = 20
        neck_base_y = y - body_height
        leg_color = (60, 60, 60)

        # --- legs ---
        pygame.draw.line(surface, leg_color, (x - 5, y), (x - 5, y + 20), 3)
        pygame.draw.line(surface, leg_color, (x + 5, y), (x + 5, y + 20), 3)

        # --- body ---
        pygame.draw.ellipse(surface, self.__color_body, (x - body_width // 2, y - body_height, body_width, body_height))

        # --- neck and head ---
        neck_length = self.__neck_length
        if self.__is_plucking:
            # extend neck forward
            neck_length += 50 * (self.__pluck_timer / self.__max_pluck_time)

        neck_angle = -.15
        neck_end_x = x + neck_angle * neck_length
        neck_end_y = neck_base_y + neck_angle * neck_length

        pygame.draw.line(surface, self.__color_body, (x, neck_base_y), (neck_end_x, neck_end_y), 4)

        # --- head ---
        head_radius = 6
        pygame.draw.circle(surface, self.__color_body, (int(neck_end_x), int(neck_end_y)), head_radius)

        # --- beak ---
        beak_length = 15
        beak_tip_x = neck_end_x + math.cos(neck_angle) * beak_length
        beak_tip_y = neck_end_y + math.sin(neck_angle) * beak_length
        pygame.draw.line(surface, self.__color_beak, (neck_end_x, neck_end_y), (beak_tip_x, beak_tip_y), 3)

    def get_bounding_box(self):
        x, y = self.get_location()
        return pygame.Rect(x - 20, y - 60, 40, 60)