# Ryan K Nash - RKN37
# 11 November 2025
# Fly class to represent a fly drawable object
# Subclass of Drawable, Superclass for different types of flies

from drawable import Drawable
import pygame
from context import get_screen_context

ctx = get_screen_context()
width = ctx['width']
height = ctx['height']

class Fly(Drawable):
    def __init__(self, x=0, y=0):
        super().__init__(x, y)
        self.__color = (0, 0, 0)  # Black for now

    def draw(self, surface):
        if self.is_visible:
            x, y = self.get_location()

            body_color = self.__color           # main black body
            eye_color  = (255, 0, 0)            # red eyes

            # --- Body ---
            pygame.draw.ellipse(surface, body_color, (x - 5, y - 3, 10, 6))

            # --- Head ---
            pygame.draw.circle(surface, body_color, (x + 6, y), 3)

            # --- Eyes ---
            pygame.draw.circle(surface, eye_color, (x + 7, y - 2), 1)
            pygame.draw.circle(surface, eye_color, (x + 7, y + 2), 1)

            # --- Wings ---
            wing_surface = pygame.Surface((20, 20), pygame.SRCALPHA)
            pygame.draw.ellipse(wing_surface, (180, 180, 255, 100), (5, 2, 10, 5))
            pygame.draw.ellipse(wing_surface, (180, 180, 255, 100), (5, 10, 10, 5))
            surface.blit(wing_surface, (x - 10, y - 10))

        
    def get_bounding_box(self):
        x, y = self.get_location()
        radius = 5
        return pygame.Rect(x - radius, y - radius, radius * 2, radius * 2)
        
    def move(self, dx, dy, width, height):
        x, y = self.get_location()
        x += dx
        y += dy

        # Clamp to stay on screen, they kept leaving
        x = max(0, min(x, width))
        y = max(0, min(y, height))

        self.set_location((x, y))