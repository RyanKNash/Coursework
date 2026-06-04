# Ryan K Nash - RKN37
# 11 November 2025
# GoldFly class to represent a special fast gold fly drawable object
# Subclass of Fly

import random
from fly import Fly
import pygame

class GoldFly(Fly):
    def __init__(self, x, y):
        super().__init__(x, y)
        # faster than regular flies
        self.vx = random.choice([-1, 1]) * random.uniform(4.5, 7.0)
        self.vy = random.choice([-1, 1]) * random.uniform(4.5, 7.0)
        self._GoldFly__gold_color = (230, 190, 40)

    def move(self, screen_w, screen_h):
        x, y = self.get_location()
        x += self.vx
        y += self.vy

        # bounce on edges (reverse velocity)
        if x < 0:
            x = 0
            self.vx = abs(self.vx)
        elif x > screen_w - 1:
            x = screen_w - 1
            self.vx = -abs(self.vx)

        if y < 0:
            y = 0
            self.vy = abs(self.vy)
        elif y > screen_h - 1:
            y = screen_h - 1
            self.vy = -abs(self.vy)

        self.set_location((x, y))

    # override draw to be gold-looking
    def draw(self, surface):
        if not self.is_visible:
            return
        x, y = self.get_location()
        body = self._GoldFly__gold_color
        eye  = (255, 255, 255)
        
        pygame.draw.ellipse(surface, body, (x - 5, y - 3, 10, 6))
        pygame.draw.circle(surface, body, (x + 6, y), 3)
        pygame.draw.circle(surface, eye, (x + 7, y - 2), 1)
        pygame.draw.circle(surface, eye, (x + 7, y + 2), 1)
        
        wing_surface = pygame.Surface((20, 20), pygame.SRCALPHA)
        
        pygame.draw.ellipse(wing_surface, (255, 240, 150, 110), (5, 2, 10, 5))
        pygame.draw.ellipse(wing_surface, (255, 240, 150, 110), (5, 10, 10, 5))
        
        surface.blit(wing_surface, (x - 10, y - 10))
