# Ryan K Nash - RKN37
# 11 November 2025
# Text class to represent a text drawable object
# Subclass of Drawable

from drawable import Drawable
import pygame

class Text(Drawable):
    def __init__(self, x=0, y=0, content="", color=(255, 255, 255), size=36):
        super().__init__(x, y)
        self.__content = content
        self.__color = color
        self.__font = pygame.font.Font(None, size)  # default font and size

    def set_content(self, content):
        self.__content = content

    def get_content(self):
        return self.__content

    def draw(self, surface):
        if self.is_visible:
            x, y = self.get_location()
            text_surface = self.__font.render(self.__content, True, self.__color)
            surface.blit(text_surface, (x, y))

    # Drawable requires a bounding box
    def get_bounding_box(self):
        x, y = self.get_location()
        text_surface = self.__font.render(self.__content, True, self.__color)
        return text_surface.get_rect(topleft=(x, y))
