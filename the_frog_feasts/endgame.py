# Ryan K Nash - RKN37
# 11 November 2025
# EndGame class to display end-of-game messages

import pygame
from drawable import Drawable

class EndGame(Drawable):
    def __init__(self, x=0, y=0, message="Game Over", score=0, color=(255, 255, 255), size=72):
        super().__init__(x, y)
        self.__message = message
        self.__score = score
        self.__color = color
        self.__font_big = pygame.font.Font(None, size)
        self.__font_small = pygame.font.Font(None, max(24, size // 3))
        self.__alpha = 0
        self.__alpha_max = 200
        self.__alpha_speed = 10

    def set_message(self, message, score):
        self.__message = message
        self.__score = score
        self.__alpha = 0 

    def update(self):
        self.__alpha = min(self.__alpha_max, self.__alpha + self.__alpha_speed)

    def draw(self, surface):
        if not self.is_visible:
            return
        w, h = surface.get_size()
        overlay = pygame.Surface((w, h), pygame.SRCALPHA)
        overlay.fill((0, 0, 0, self.__alpha))
        surface.blit(overlay, (0, 0))

        x, y = self.get_location()
        title_surf = self.__font_big.render(self.__message, True, self.__color)
        score_surf = self.__font_small.render(f"Score: {self.__score}", True, self.__color)

        surface.blit(title_surf, title_surf.get_rect(center=(x, y)))
        surface.blit(score_surf, score_surf.get_rect(center=(x, y + 60)))

    # Drawable requires a bounding box
    def get_bounding_box(self):
        x, y = self.get_location()
        text_surface = self.__font.render(self.__content, True, self.__color)
        return text_surface.get_rect(topleft=(x, y))