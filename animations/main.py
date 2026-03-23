from manim import *


class MovingWindow(Scene):
    def construct(self):
        rect = Rectangle(fill_color=BLUE, fill_opacity=0.5, height=1.0, width=5.0)
        rectl = Rectangle(
            fill_color=BLACK,
            fill_opacity=0.8,
            stroke_color=BLACK,
            height=1.0,
            width=10.0,
        )
        rectr = Rectangle(
            fill_color=BLACK,
            fill_opacity=0.8,
            stroke_color=BLACK,
            height=1.0,
            width=10.0,
        )
        text = Text("We apologise for the inconvenience").scale(0.8)

        rect.align_to(text, LEFT)
        rectl.next_to(rect, LEFT, buff=0.0)
        rectr.next_to(rect, RIGHT, buff=0.0)

        group = VGroup(rectl, rect, rectr)

        self.play(Create(text))
        self.play(Create(rect))

        self.play(group.animate.move_to([8, 0, 0]), run_time=2, rate_func=linear)
        # self.play(rect.animate.move_to([10, 0, 0]), run_time=2, rate_func=linear)
        # self.play(rect.animate.align_to(text, RIGHT), run_time=2, rate_func=linear)
        self.wait()


class MovingText(Scene):
    def construct(self):
        rect = Rectangle(fill_color=BLUE, fill_opacity=0.5, height=1.0, width=5.0)
        rectl = Rectangle(
            fill_color=BLACK,
            fill_opacity=0.8,
            stroke_color=BLACK,
            height=1.0,
            width=5.0,
        )
        rectr = Rectangle(
            fill_color=BLACK,
            fill_opacity=0.8,
            stroke_color=BLACK,
            height=1.0,
            width=5.0,
        )

        rectl.next_to(rect, LEFT, buff=0.0)
        rectr.next_to(rect, RIGHT, buff=0.0)
        text = Text("We apologise for the inconvenience")
        text.align_to(rect, LEFT)
        rectl.set_z_index(rect.z_index - 1)
        rectr.set_z_index(rect.z_index - 1)
        text.set_z_index(rectl.z_index - 1)
        # circle = Circle()  # create a circle
        # circle.set_fill(PINK, opacity=0.5)  # set color and transparency

        # square = Square()  # create a square
        # square.flip(RIGHT)  # flip horizontally
        # square.rotate(-3 * TAU / 8)  # rotate a certain amount

        self.play(Create(rect))
        self.add(rectl, rectr)
        self.play(Create(text))

        self.play(text.animate.align_to(rectl, RIGHT), run_time=2, rate_func=linear)
        # self.play(text.animate.to_edge(LEFT, buff=0), run_time=2, rate_func=linear)
        self.wait()
        # self.play(Create(square))  # animate the creation of the square
        # self.play(Transform(square, circle))  # interpolate the square into the circle
        # self.play(FadeOut(square))  # fade out animation
