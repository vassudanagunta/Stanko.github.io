+++
title = "CSS only sprite animations"
aliases = ["/css-only-frame-animations/", "/blog/css-only-frame-animations/"]

[taxonomies]
category = ["CSS/SASS"]
tags = ["animation", "css", "sass"]

[extra]
comments = [
  "comments/css-only-sprite-animations/1610737824553.toml"
]
image = "/img/rm/frame_10.png"
+++

I haven't published anything in a while, which is a shame because I have a couple of good things to write about. That said, today's post is going to be a short one. I wasn't sure if theme is interesting enough. But in the end I decided to write it anyway. And it will help me get back in the writing shape.

While setting up a new project on Netlify, I was going through the logs and noticed they are using
{{ sidenote(text="old school", note="
As far as I know people started using it back in the 80s.
") }}
text only loader. It is a very simple animation swapping between four text characters (`—`, `\`, `|`, `/`).

![Text loader animation](/img/retro-loader.gif)

<!-- more -->

Haven't even checked if they are using gif or not, but immediately tried recreating it using CSS only.

## The first version

The first thing I tried was to stack frames one of top of the other, and then animate every frame separately.

Animation will make element visible only for the duration of one frame. Then using `animation-delay` we can adjust each frame. Code for four frames looked something like this:


```scss
$frame-duration: 125ms;

@keyframes frame-animation {
  0%,
  25% {
    opacity: 1;
  }
  // Make opacity transition from 1 to 0 as short as possible
  25.01% {
    opacity: 0;
  }
}

// Add delay for each frame
@for $i from 1 through 4 {
  .Animation-frame:nth-child(#{ $i }) {
    animation-delay: 250ms * ($i - 1);
  }
}
```

This worked well for our retro loader with four frames. Then I tried to animate images in the same way and again it worked fine.

But if tab went to background, once you focus it back, animation would flicker before normalizing. My guess it happens because browsers optimize timers in background tabs. Plus I used twelve frames, and having twelve animations in a perfect sync sounds expensive.

Applying common hacks to activate hardware acceleration didn't help, so I went back to the drawing board.

## Animation steps to the rescue

First order of business was to try to remove animations for individual frames, and use only one on the parent element. And to do it without JavaScript. Something like a slider, where slides are swapped without animation.

Then it hit me! I remembered seeing that CSS animations can use steps. So I searched for it and found out the syntax:

```scss
  animation-timing-function: steps(4);
```

What MDN says about steps:

> Displays an animation iteration along n stops along the transition, displaying each stop for equal lengths of time.

In other words, it allows us to create frame-by-frame animation by chopping down the animation to exact number of steps and switching between them.

This allows to apply only one animation on the wrapper element and cut it down to frames. You can see the code below, but I also created a [template on codepen](https://codepen.io/stanko/pen/zVJvLa) you can play with. If you create something fun, please share it in the comments.

```scss
$time: 1000ms;
$number-of-frames: 10;
$frame-duration: $time / $number-of-frames;

@keyframes frame-animation {
  100% {
    transform: translateX(-100%);
  }
}

.Animation {
  overflow: hidden;
}

.Animation-frames {
  animation: frame-animation $time infinite;
  animation-timing-function: steps($number-of-frames);
  display: flex;
  // Frames wrapper is $number-of-frames wider than the animation itself
  width: $number-of-frames * 100%;
}

.Animation-frame {
  display: block;
  // Frame should be same width as the animation, so we need to divide with $number-of-frames
  flex-basis: 100% / $number-of-frames;
  max-width: 100% / $number-of-frames;
  width: 100% / $number-of-frames;
}
```

## Final result

Retro loader I tried to replicate in the first place:

{{ codepen(
  id="XLYRQV",
  title="CSS only retro CLI loader",
  height=300
) }}

After I've done the retro loader, I thought it would be fun to animate some images, preferably
{{ sidenote(text="pixel art", note="
I loooove pixel art
") }}.
So I found this nifty [Rick and Morty animation](https://www.artstation.com/artwork/YEJeY) and animated it in CSS.


{{ codepen(
  id="GbBqwZ",
  title="CSS Frame animation (Rick and Morty)",
  height=500
) }}

## Conclusion

Primarily I did it for fun and to challenge myself.

And you are probably not going to use it on a daily basis, but this method can actually be useful. Cool thing is that animation frame can be
{{ sidenote(text="anything", note="
Well, anything you can create in HTML :)
") }}
, not just images or text. Although if you want to use images, it might be smarter to use a sprite instead of individual frames.

If you end up using it, I would love to see the results.
