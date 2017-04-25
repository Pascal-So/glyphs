# Generating Hamiltonian Cycles in Rectangular Grid Graphs

A couple of days ago, I stumbled upon this tweet by [Benjamin Dale](https://twitter.com/mrbenjamind), along with the reply by [Jerry Vishnevsky](https://twitter.com/mailsprower1):

https://twitter.com/mrbenjamind/status/855537106130796544

https://twitter.com/mailsprower1/status/855908939149561857

I was immediately fascinated by Jerry's question. At a first glance, the answer seemed obvious to me, but after reflecting upon it, I realized that I had only answered the question partially. This post is an attempt at writing these thoughts down to explain my ideas to others (and also kind of to myself).

We start by looking at Benjamin's tweet. He gives us a hint about the algorithm, namely, that he uses a modified version of [Prim's Algorithm](https://en.wikipedia.org/wiki/Prim%27s_algorithm). Prim's Algorithm allows us to efficiently find the MST, the minimum spanning tree, of a graph. Looking at these glyphs, we see that they can all be represented as trees on a rectangular grid.

![The glyphs are actually trees](path/to/image)

To generate one of these glyphs, we therefore just take a rectangular grid graph with random weights and take the MST. Now we just have to choose grid sizes that give us aesthetically pleasing results.

Now looking back at Jerry's question, we might think that this is a completely different problem. After all, he isn't asking for a tree, but rather for a [Hamiltonian cycle](http://mathworld.wolfram.com/HamiltonianCycle.html) on a grid graph. While it might not be obvious from looking at the graph theory terms, one can get an idea of how to go from one to the other by looking at the pictures Jerry includes in his tweet.

![The cycle as an outline](path/to/img)

We notice that we can just take the outline of such a tree and we will always get a hamiltonian cycle on a rectangular grid graph, we just have to double the grid resolution and shift it by half a step in both axes (assuming that we draw the tree with a line width of half the grid width).

![The transformation from tree to cycle]()

This is a nice property, but it seems to be almost too simple. As it turns out, it does indeed generate only a subset of the possible solutions. In other words, there are some cycles on the grid that we can never generate with this method.

![The transformation doesn't generate every possible cycle]()

Now I have nothing against the cycles that we get by taking the outlines of trees, but it would be nice to have access to all the cycles.

![So many cycles to explore...]()

But if you've been studying graph algorithms, there is probably an alarm that went off in your head when I mentioned hamiltonian cycles. "DANGER! SOME NASTY NP-COMPLETE STUFF COMING UP!". [TODO]



The repository with an implementation of Benjamin's glyph generator and the conversion to their outlines can be found here:

https://github.com/Pascal-So/glyphs

Note that I used Kruskal's algorithm to find the MST, not Prim, but that's just personal preference, and I've always been more of a Kruskal person :)

I'm hoping to follow up with an article about the general case soon. I already have some ideas, but didn't manage to prove anything yet, so we'll see how that goes.