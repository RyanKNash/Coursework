# Ryan K Nash - RKN37
# 11 November 2025
# LilyPad class to represent a lily pad drawable object
# Subclass of Drawable

from drawable import Drawable
import pygame
from context import get_screen_context

ctx = get_screen_context()
width = ctx['width']
height = ctx['height']

class LilyPad(Drawable):
    def __init__(self, x=0, y=0, radius=25, color=(0, 180, 20)):
        super().__init__(x, y)
        self.__radius = radius
        self.__color = color

    def draw(self, surface):
        if self.is_visible:
            x, y = self.get_location()
            pygame.draw.circle(surface, self.__color, (x, y), self.__radius)

    def get_bounding_box(self):
        x, y = self.get_location()
        return pygame.Rect(x - self.__radius, y - self.__radius, self.__radius * 2, self.__radius * 2)
