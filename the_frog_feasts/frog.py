# Ryan K Nash - RKN37
# 11 November 2025
# Frog class to represent a frog drawable object
# Subclass of Drawable

from drawable import Drawable
import pygame

class Frog(Drawable):
    def __init__(self, x, y, width, height):
        super().__init__(x, y)
        self.__width = width
        self.__height = height
        self.__color = (0, 200, 0)

    def draw(self, surface):
        if self.is_visible:
            x, y = self.get_location()

            body_color = self.__color  # main green body
            eye_color = (255, 255, 255)
            pupil_color = (0, 0, 0)
            leg_color = (20, 150, 20)

            # --- Body ---
            pygame.draw.ellipse(surface, body_color, (x, y, 35, 25))

            # --- Hind legs ---
            pygame.draw.circle(surface, leg_color, (x + 8, y + 22), 6)
            pygame.draw.circle(surface, leg_color, (x + 28, y + 22), 6)

            # --- Front legs ---
            pygame.draw.circle(surface, leg_color, (x + 5, y + 5), 4)
            pygame.draw.circle(surface, leg_color, (x + 30, y + 5), 4)

            # --- Eyes ---
            pygame.draw.circle(surface, eye_color, (x + 10, y - 2), 4)
            pygame.draw.circle(surface, eye_color, (x + 25, y - 2), 4)

            # Pupils
            pygame.draw.circle(surface, pupil_color, (x + 10, y - 2), 2)
            pygame.draw.circle(surface, pupil_color, (x + 25, y - 2), 2)

            # mouth line
            pygame.draw.line(surface, (0, 0, 0), (x + 10, y + 15), (x + 25, y + 15), 1)
            
    def get_bounding_box(self):
        return pygame.Rect(self.get_location()[0], self.get_location()[1], self.__width, self.__height)