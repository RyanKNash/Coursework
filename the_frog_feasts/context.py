# Ryan K Nash - RKN37
# 11 November 2025
# Context file to ensure consistent screen dimensions across modules

def get_screen_context():
    return {
        'width': 1000,
        'height': 800
    } 
    
def get_land_bounds():
    ctx = get_screen_context()
    width = ctx['width']
    height = ctx['height']

    top_of_land = height // 3
    land_height = height - top_of_land

    return (0, top_of_land, width, land_height)