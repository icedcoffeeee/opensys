from vispy import app, gloo as gl
from vispy.app.canvas import ResizeEvent

vertex = """
attribute vec2 position;

void main() { gl_Position = vec4(position, 0.0, 1.0); }
"""
fragment = open("main.glsl", "r").read()


class Canvas(app.Canvas):
    def __init__(self):
        super().__init__(size=(1200, 800), title="Ray Test", keys="interactive")

        # Build program
        self.program = gl.Program(vertex, fragment)
        self.program["u_winsize"] = (1200, 800)

        # Set uniforms and attributes
        self.program["position"] = [
            (-1, -1),
            (-1, +1),
            (+1, -1),
            (+1, +1),
        ]

        gl.set_viewport(0, 0, *self.physical_size)
        self.show()

    def on_draw(self, event):
        gl.clear()
        self.program.draw("triangle_strip")

    def on_resize(self, event: ResizeEvent):
        self.program["u_winsize"] = event.physical_size
        gl.set_viewport(0, 0, *event.physical_size)


if __name__ == "__main__":
    Canvas()
    app.run()
