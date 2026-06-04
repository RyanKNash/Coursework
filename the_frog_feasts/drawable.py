# Ryan K Nash - RKN37
# 11 November 2025
# Abstract base class for drawable objects in the game

import pygame
from abc import ABC, abstractmethod

class Drawable(ABC):
    def __init__(self, x=0, y=0):
        self.__x = x
        self.__y = y
        self.is_visible = True
        
    def get_location(self):
        return (self.__x, self.__y)
    
    def set_location(self, position):
        self.__x = position[0]
        self.__y = position[1]
    
    def set_visible(self, visible):
        self.is_visible = visible
    
    
    @abstractmethod
    def get_bounding_box(self) -> pygame.Rect:
        pass
    
    @abstractmethod
    def draw(self, surface):
        pass