# Generating Hamiltonian Cycles in Rectangular Grid Graphs

A couple of days ago, I stumbled upon this tweet by [Benjamin Dale](https://twitter.com/mrbenjamind), along with the reply by [Jerry Vishnevsky](https://twitter.com/mailsprower1):

https://twitter.com/mrbenjamind/status/855537106130796544

https://twitter.com/mailsprower1/status/855908939149561857

I was immediately fascinated by Jerry's question. At a first glance, the answer seemed obvious to me, but after reflecting upon it, I realized that I had only answered the question partially. This post is an attempt at writing these thoughts down to explain my ideas to others (and also kind of to myself).

We start by looking at Benjamin's tweet. He gives us a hint about his algorithm, namely, that he uses a modified version of [Prim's Algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm). Prim's Algorithm allows us to efficiently find the MST, the minimum spanning tree, of a graph. Looking at these glyphs, we see that they can all be represented as trees on a rectangular grid.

![The glyphs are actually trees](path/to/image)

To generate one of these glyphs, we therefore just start with a rectangular grid graph with random weights and take the MST. Now we just have to choose grid sizes that give us aesthetically pleasing results.

Studying Jerry's question, we might think that this is a completely different problem. After all, he isn't asking for a tree, but rather for a [Hamiltonian cycle](http://mathworld.wolfram.com/HamiltonianCycle.html) on a grid graph. And yet there is a connection. While it might not be obvious from looking at the graph theory terms, one can get an idea of how to go from one to the other by looking at the pictures Jerry includes in his tweet.

![The cycle as an outline](path/to/img)

We notice that we can just take the outline of such a tree and we will always get a hamiltonian cycle on a rectangular grid graph, we just have to double the grid resolution and shift it by half a step in both axes (assuming that we draw the tree with a line width of half the grid width).

![The transformation from tree to cycle]()

This is a nice property, but it seems to be almost too simple. As it turns out, it does indeed generate only a subset of the possible solutions. In other words, there are some cycles on the grid that we can never generate with this method.

![The transformation doesn't generate every possible cycle]()

The astute readers will have noticed, that, when we doubled the grid resolution, we automatically limited ourselves to only 2n*2m grids. Now I have nothing against the cycles that we get by taking the outlines of trees, but it would be nice to have access to all the cycles.

![So many cycles to explore...]()

But if you've been studying graph algorithms, there is probably an alarm that went off in your head when I mentioned hamiltonian cycles. "DANGER! SOME NASTY NP-COMPLETE STUFF COMING UP!". Worry not, for we are not dealing with general graphs (for which finding hamiltonian cycles is indeed an np-complete problem). There is actually a very simple solution to finding hamiltonian cycles in grid graphs.

First, we have to realize that we cannot fully get rid of the constraints. The grid still has to be of even size in at least one of the axis, because it is quite easy to prove that we cannot have such a cycle on a n*m grid graph, where n and m are both odd (Hint: try counting the edges of a hypothetical cycle in this graph individually per axis).

Given this 2n * m graph (where m is at least 2), we can always use the following construction:

![General construction for a hamiltonian cycle in a 2n * m graph]()

So there is hope for generating hamiltonian cycles in rectangular grid graph that are not subject to the constraints of the above method. Right now I'm trying to make this MST based algorithm work for the more general grid graph. I have some ideas where this could go, but I haven't been able to prove anything about it yet. Hopefully I will be able to put out a follow-up article soon.

The repository with an implementation of Benjamin's glyph generator and the conversion to their outlines can be found here:

https://github.com/Pascal-So/glyphs

Note that I used Kruskal's algorithm to find the MST, not Prim, but that's just personal preference, and I've always been more of a Kruskal person :)

Thank you to Benjamin Dale for letting me experiment on the basis of his glyph generating algorithm!