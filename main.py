import numpy as np

from vispy import app, gloo as gl
from vispy.app.canvas import DrawEvent, ResizeEvent, MouseEvent

VERT = "attribute vec2 position;\
        void main() { gl_Position = vec4(position, 0.0, 1.0); }"
FRAG = open("main.glsl", "r").read()

SPEED = 0.1


class Canvas(app.Canvas):
    def __init__(self):
        super().__init__(size=(1200, 800), title="Ray Test", keys="interactive")

        # Build program
        self.program = gl.Program(VERT, FRAG)
        self.program["u_winsize"] = (1200, 800)
        self.program["u_pos"] = np.array((0, -5, 0))
        self.program["u_theta"] = 0
        self.program["u_phi"] = 0

        # Set uniforms and attributes
        self.program["position"] = [
            (-1, -1),
            (-1, +1),
            (+1, -1),
            (+1, +1),
        ]

        gl.set_viewport(0, 0, *self.physical_size)
        self.show()

    def on_draw(self, _: DrawEvent):
        gl.clear()
        self.program.draw("triangle_strip")

    def on_resize(self, event: ResizeEvent):
        self.program["u_winsize"] = event.physical_size
        gl.set_viewport(0, 0, *event.physical_size)

    mpos = np.zeros(2)

    def on_mouse_move(self, event: MouseEvent):
        if event.is_dragging:
            dm = event.pos - self.mpos
            self.program["u_theta"] += dm[0] / 1000
            self.program["u_phi"] += dm[1] / 1000
            self.update()

        self.mpos = event.pos

    def on_mouse_wheel(self, event: MouseEvent):
        y = self.program["u_pos"][1]
        self.program["u_pos"] = np.array((0, y + SPEED * event.delta[1], 0))
        self.update()


if __name__ == "__main__":
    Canvas()
    app.run()
