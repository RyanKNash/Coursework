# Ryan K Nash - RKN37
# 11 November 2025
# Snake class to represent a snake drawable object
# Subclass of Drawable

from drawable import Drawable
import pygame
import math
from context import get_screen_context, get_land_bounds

ctx = get_screen_context()
WIDTH = ctx['width']
HEIGHT = ctx['height']


class Snake(Drawable):
    def __init__(self, x=800, y=500, segment_size=16, length=20, color=(0, 200, 0)):
        """
        segment_size = visual thickness of the snake (diameter-ish of each body chunk)
        length = how many chunks in the body
        """
        super().__init__(x, y)
        self.__segment_size = segment_size
        self.__color = color

        # body[0] is the head. Each element is [x, y] for that segment.
        self.body = []
        for i in range(length):
            # Lay the body out horizontally to start
            # 0.8 spacing means overlap so it looks continuous
            self.body.append([x - i * (segment_size * 0.8), y])

        # movement speed in pixels per frame
        self.speed = 4.5

    def chase(self, target_x, target_y):
        # Move head toward the frog, pull the rest of the body behind.
        head_x, head_y = self.body[0]

        # Where is land?
        land_x, land_y, land_w, land_h = get_land_bounds()

        # direction from head to target
        dx = target_x - head_x
        dy = target_y - head_y

        dist = math.hypot(dx, dy)
        if dist == 0:
            dir_x, dir_y = 0, 0
        else:
            dir_x = dx / dist
            dir_y = dy / dist

        # new head position before clamping
        new_head_x = head_x + dir_x * self.speed
        new_head_y = head_y + dir_y * self.speed

        # Clamp snake inside land area
        s = self.__segment_size
        new_head_x = max(land_x, min(new_head_x, land_x + land_w - s))
        new_head_y = max(land_y, min(new_head_y, land_y + land_h - s))

        # Insert new head at the front of the body list
        self.body.insert(0, [new_head_x, new_head_y])

        # Remove LAST segment to keep total length constant
        self.body.pop()

        # sync Drawable head position
        self.set_location((new_head_x, new_head_y))

    def draw(self, surface):
        if self.is_visible:
            # segment_size is basically diameter-ish.
            segment_size = self.__segment_size

            # tune these to get the stretched snake look
            body_width = int(segment_size * 2)    # left-right length of each segment
            body_height = int(segment_size * 1.2)   # thickness of each segment

            # --- Draw tail/body first ---
            # reversed(self.body[1:]) draws tail first, leaves index 0 (head) for last
            body_len = len(self.body)
            for i, (bx, by) in enumerate(reversed(self.body[1:])):
                # subtle tail shading: closer to tail = darker
                t = i / max(1, body_len)  # 0 → near head, 1 → near tail
                shade_factor = 0.8 + (0.2 * (1 - t))  # ~1.0 near head, ~0.8 tail

                seg_color = (
                    int(self.__color[0] * shade_factor),
                    int(self.__color[1] * shade_factor),
                    int(self.__color[2] * shade_factor)
                )

                pygame.draw.ellipse(
                    surface,
                    seg_color,
                    (
                        int(bx - body_width // 2),
                        int(by - body_height // 2),
                        body_width,
                        body_height
                    )
                )

            # --- Head ---
            head_x, head_y = self.body[0]
            head_x, head_y = int(head_x), int(head_y)

            pygame.draw.ellipse(
                surface,
                self.__color,
                (
                    head_x - body_width // 2,
                    head_y - body_height // 2,
                    body_width,
                    body_height
                )
            )

            # --- Eyes (so you know which end kills you) ---
            eye_color = (0, 0, 0)
            eye_offset_x = int(body_width * 0.25)
            eye_offset_y = int(body_height * 0.3)

            pygame.draw.circle(
                surface,
                eye_color,
                (head_x + eye_offset_x, head_y - eye_offset_y),
                max(1, segment_size // 4)
            )
            pygame.draw.circle(
                surface,
                eye_color,
                (head_x + eye_offset_x, head_y + eye_offset_y),
                max(1, segment_size // 4)
            )

    def get_bounding_box(self):
        head_x, head_y = self.body[0]
        s = self.__segment_size
        return pygame.Rect(
            head_x - s // 2,
            head_y - s // 2,
            s,
            s
        )
